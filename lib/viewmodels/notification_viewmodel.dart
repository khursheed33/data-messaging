import 'package:data_messaging/enum/notification_channels.dart';
import 'package:data_messaging/enum/notification_topics.dart';
import 'package:data_messaging/extensions/format_string.dart';
import 'package:data_messaging/extensions/logger.dart';
import 'package:data_messaging/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationModel _currentNotification = NotificationModel(
    id: "0",
    title: "Data Messaing Demo",
    body: "Khursheed 24",
  );

  NotificationModel get currentNotification => _currentNotification;

  void setCurrentNotification(NotificationModel notificationModel) {
    _currentNotification = notificationModel;
    notifyListeners();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initialize() async {
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    _flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (message) async {
        "MSG::$message".log();
      },
    );

    FirebaseMessaging.instance.subscribeToTopic(
      NotificationTopics.all_devices.name,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null &&
          message.notification!.title != null &&
          message.notification!.body != null &&
          message.notification!.title!.isNotEmpty &&
          message.notification!.body!.isNotEmpty &&
          true) {
        BigTextStyleInformation bigTextStyleInformation =
            BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContent: true,
        );

        AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          NotificationChannels.marketing.name,
          NotificationChannels.marketing.name.toTitleCase(),
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
        );

        NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: const DarwinNotificationDetails(),
        );

        final newMsg = NotificationModel(
          id: "${message.messageId}",
          title: "${message.notification!.title}",
          body: " ${message.notification!.body}",
        );

        setCurrentNotification(newMsg);
        "MSG:: ${message.notification!.body}".log();
        await _flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          notificationDetails,
          payload: message.data['body'],
        );
      }
    });
  }

  void requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (true) {
      'Permission granted: ${settings.authorizationStatus}'.log();
    }
  }
}
