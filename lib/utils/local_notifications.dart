import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null && payload.isNotEmpty) {
      print("Notification tapped with payload: $payload"); // For debugging
      _openPdfFromUrl(payload);
    } else {
      print("No payload in the notification");
    }
  }

  // initialize the local notifications
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // show a simple notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'scaleup', 'scaleup',
      channelDescription: 'scaleup',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showProgressNotification(
      int progress, int maxProgress, String payload) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'scaleup', 'Progress Channel',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress,
        actions: [
          AndroidNotificationAction(
              'action_1', 'Open', showsUserInterface: true
          ),
        ]);

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      3, 'Downloading PDF file...', '$progress%', platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> _openPdfFromUrl(String url) async {
    if (await canLaunch(url)) {
      print("Opening PDF from URL: $url"); // For debugging
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // close a specific channel notification
  static Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
