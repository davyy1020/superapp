import 'package:flutter/material.dart';

class NeoColors {
  static const Color brand = Color(0xFF0066FF);
  static const Color brandDark = Color(0xFF0044CC);
  static const Color brandSoft = Color(0xFFE6F0FF);
  
  static const Color green = Color(0xFF10B981);
  static const Color greenDark = Color(0xFF047857);
  static const Color greenSoft = Color(0xFFD1FAE5);

  static const Color gold = Color(0xFFFFB800);
  static const Color goldSoft = Color(0xFFFFF7D6);
  static const Color orange = Color(0xFFFF6B00);
  static const Color red = Color(0xFFEF4444);

  static const Color bg = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color white = Colors.white;
  static const Color cardDark = Color(0xFF0F172A);
  
  static const Color black = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderSubtle = Color(0xFFE2E8F0);
}

class NeoTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: NeoColors.bg,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: NeoColors.brand,
        primary: NeoColors.brand,
        secondary: NeoColors.green,
        surface: NeoColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: NeoColors.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: NeoColors.black),
        titleTextStyle: TextStyle(
          color: NeoColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
