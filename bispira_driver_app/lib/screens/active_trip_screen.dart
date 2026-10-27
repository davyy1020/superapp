import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/driver_provider.dart';
import '../theme/neo_theme.dart';
import '../utils/maps_launcher.dart';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({Key? key}) : super(key: key);

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  final MapController _mapController = MapController();
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final driver = Provider.of<DriverProvider>(context);
    final order = driver.activeOrder;

    if (order == null) {
      return Scaffold(
        backgroundColor: NeoColors.bg,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('✅', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text('Tidak ada orderan aktif.', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Dashboard'),
              ),
            ],
          ),
        ),
      );
    }

    final LatLng pickupLatLng = LatLng(order.pickupLat, order.pickupLng);
    final LatLng dropoffLatLng = LatLng(order.dropoffLat, order.dropoffLng);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: Text(order.serviceName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: NeoColors.gold,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: NeoColors.black, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_rounded, color: NeoColors.black, size: 16),
                const SizedBox(width: 4),
                Text(
                  order.customerName.split(' ').first,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: NeoColors.black),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // LIVE MAP VIEW WITH ROUTE LINE
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (order.pickupLat + order.dropoffLat) / 2,
                (order.pickupLng + order.dropoffLng) / 2,
              ),
              initialZoom: 13.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.bispira.driverapp',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [pickupLatLng, dropoffLatLng],
                    strokeWidth: 4.5,
                    color: NeoColors.brand,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pickupLatLng,
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 30),
                  ),
                  Marker(
                    point: dropoffLatLng,
                    width: 36,
                    height: 36,
                    child: const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 32),
                  ),
                ],
              ),
            ],
          ),

          // FLOATING GOOGLE MAPS NAVIGATION BUTTON
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                final isPickup = order.status == 'accepted';
                final targetLat = isPickup ? order.pickupLat : order.dropoffLat;
                final targetLng = isPickup ? order.pickupLng : order.dropoffLng;
                final targetAddress = isPickup ? order.pickupAddress : order.dropoffAddress;
                MapsLauncherHelper.openDirections(
                  lat: targetLat,
                  lng: targetLng,
                  destinationLabel: targetAddress,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: NeoColors.brand,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.navigation_rounded, color: NeoColors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      order.status == 'accepted' ? 'Rute Jemput di Maps 🧭' : 'Rute Antar di Maps 🧭',
                      style: const TextStyle(
                        color: NeoColors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // BOTTOM SHEET WITH PROCESS STEPS
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: NeoColors.black, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, blurRadius: 15, offset: Offset(0, -4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STATUS STEP BADGE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusStepPill(
                        stepName: order.status == 'accepted'
                            ? '1. Menuju Penjemputan'
                            : order.status == 'at_pickup'
                                ? '2. Sampai / Ambil Barang'
                                : '3. Mengantar ke Tujuan',
                      ),
                      Text(
                        currencyFmt.format(order.netDriverEarning),
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: NeoColors.greenDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // CUSTOMER & ITEM DETAIL CARD
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NeoColors.bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.black, width: 1.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_rounded, color: NeoColors.brand, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              order.customerName,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                            ),
                            const Spacer(),
                            Text(
                              order.customerPhone,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
                            ),
                          ],
                        ),
                        if (order.itemsDescription.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          const Divider(color: NeoColors.black, height: 1, thickness: 1),
                          const SizedBox(height: 6),
                          Text(
                            'Catatan / Menu: ${order.itemsDescription}',
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: NeoColors.black),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // PICKUP & DROPOFF ADDRESSES
                  Row(
                    children: [
                      const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.pickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: NeoColors.black),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => MapsLauncherHelper.openDirections(
                          lat: order.pickupLat,
                          lng: order.pickupLng,
                          destinationLabel: order.pickupAddress,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: NeoColors.brandSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: const Text('Maps 🗺️', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: NeoColors.black)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.dropoffAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: NeoColors.black),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => MapsLauncherHelper.openDirections(
                          lat: order.dropoffLat,
                          lng: order.dropoffLng,
                          destinationLabel: order.dropoffAddress,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: const Text('Maps 🗺️', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: NeoColors.black)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ACTION BUTTON BASED ON STEP
                  _buildActionButton(context, driver, order),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStepPill({required String stepName}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: NeoColors.gold,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoColors.black, width: 1.5),
      ),
      child: Text(
        stepName,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, DriverProvider driver, DriverOrder order) {
    if (order.status == 'accepted') {
      return GestureDetector(
        onTap: () {
          driver.updateOrderStatus('at_pickup');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: NeoColors.brand,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: NeoColors.black, width: 2),
            boxShadow: const [
              BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
            ],
          ),
          child: const Center(
            child: Text(
              'SUDAH SAMPAI DI TITIK JEMPUT 📍',
              style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
            ),
          ),
        ),
      );
    } else if (order.status == 'at_pickup') {
      return GestureDetector(
        onTap: () {
          driver.updateOrderStatus('on_trip');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: NeoColors.orange,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: NeoColors.black, width: 2),
            boxShadow: const [
              BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
            ],
          ),
          child: const Center(
            child: Text(
              'BARANG / PENUMPANG SUDAH NAIK 🚀',
              style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          driver.updateOrderStatus('completed');
          showDialog(
            context: context,
            builder: (c) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: NeoColors.black, width: 2.5),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 54)),
                  const SizedBox(height: 10),
                  const Text('Orderan Berhasil Selesai!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: NeoColors.black)),
                  const SizedBox(height: 6),
                  Text(
                    'Pendapatan Bersih (95% Split): ${currencyFmt.format(order.netDriverEarning)}\nSaldo telah ditambahkan ke Dompet BI-FAST.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(c);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: NeoColors.brand,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: NeoColors.black, width: 1.8),
                      ),
                      child: const Center(
                        child: Text('OK, Mantap 👍', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: NeoColors.green,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: NeoColors.black, width: 2),
            boxShadow: const [
              BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
            ],
          ),
          child: const Center(
            child: Text(
              'TIBA & SELESAIKAN ORDERAN ✅',
              style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
        ),
      );
    }
  }
}
