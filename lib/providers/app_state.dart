import 'package:data_messaging/models/notification_model.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  NotificationModel? _notification;
  NotificationModel? get notification => _notification;

  void setMessage(NotificationModel? newMessage) {
    _notification = newMessage;
    notifyListeners();
  }
}
