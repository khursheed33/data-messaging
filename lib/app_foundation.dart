import 'package:data_messaging/app_providers.dart';
import 'package:data_messaging/app_theme.dart';
import 'package:data_messaging/constants/app_text.dart';
import 'package:data_messaging/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppFoundation extends StatelessWidget {
  const AppFoundation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppText.appName,
        theme: appTheme,
        home: const HomePage(),
      ),
    );
  }
}
