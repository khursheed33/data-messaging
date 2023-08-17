import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> sendNotification(String message) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Authorization":
            "key=AAAATwF_P14:APA91bG7OK1hzR8DGlAHsMW8591L_wfhLgNmnIzMkIxU2N7LynxNN2PCIOQkUdrjw2cY-YTzmULr-JNOcpwevR2osXbCUD506vXCzRq88Bqo0qUnu71gFfNELvOXw7RQ_7tVkOe9zGxV"
      },
      body: jsonEncode(<String, dynamic>{
        'message': message,
      }),
    );
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      throw Exception('Failed to send notification');
    }
  }
}
