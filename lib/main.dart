import 'package:data_messaging/app_foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase Core initialization
  await Firebase.initializeApp();
  // To Get Initial Messages
  await FirebaseMessaging.instance.getInitialMessage();
  // // Initialize Backgroun notifications
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const AppFoundation());
}
