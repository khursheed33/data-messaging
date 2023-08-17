import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    requestPermission();
    initInfo();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification tapped while app is in foreground:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("RESUME");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Showing on resume"),
          ),
        );
        break;
      case AppLifecycleState.inactive:
        print("INACTIVE");
        break;
      case AppLifecycleState.paused:
        print("PAUSED");
        break;
      case AppLifecycleState.detached:
        print("DETACHED");
        break;
    }
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (val) {
      print("OnDidRec::$val");
    }, onDidReceiveBackgroundNotificationResponse: (val) {
      print("OnDidRecBack::$val");
    });

    FirebaseMessaging.instance.subscribeToTopic("all_devices");

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        if (message.notification != null &&
            message.notification!.title != null &&
            message.notification!.body != null &&
            message.notification!.title!.isNotEmpty &&
            message.notification!.body!.isNotEmpty &&
            WidgetsBinding.instance.lifecycleState ==
                AppLifecycleState.resumed) {
          BigTextStyleInformation bigTextStyleInformation =
              BigTextStyleInformation(message.notification!.body.toString(),
                  htmlFormatBigText: true,
                  contentTitle: message.notification!.title.toString(),
                  htmlFormatContent: true);

          AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'default',
            'default',
            importance: Importance.high,
            styleInformation: bigTextStyleInformation,
            priority: Priority.high,
          );

          NotificationDetails notificationDetails = NotificationDetails(
            android: androidNotificationDetails,
            iOS: const DarwinNotificationDetails(),
          );

          await flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title,
            message.notification?.body,
            notificationDetails,
            payload: message.data['body'],
          );
        }
      },
    );
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

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: username,
            ),
            TextFormField(
              controller: title,
            ),
            TextFormField(
              controller: body,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
