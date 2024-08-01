import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../PdfView.dart';
import 'directory_path.dart';
import 'loader.dart';
import 'local_notifications.dart';

class MyInAppBrowser extends InAppBrowser {
  var token;
  var context;
  var UserID;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();
  ValueNotifier downloadProgressNotifier = ValueNotifier(0);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  MyInAppBrowser();

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title??''),
        content: Text(body??''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {

            },
          )
        ],
      ),
    );
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
        await OpenFile.open(filePath);
      },
    );

   /* // Show completion notification
    await LocalNotifications.showSimpleNotification(
        title: "Download Complete",
        body: "File downloaded at $filePath",
        payload: filePath);*/
  }

  @override
  Future onBrowserCreated() async {
    // Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    if (consoleMessage.messageLevel == 1 &&
        consoleMessage.message == "Back To Flutter App") {
      close();
      if (kDebugMode) {
        print("ShopKirana ${consoleMessage.message}");
      }
    } else if (consoleMessage.messageLevel == 1 && consoleMessage.message.contains("DownloadEMIPDF")) {
      String pdf = consoleMessage.message;
      const String removePdfPart = 'DownloadEMIPDF';
      final String finalPdfPart = pdf.replaceFirst(RegExp(r'^' + removePdfPart + r'\s*'), '').trim();
      if (kDebugMode) {
        print('Final pdf part: $finalPdfPart');
      }
      /*Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PdfView(data: finalPdfPart)));*/
     // downloadFileFromServer(finalPdfPart);
      Uri uri = Uri.parse(finalPdfPart);
      onDownloadStart(uri);

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
    await webViewController?.evaluateJavascript(source: "_getUserIdFromFlutterApp('${UserID}')");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onDownloadStart(Uri url) {
    super.onDownloadStart(url);
    // print("onDownloadStart $url");
    final String _url_files = "$url";
    void _launchURL_files() async =>
        await canLaunch(_url_files) ? await launch(_url_files) : throw 'Could not launch $_url_files';
    _launchURL_files();
  }

  @override
  void onExit() {
    print("Browser  closed!");
  }
}
