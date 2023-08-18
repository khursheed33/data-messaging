import 'package:data_messaging/constants/app_text.dart';
import 'package:data_messaging/viewmodels/notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NotificationViewModel>(context);
    model.initialize();
    model.requestPermission();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.appName),
      ),
      backgroundColor: Colors.blue[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Your Notifications will be shown here."),
          const SizedBox(height: 20),
          ListTile(
            tileColor: Colors.white,
            leading: const CircleAvatar(
              child: Icon(
                Icons.notifications_active_outlined,
                color: Colors.yellow,
              ),
            ),
            title: Text(model.currentNotification.title),
            subtitle: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Text(" ${model.currentNotification.body}"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
