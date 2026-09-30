import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFFAF8F5),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF252525),
      brightness: Brightness.light,
    ),
  );
}
