import 'package:flutter/material.dart';

// ============================================================
// BISPIRA SUPERAPP — OFFICIAL LOGO PALETTE v9.0
// Brand Color: Electric Cerulean Blue (#0066FF) - Matching assets/logo.png
// Concept: Modern Minimalist + Soft Neo-Brutalism
// Background : #F4F8FC (Crisp Minimal Off-White Canvas)
// Primary    : #0066FF (Official BISPIRA Electric Blue)
// Accent     : #FFB800 (Solar Gold Accent)
// Stroke     : #0F172A (Midnight Slate Black)
// ============================================================

class NeoColors {
  // Crisp Minimal Off-White Canvas
  static const Color bg           = Color(0xFFF4F8FC);
  static const Color bgLight      = Color(0xFFF4F8FC);
  static const Color surface      = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color darkSurface  = Color(0xFFFFFFFF);
  static const Color cardBg       = Color(0xFFFFFFFF);

  // BISPIRA Official Logo Signature Palette
  static const Color brand        = Color(0xFF0066FF); // 💙 Official BISPIRA Electric Cerulean Blue
  static const Color brandSoft    = Color(0xFFE6F0FF); // Soft Sky Blue Tint
  static const Color gold         = Color(0xFFFFB800); // ☀️ Solar Gold Accent
  static const Color goldSoft     = Color(0xFFFFF7E6); // Soft Gold Tint
  static const Color mint         = Color(0xFF00C853);
  static const Color lime         = Color(0xFFFFB800); // Solar Gold alias
  static const Color limeSoft     = Color(0xFFFFF7E6);

  // Strokes & Typography
  static const Color black        = Color(0xFF0F172A); // Midnight Slate Black
  static const Color border       = Color(0xFF0F172A);
  static const Color textMuted    = Color(0xFF64748B);
  static const Color textLight    = Color(0xFF94A3B8);
  static const Color divider     = Color(0xFFE2E8F0);
  static const Color white        = Color(0xFFFFFFFF);

  // Compatibility aliases
  static const Color primary      = Color(0xFF0066FF);
  static const Color primarySoft  = Color(0xFFE6F0FF);
  static const Color brandLight   = Color(0xFFE6F0FF);
  static const Color green        = Color(0xFF00C853);
  static const Color greenSoft    = Color(0xFFE6F9ED);
  static const Color sky          = Color(0xFF0066FF);
  static const Color skySoft      = Color(0xFFE6F0FF);
  static const Color lavender     = Color(0xFFE6F0FF);
  static const Color peach        = Color(0xFFFFF7E6);
  static const Color orange       = Color(0xFFFFB800);
  static const Color blue         = Color(0xFF0066FF);
  static const Color yellow       = Color(0xFFFFB800);
  static const Color pink         = Color(0xFF0066FF);
  static const Color electricYellow = Color(0xFFFFB800);
  static const Color hotPink        = Color(0xFF0066FF);
  static const Color neonGreen      = Color(0xFF00C853);
  static const Color neonOrange     = Color(0xFFFFB800);
  static const Color electricBlue   = Color(0xFF0066FF);
  static const Color cyan           = Color(0xFF0066FF);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: NeoColors.bg,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: NeoColors.brand,
        secondary: NeoColors.gold,
        surface: NeoColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: NeoColors.bg,
        foregroundColor: NeoColors.black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: NeoColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

class NeoTheme {
  static ThemeData get theme => AppTheme.theme;
}
