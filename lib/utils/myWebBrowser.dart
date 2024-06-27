import 'dart:io';

import 'package:dio/dio.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'loader.dart';

class MyInAppBrowser extends InAppBrowser {
  var token;
  var context;
  ValueNotifier downloadProgressNotifier = ValueNotifier(0);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  MyInAppBrowser();

  Future<void> _showProgressNotification(int progress, int maxProgress) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('progress_channel', 'Progress Channel',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress);
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Downloading PDF file...',
        '$progress%',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> downloadFileFromServer(String pdfUrl) async {
    downloadProgressNotifier.value = 0;
    Directory directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    // Combine the base directory path with the specific folder
    Directory targetDirectory = Directory('${directory.path}/Scaleup');
    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    String filePath = '${targetDirectory.path}/scaleup_emi_document.pdf';
    await Dio().download(
      pdfUrl,
      filePath,
      onReceiveProgress: (actualBytes, totalBytes) async {
        int progress = ((actualBytes / totalBytes) * 100).floor();
        downloadProgressNotifier.value = progress;

        // Show or update the progress notification
        await _showProgressNotification(progress, 100);
      },
    );
    // Show completion notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'File downloaded at $filePath',
      const NotificationDetails(
        android: AndroidNotificationDetails('download_channel', 'File Download',
            importance: Importance.max, priority: Priority.high),
      ),
    );
  }

  @override
  Future onBrowserCreated() async {
   // Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage){
    if(consoleMessage.messageLevel==1 && consoleMessage.message=="Back To Flutter App"){
      close();
      if (kDebugMode) {
        print("ShopKirana ${consoleMessage.message}");
      }
    }else if(consoleMessage.messageLevel==1 && consoleMessage.message.contains("DownloadEMIPDF")){
      String pdf = consoleMessage.message;
      const String removePdfPart = 'DownloadEMIPDF';
      final String finalPdfPart = pdf.replaceFirst(RegExp(r'^' + removePdfPart + r'\s*'), '').trim();
      if (kDebugMode) {
        print('Final pdf part: $finalPdfPart');
      }
      downloadFileFromServer(finalPdfPart);
    }
    super.onConsoleMessage(consoleMessage);
  }


  @override
  Future onLoadStart(url) async {
    print("Started $url");
    const Loader();
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $token");
    await webViewController?.evaluateJavascript(source: "_callJavaScriptFunction('${token}')");

  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser  closed!");
  }

}