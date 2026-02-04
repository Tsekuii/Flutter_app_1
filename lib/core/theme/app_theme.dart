import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF6B4EFF);
  static const Color lightPurple = Color(0xFFE8E3FF);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color blueInfo = Color(0xFF3B82F6);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    colorScheme: const ColorScheme.light(
      primary: primaryPurple,
      secondary: lightPurple,
      error: errorRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
