import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xFF0F3B2E),
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF0F3B2E),
        useMaterial3: true,
      );
}