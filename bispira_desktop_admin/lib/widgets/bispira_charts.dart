import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neo_brutal_theme.dart';

/// Adaptive Clean Bar Chart Widget (Peak Activity / Hourly Volume)
class BispiraBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final bool isDark;

  const BispiraBarChart({
    Key? key,
    this.values = const [35, 65, 85, 120, 95, 110, 75, 45],
    this.labels = const ['06:00', '08:00', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00'],
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textPrimary = NeoBrutalTheme.getTextPrimary(isDark);
    final textSecondary = NeoBrutalTheme.getTextSecondary(isDark);
    final textMuted = NeoBrutalTheme.getTextMuted(isDark);

    final maxValue = values.reduce(max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart_rounded, color: NeoBrutalTheme.bispiraBlue, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Peak Activity Transaksi (Hari Ini)',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary),
                ),
              ],
            ),
            const NeoBrutalBadge(text: 'Peak: 12:00 WIB', bgColor: NeoBrutalTheme.bispiraBlue),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(values.length, (index) {
              final val = values[index];
              final pct = val / maxValue;
              final isHighest = val == maxValue;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${val.toInt()}',
                    style: TextStyle(
                      fontSize: 12, // Larger font
                      fontWeight: isHighest ? FontWeight.bold : FontWeight.w600,
                      color: isHighest ? NeoBrutalTheme.bispiraBlue : textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 26,
                    height: 115 * pct,
                    decoration: BoxDecoration(
                      color: isHighest ? NeoBrutalTheme.bispiraBlue : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(6),
                      gradient: isHighest
                          ? const LinearGradient(
                              colors: [Color(0xFF0066FF), Color(0xFF3385FF)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index],
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textMuted),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// Adaptive Clean Donut Chart Widget (Kategori Share Layanan)
class BispiraDonutChart extends StatelessWidget {
  final bool isDark;

  const BispiraDonutChart({Key? key, this.isDark = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textPrimary = NeoBrutalTheme.getTextPrimary(isDark);
    final textSecondary = NeoBrutalTheme.getTextSecondary(isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.pie_chart_rounded, color: NeoBrutalTheme.bispiraBlue, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Distribusi Revenue Layanan',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary),
                ),
              ],
            ),
            const NeoBrutalBadge(text: '85% Targets', bgColor: NeoBrutalTheme.neoGreen),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            SizedBox(
              width: 135,
              height: 135,
              child: CustomPaint(
                painter: _DonutChartPainter(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '85%',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textPrimary),
                      ),
                      Text(
                        'Capaian',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(color: NeoBrutalTheme.bispiraBlue, label: 'Ride-Hailing (Motor/Mobil)', value: '45%', textPrimary: textPrimary, textSecondary: textSecondary),
                  const SizedBox(height: 10),
                  _LegendItem(color: NeoBrutalTheme.neoGreen, label: 'Merchant Food & Sembako', value: '30%', textPrimary: textPrimary, textSecondary: textSecondary),
                  const SizedBox(height: 10),
                  _LegendItem(color: NeoBrutalTheme.neoCyan, label: 'BISPIRA Health & Ambulance', value: '15%', textPrimary: textPrimary, textSecondary: textSecondary),
                  const SizedBox(height: 10),
                  _LegendItem(color: NeoBrutalTheme.neoPurple, label: 'Komisi Platform & Ads', value: '10%', textPrimary: textPrimary, textSecondary: textSecondary),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final Color textPrimary;
  final Color textSecondary;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: textSecondary), // Larger legend text
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textPrimary),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;
    const strokeWidth = 15.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Segments: 45%, 30%, 15%, 10%
    const totalSweep = 2 * pi;
    double startAngle = -pi / 2;

    final segments = [
      {'pct': 0.45, 'color': const Color(0xFF0066FF)},
      {'pct': 0.30, 'color': const Color(0xFF10B981)},
      {'pct': 0.15, 'color': const Color(0xFF0284C7)},
      {'pct': 0.10, 'color': const Color(0xFF7C3AED)},
    ];

    for (var seg in segments) {
      final sweep = (seg['pct'] as double) * totalSweep - 0.08;
      paint.color = seg['color'] as Color;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + 0.08;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Adaptive Smooth Line Curve Chart Widget (Tren Pemasukan Monthly)
class BispiraLineChart extends StatelessWidget {
  final bool isDark;

  const BispiraLineChart({Key? key, this.isDark = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textPrimary = NeoBrutalTheme.getTextPrimary(isDark);
    final textMuted = NeoBrutalTheme.getTextMuted(isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart_rounded, color: NeoBrutalTheme.neoGreen, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Grafik Tren Pemasukan Bulanan (2026)',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary),
                ),
              ],
            ),
            const NeoBrutalBadge(text: '+15.8% Growth', bgColor: NeoBrutalTheme.neoGreen),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 130,
          width: double.infinity,
          child: CustomPaint(
            painter: _LineChartPainter(isDark: isDark),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jan', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textMuted)),
            Text('Feb', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textMuted)),
            Text('Mar', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textMuted)),
            Text('Apr', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textMuted)),
            Text('Mei', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textMuted)),
            Text('Jun', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textMuted)),
          ],
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final bool isDark;
  _LineChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.60),
      Offset(size.width * 0.4, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width, size.height * 0.10),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    // Fill Gradient
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.25),
          const Color(0xFF10B981).withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Stroke Paint
    final strokePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Dots
    final dotPaint = Paint()..color = isDark ? const Color(0xFF0F172A) : Colors.white;
    final dotOuterPaint = Paint()..color = const Color(0xFF10B981);

    for (var pt in points) {
      canvas.drawCircle(pt, 5.5, dotOuterPaint);
      canvas.drawCircle(pt, 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
