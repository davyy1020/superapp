import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class GisTrackingTab extends StatefulWidget {
  const GisTrackingTab({Key? key}) : super(key: key);

  @override
  State<GisTrackingTab> createState() => _GisTrackingTabState();
}

class _GisTrackingTabState extends State<GisTrackingTab> {
  bool _isSimulating = true;
  int _activeDriverIdx = 0;
  Timer? _simTimer;
  double _progress = 0.25;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_isSimulating && mounted) {
        setState(() {
          _progress += 0.05;
          if (_progress > 0.95) _progress = 0.05;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final mapCanvasBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

    final drivers = provider.drivers;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peta Live Tracking Driver & GIS OSRM Engine',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monitoring posisi realtime armada driver, rute perutean OSRM, dan deteksi kecurangan lokasi (Fake GPS).',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  NeoBrutalBadge(
                    text: _isSimulating ? '● SIMULASI MOVE LIVE' : '⏸ SIMULASI PAUSED',
                    bgColor: _isSimulating ? NeoBrutalTheme.neoGreen : NeoBrutalTheme.neoOrange,
                  ),
                  const SizedBox(width: 8),
                  NeoBrutalBadge(text: 'OSRM 5.27.0 active', bgColor: NeoBrutalTheme.bispiraBlue),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stat Cards
          Row(
              children: [
                Expanded(
                  child: _buildStatMiniCard('Armada Monitored', '${drivers.length} Unit', Icons.directions_bike_rounded, NeoBrutalTheme.bispiraBlue, cardBg, textPrimary, textSecondary, borderSubtle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatMiniCard('OSRM Routing Latency', '14 ms (Fast)', Icons.speed_rounded, NeoBrutalTheme.neoGreen, cardBg, textPrimary, textSecondary, borderSubtle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatMiniCard('Status Geo-fence', '4 Wilayah Aktif', Icons.map_rounded, NeoBrutalTheme.neoYellow, cardBg, textPrimary, textSecondary, borderSubtle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatMiniCard('Fake GPS Fraud Detection', 'Sistem Protektif', Icons.security_rounded, NeoBrutalTheme.neoRed, cardBg, textPrimary, textSecondary, borderSubtle),
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Main Map View & Telemetry Panel
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map Visualizer Canvas
                Expanded(
                  flex: 3,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Top Action Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_searching_rounded, size: 18, color: NeoBrutalTheme.bispiraBlue),
                                const SizedBox(width: 8),
                                Text('Simulasi Perutean OSRM: Jakarta Selatan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textPrimary)),
                              ],
                            ),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isSimulating ? NeoBrutalTheme.neoOrange : NeoBrutalTheme.neoGreen,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  icon: Icon(_isSimulating ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 16),
                                  label: Text(_isSimulating ? 'Pause Telemetri' : 'Jalankan Telemetri', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  onPressed: () {
                                    setState(() {
                                      _isSimulating = !_isSimulating;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: NeoBrutalTheme.neoRed,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.warning_amber_rounded, size: 16),
                                  label: const Text('Simulasi Fake GPS Fraud', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  onPressed: () {
                                    final drvId = drivers[_activeDriverIdx % drivers.length].driverId;
                                    provider.triggerFakeGPSAlert(drvId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('⚠️ Alert Fake GPS disimulasikan untuk Driver #$drvId! Log keamanan ditambahkan.'),
                                        backgroundColor: NeoBrutalTheme.neoRed,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Interactive Map Container
                        Container(
                          height: 380,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: mapCanvasBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderSubtle, width: 1.0),
                          ),
                          child: Stack(
                            children: [
                              // Simulated OSRM Route Line & Pins
                              CustomPaint(
                                size: Size.infinite,
                                painter: _OsrmRoutePainter(progress: _progress, isDark: isDark),
                              ),

                              // Floating Info Badge Top Left
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: borderSubtle),
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('📍 Sudirman Center ➡️ Monas Park', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                                      const SizedBox(height: 4),
                                      Text('OSRM Distance: 8.2 KM | Est. Time: 14.5 Mnt', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: NeoBrutalTheme.bispiraBlue)),
                                      Text('Interpolasi Posisi: (${(-6.2088 + _progress * 0.05).toStringAsFixed(4)}, ${(106.8456 + _progress * 0.04).toStringAsFixed(4)})', style: TextStyle(fontSize: 10, color: textSecondary)),
                                    ],
                                  ),
                                ),
                              ),

                              // Active Selected Driver Badge Top Right
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: borderSubtle),
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '🛵 Driver Terpilih: ${drivers.isNotEmpty ? drivers[_activeDriverIdx % drivers.length].name : 'N/A'}',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Plat: ${drivers.isNotEmpty ? drivers[_activeDriverIdx % drivers.length].plateNumber : 'N/A'}',
                                        style: const TextStyle(fontWeight: FontWeight.w700, color: NeoBrutalTheme.bispiraBlue, fontSize: 11),
                                      ),
                                      const SizedBox(height: 2),
                                      Text('Baterai: 88% • GPS Precision: High (±2m)', style: TextStyle(fontSize: 10, color: textSecondary)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Right Driver Telemetry List
                Expanded(
                  flex: 1,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people_alt_rounded, size: 18, color: NeoBrutalTheme.bispiraBlue),
                            const SizedBox(width: 8),
                            Text('Driver Aktif Online (${drivers.length})', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: drivers.length,
                          itemBuilder: (context, idx) {
                            final d = drivers[idx];
                            final isSelected = idx == (_activeDriverIdx % drivers.length);
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _activeDriverIdx = idx;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected ? NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isSelected ? NeoBrutalTheme.bispiraBlue : borderSubtle),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isSelected ? NeoBrutalTheme.bispiraBlue : borderSubtle,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.sports_motorsports_rounded,
                                        size: 18,
                                        color: isSelected ? Colors.white : NeoBrutalTheme.neoGreen,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(d.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                                          Text('${d.vehicleType} • ${d.plateNumber}', style: TextStyle(fontSize: 11, color: textSecondary)),
                                        ],
                                      ),
                                    ),
                                    if (isSelected) const Icon(Icons.my_location_rounded, color: NeoBrutalTheme.bispiraBlue, size: 18),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Visual Charts Section
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(20),
                    child: BispiraBarChart(isDark: isDark),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(20),
                    child: BispiraDonutChart(isDark: isDark),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Live Event Log Table
          NeoBrutalCard(
              bgColor: cardBg,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('System Log Telemetri & Evensi GIS (OSRM Router)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textPrimary)),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        color: textSecondary,
                        tooltip: 'Refresh Log',
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.auditLogs.take(5).map((log) {
                        Color txtColor = Colors.greenAccent;
                        if (log['type'] == 'warning') txtColor = Colors.orangeAccent;
                        if (log['type'] == 'info') txtColor = Colors.lightBlueAccent;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            '[${log['time']}] ${log['text']}',
                            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: txtColor),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatMiniCard(String title, String val, IconData icon, Color color, Color bg, Color txtP, Color txtS, Color border) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: txtS)),
                const SizedBox(height: 2),
                Text(val, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: txtP)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Map Route Polyline & Animated Driver Pin
class _OsrmRoutePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _OsrmRoutePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final startPoint = Offset(size.width * 0.15, size.height * 0.75);
    final controlPoint1 = Offset(size.width * 0.4, size.height * 0.2);
    final controlPoint2 = Offset(size.width * 0.65, size.height * 0.85);
    final endPoint = Offset(size.width * 0.85, size.height * 0.25);

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, endPoint.dx, endPoint.dy);

    // Draw background OSRM route path line
    final routePaint = Paint()
      ..color = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, routePaint);

    // Draw start marker (Sudirman)
    final startPaint = Paint()..color = const Color(0xFF10B981);
    canvas.drawCircle(startPoint, 10, startPaint);
    canvas.drawCircle(startPoint, 5, Paint()..color = Colors.white);

    // Draw end marker (Monas)
    final endPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(endPoint, 10, endPaint);
    canvas.drawCircle(endPoint, 5, Paint()..color = Colors.white);

    // Calculate current position along bezier path for driver pin
    final p0 = startPoint;
    final p1 = controlPoint1;
    final p2 = controlPoint2;
    final p3 = endPoint;

    final t = progress;
    final u = 1 - t;
    final tt = t * t;
    final uu = u * u;
    final uuu = uu * u;
    final ttt = tt * t;

    final currentX = uuu * p0.dx + 3 * uu * t * p1.dx + 3 * u * tt * p2.dx + ttt * p3.dx;
    final currentY = uuu * p0.dy + 3 * uu * t * p1.dy + 3 * u * tt * p2.dy + ttt * p3.dy;
    final driverPos = Offset(currentX, currentY);

    // Pulse ring around driver
    canvas.drawCircle(
      driverPos,
      18,
      Paint()
        ..color = const Color(0xFF0284C7).withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    // Driver pin circle
    canvas.drawCircle(driverPos, 10, Paint()..color = const Color(0xFF0284C7));
    canvas.drawCircle(driverPos, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _OsrmRoutePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
