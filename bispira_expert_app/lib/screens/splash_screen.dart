import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExpertLoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: NeoColors.expert,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: NeoColors.black, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(4, 4), blurRadius: 0),
                ],
              ),
              child: const Center(
                child: Text('🎓', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'BISPIRA EXPERT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: NeoColors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Aplikasi Mitra Ahli, Edukasi & Entertainment',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: NeoColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

