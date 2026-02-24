import 'package:corina_brain_research_digital_application/app/config/router/router.dart';
import 'package:corina_brain_research_digital_application/app/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with RouterMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Corina Brain Research Digital Application',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme(isDarkmode: false).getTheme(),
    );
  }
}
