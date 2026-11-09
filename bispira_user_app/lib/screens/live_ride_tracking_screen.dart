import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/neo_theme.dart';
import '../theme/map_theme.dart';

class LiveRideTrackingScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final List<LatLng> polylinePoints;
  final String serviceName;
  final String serviceEmoji;
  final int totalFare;
  final String orderId;

  const LiveRideTrackingScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.polylinePoints,
    required this.serviceName,
    required this.serviceEmoji,
    required this.totalFare,
    required this.orderId,
  });

  @override
  State<LiveRideTrackingScreen> createState() => _LiveRideTrackingScreenState();
}

class _LiveRideTrackingScreenState extends State<LiveRideTrackingScreen> with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;

  Timer? _driverMovementTimer;
  int _currentStepIndex = 0;
  late LatLng _driverCurrentPos;
  double _driverBearing = 45.0;

  String _tripStatus = 'MENJEMPUT'; // 'MENJEMPUT', 'TIBA_DI_JEMPUT', 'MENUJU_TUJUAN', 'SELESAI'
  String _statusHeading = 'Driver Menuju Titik Jemput';
  String _etaText = '2 Menit • 450m';

  // Driver Profile Data
  final String _driverName = 'Ahmad Fauzi';
  final String _driverPhone = '081234567890';
  final String _vehiclePlate = 'H 4521 SXZ';
  final String _vehicleModel = 'Honda Vario 160 (Hitam)';
  final double _driverRating = 4.95;
  final int _totalTrips = 1420;

  final List<String> _chatMessages = [
    'Halo kak, saya sudah jalan menuju titik jemput ya! 🛵',
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Initialize driver slightly offset from pickup
    _driverCurrentPos = widget.polylinePoints.isNotEmpty
        ? widget.polylinePoints.first
        : LatLng(widget.pickupLocation.latitude + 0.003, widget.pickupLocation.longitude + 0.003);

    _startDriverSimulation();
  }

  @override
  void dispose() {
    _driverMovementTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startDriverSimulation() {
    if (widget.polylinePoints.isEmpty) return;

    _driverMovementTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (!mounted) return;

      if (_currentStepIndex < widget.polylinePoints.length - 1) {
        setState(() {
          _currentStepIndex++;
          final nextPos = widget.polylinePoints[_currentStepIndex];
          _driverBearing = _calculateBearing(_driverCurrentPos, nextPos);
          _driverCurrentPos = nextPos;

          final progress = _currentStepIndex / widget.polylinePoints.length;
          if (progress < 0.3) {
            _tripStatus = 'MENJEMPUT';
            _statusHeading = 'Driver Sedang Menuju Titik Jemput';
            _etaText = '${(2 * (1.0 - progress / 0.3)).ceil()} Menit lagi';
          } else if (progress < 0.45) {
            _tripStatus = 'TIBA_DI_JEMPUT';
            _statusHeading = 'Driver Tiba di Titik Jemput! 🎉';
            _etaText = 'Silakan temui driver';
          } else if (progress < 0.95) {
            _tripStatus = 'MENUJU_TUJUAN';
            _statusHeading = 'Perjalanan Menuju Destinasi';
            _etaText = '${(12 * (1.0 - progress)).ceil()} Menit • OSRM Live';
          } else {
            _tripStatus = 'SELESAI';
            _statusHeading = 'Tiba di Tujuan! Perjalanan Selesai 👍';
            _etaText = 'Terima kasih telah menggunakan BISPIRA';
            timer.cancel();
          }
        });
      }
    });
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * math.pi / 180;
    final lon1 = start.longitude * math.pi / 180;
    final lat2 = end.latitude * math.pi / 180;
    final lon2 = end.longitude * math.pi / 180;

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final brng = math.atan2(y, x) * 180 / math.pi;
    return (brng + 360) % 360;
  }

  void _callDriver() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF00C853),
        content: Text('Menghubungkan panggilan telepon ke $_driverName ($_driverPhone)... 📞'),
      ),
    );
  }

  void _openChatModal() {
    final msgCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: Colors.black, width: 2.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: NeoColors.gold,
                      child: Text('👨‍✈️', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chat dengan $_driverName', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                          Text('$_vehicleModel • $_vehiclePlate', style: const TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _chatMessages.length,
                    itemBuilder: (_, idx) {
                      final isMe = idx > 0 && idx % 2 == 1;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isMe ? NeoColors.brand : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 1.2),
                          ),
                          child: Text(
                            _chatMessages[idx],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: msgCtrl,
                        decoration: InputDecoration(
                          hintText: 'Tulis pesan untuk driver...',
                          fillColor: NeoColors.bg,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: NeoColors.brand),
                      onPressed: () {
                        if (msgCtrl.text.trim().isNotEmpty) {
                          setState(() {
                            _chatMessages.add(msgCtrl.text.trim());
                          });
                          setModalState(() {});
                          msgCtrl.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: Stack(
        children: [
          // 1. FULLSCREEN CARTO VOYAGER MAP (GRAB / GOJEK GRADE)
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (widget.pickupLocation.latitude + widget.dropoffLocation.latitude) / 2,
                (widget.pickupLocation.longitude + widget.dropoffLocation.longitude) / 2,
              ),
              initialZoom: 14.5,
            ),
            children: [
              BispiraMapTheme.cartoVoyagerTileLayer,

              // DUAL-LAYER OSRM POLYLINES (ROAD CASING 8px + CORE 4.8px)
              PolylineLayer(
                polylines: BispiraMapTheme.buildGrabGojekPolyline(
                  points: widget.polylinePoints.isNotEmpty
                      ? widget.polylinePoints
                      : [widget.pickupLocation, widget.dropoffLocation],
                  coreColor: const Color(0xFF00C853), // Gojek neon green
                ),
              ),

              // RADAR SCANNING RING AROUND PICKUP
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: widget.pickupLocation,
                    radius: 20.0 + (_pulseController.value * 35.0),
                    color: NeoColors.brand.withValues(alpha: 0.15 * (1.0 - _pulseController.value)),
                    borderColor: NeoColors.brand.withValues(alpha: 0.5 * (1.0 - _pulseController.value)),
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),

              // MARKERS: PICKUP, DROPOFF, & MOVING DRIVER
              MarkerLayer(
                markers: [
                  // Pickup Marker
                  Marker(
                    point: widget.pickupLocation,
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 28),
                  ),

                  // Dropoff Marker
                  Marker(
                    point: widget.dropoffLocation,
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 32),
                  ),

                  // LIVE MOVING DRIVER WITH HEADING ROTATION
                  Marker(
                    point: _driverCurrentPos,
                    width: 56,
                    height: 56,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _vehiclePlate,
                            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Transform.rotate(
                          angle: _driverBearing * math.pi / 180,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00C853),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, offset: Offset(2, 2), blurRadius: 2),
                              ],
                            ),
                            child: const Center(
                              child: Text('🛵', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. TOP FLOATING HUD STATUS CARD (GRAB / GOJEK STYLE)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _tripStatus == 'TIBA_DI_JEMPUT' ? NeoColors.gold : const Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Text(_tripStatus == 'TIBA_DI_JEMPUT' ? '📍' : '🛵', style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _statusHeading,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _etaText,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF00C853)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. BOTTOM FLOATING DRIVER & ORDER SHEET
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DRIVER PROFILE ROW
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: NeoColors.gold,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Center(child: Text('👨‍✈️', style: TextStyle(fontSize: 28))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(_driverName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, color: NeoColors.brand, size: 16),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('$_vehicleModel • $_vehiclePlate', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.textMuted)),
                            const SizedBox(height: 2),
                            Text('★ $_driverRating ($_totalTrips trip selesai)', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Color(0xFFD97706))),
                          ],
                        ),
                      ),
                      // CALL BUTTON
                      GestureDetector(
                        onTap: _callDriver,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C853),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.8),
                          ),
                          child: const Icon(Icons.call_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // CHAT BUTTON
                      GestureDetector(
                        onTap: _openChatModal,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: NeoColors.brand,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.8),
                          ),
                          child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // TRIP SUMMARY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Pembayaran', style: TextStyle(fontSize: 10, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                          Text('Rp ${widget.totalFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoColors.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1.2),
                        ),
                        child: Text(
                          widget.orderId,
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

