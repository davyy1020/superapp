import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

// ─────────────────────────────────────────────────────────
// CUSTOM VECTOR BELL (NOTIFICATION ICON)
// Native CustomPaint - Never fails, zero font dependency
// ─────────────────────────────────────────────────────────
class VectorNotificationBell extends StatelessWidget {
  final double size;
  final Color color;

  const VectorNotificationBell({
    Key? key,
    this.size = 20,
    this.color = NeoColors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BellPainter(color: color),
    );
  }
}

class _BellPainter extends CustomPainter {
  final Color color;

  _BellPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;

    final path = Path();
    // Bell Dome & Flare
    path.moveTo(w * 0.5, h * 0.15);
    path.cubicTo(w * 0.25, h * 0.15, w * 0.2, h * 0.5, w * 0.15, h * 0.7);
    path.lineTo(w * 0.85, h * 0.7);
    path.cubicTo(w * 0.8, h * 0.5, w * 0.75, h * 0.15, w * 0.5, h * 0.15);

    canvas.drawPath(path, strokePaint);

    // Bell Clapper at bottom
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.5, h * 0.7), radius: w * 0.14),
      0,
      3.14159,
      false,
      strokePaint,
    );

    // Top loop
    canvas.drawCircle(Offset(w * 0.5, h * 0.12), w * 0.06, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────
// CUSTOM VECTOR LOGOUT ICON
// Native CustomPaint - Door Bracket + Right Arrow
// ─────────────────────────────────────────────────────────
class VectorLogoutIcon extends StatelessWidget {
  final double size;
  final Color color;

  const VectorLogoutIcon({
    Key? key,
    this.size = 20,
    this.color = const Color(0xFFD32F2F),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LogoutPainter(color: color),
    );
  }
}

class _LogoutPainter extends CustomPainter {
  final Color color;

  _LogoutPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double w = size.width;
    final double h = size.height;

    // 1. Door Bracket (Left frame)
    final doorPath = Path()
      ..moveTo(w * 0.55, h * 0.15)
      ..lineTo(w * 0.2, h * 0.15)
      ..lineTo(w * 0.2, h * 0.85)
      ..lineTo(w * 0.55, h * 0.85);
    canvas.drawPath(doorPath, paint);

    // 2. Exit Arrow pointing right
    final arrowPath = Path()
      ..moveTo(w * 0.4, h * 0.5)
      ..lineTo(w * 0.88, h * 0.5)
      ..moveTo(w * 0.7, h * 0.3)
      ..lineTo(w * 0.88, h * 0.5)
      ..lineTo(w * 0.7, h * 0.7);
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────
// CUSTOM VECTOR SEARCH ICON (MAGNIFYING GLASS)
// ─────────────────────────────────────────────────────────
class VectorSearchIcon extends StatelessWidget {
  final double size;
  final Color color;

  const VectorSearchIcon({
    Key? key,
    this.size = 20,
    this.color = NeoColors.brand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SearchPainter(color: color),
    );
  }
}

class _SearchPainter extends CustomPainter {
  final Color color;

  _SearchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final double w = size.width;
    final double h = size.height;

    // Lens Circle
    canvas.drawCircle(Offset(w * 0.42, h * 0.42), w * 0.28, paint);

    // Handle
    canvas.drawLine(
      Offset(w * 0.62, h * 0.62),
      Offset(w * 0.88, h * 0.88),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
