import 'package:flutter/material.dart';

const kBackgroud = Color(0xFF0B0F1A);
const kSurface = Color(0xFF111827);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5A36),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: kBackgroud,
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: kSurface,
      elevation: 0,
    ),
  );
}
