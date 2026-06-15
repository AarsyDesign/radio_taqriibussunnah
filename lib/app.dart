import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'core/app_config.dart';
import 'features/home/main_shell.dart';
import 'theme_controller.dart';

class RadioTaqriibussunnahApp extends StatefulWidget {
  const RadioTaqriibussunnahApp({super.key});

  @override
  State<RadioTaqriibussunnahApp> createState() =>
      _RadioTaqriibussunnahAppState();
}

class _RadioTaqriibussunnahAppState extends State<RadioTaqriibussunnahApp> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          themeMode: _themeController.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: MainShell(themeController: _themeController),
        );
      },
    );
  }
}
