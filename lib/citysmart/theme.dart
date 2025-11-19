import 'package:flutter/material.dart';

class CSTheme {
  static const primary = Color(0xFF7CA726);
  static const secondary = Color(0xFF5E8A45);
  static const accent = Color(0xFFE0B000);
  static ThemeData theme() => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
    ),
    fontFamily: 'Inter',
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white54),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primary)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: accent, width: 2)),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: accent,
      selectionColor: accent,
    ),
  );
}
