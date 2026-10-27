import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _badgeScale;
  late Animation<double> _pulseRadius;

  @override
  void initState() {
    super.initState();

    // 1. Main entrance staggered animations
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Cubic(0.175, 0.885, 0.32, 1.25)),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    // 2. Continuous rotating tech ring animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // 3. Continuous background pulsing glow animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseRadius = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _mainController.forward();

    // Auto navigate to LoginScreen after 3.0 seconds
    Timer(const Duration(milliseconds: 3000), () => _navigateToLogin());
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: GestureDetector(
        onTap: _navigateToLogin,
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _rotationController, _pulseController]),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // 1. EXPANDING PULSE GLOW RINGS (BACKGROUND)
                Transform.scale(
                  scale: _pulseRadius.value,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          NeoColors.brand.withOpacity(0.18),
                          NeoColors.gold.withOpacity(0.08),
                          Colors.transparent,
                        ],
                        stops: const [0.2, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                // 2. ROTATING DASHED TECH ORBIT RING
                Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(180, 180),
                    painter: _TechOrbitPainter(color: NeoColors.brand.withOpacity(0.5)),
                  ),
                ),

                // 3. MAIN CENTER CONTENT
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // LOGO WITH ELASTIC SCALE & 3D HARD SHADOW
                      Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: NeoColors.black, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: NeoColors.brand.withOpacity(0.45),
                                  blurRadius: 35,
                                  spreadRadius: 6,
                                ),
                                const BoxShadow(
                                  color: NeoColors.black,
                                  offset: Offset(5, 5),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: NeoColors.brand,
                                  child: const Center(
                                    child: Text('B', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 48)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // STAGGERED SLIDE TITLE "B I S P I R A"
                      Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: Opacity(
                          opacity: _mainController.value > 0.4 ? 1.0 : 0.0,
                          child: Column(
                            children: [
                              const Text(
                                'B I S P I R A',
                                style: TextStyle(
                                  color: NeoColors.brand,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 6.0,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // BADGE "SUPERAPP 2026" WITH ELASTIC SCALE
                              Transform.scale(
                                scale: _badgeScale.value,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: NeoColors.gold,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: NeoColors.black, width: 2),
                                    boxShadow: const [
                                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                                    ],
                                  ),
                                  child: const Text(
                                    '⭐ SUPERAPP 2026 🚀',
                                    style: TextStyle(
                                      color: NeoColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              const Text(
                                'Ekosistem Digital Terpadu & Masa Depan Indonesia',
                                style: TextStyle(
                                  color: NeoColors.textMuted,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 52),

                      // SLEEK ANIMATED PROGRESS LOADING CAPSULE
                      Opacity(
                        opacity: _mainController.value > 0.6 ? 1.0 : 0.0,
                        child: Container(
                          width: 160,
                          height: 6,
                          decoration: BoxDecoration(
                            color: NeoColors.brandSoft,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: (_mainController.value * 1.1).clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [NeoColors.brand, NeoColors.gold],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // BOTTOM FOOTER
                Positioned(
                  bottom: 24,
                  child: Opacity(
                    opacity: _mainController.value > 0.7 ? 1.0 : 0.0,
                    child: Text(
                      'v1.0.0 • Powered by BISPIRA Ecosystem',
                      style: TextStyle(
                        color: NeoColors.black.withOpacity(0.55),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Custom Painter for Dashed Rotating Tech Orbit Ring
class _TechOrbitPainter extends CustomPainter {
  final Color color;

  _TechOrbitPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double radius = size.width / 2;
    const int dashCount = 16;
    const double dashAngle = (2 * math.pi) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        final double startAngle = i * dashAngle;
        canvas.drawArc(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius),
          startAngle,
          dashAngle * 0.7,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TechOrbitPainter oldDelegate) => oldDelegate.color != color;
}
