import 'package:flutter/material.dart';
import 'theme/neo_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BispiraUserApp());
}

class BispiraUserApp extends StatelessWidget {
  const BispiraUserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BISPIRA User App',
      debugShowCheckedModeBanner: false,
      theme: NeoTheme.theme,
      home: const SplashScreen(),
    );
  }
}
