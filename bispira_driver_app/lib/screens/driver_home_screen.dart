import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/driver_provider.dart';
import '../theme/neo_theme.dart';
import 'active_trip_screen.dart';
import 'driver_wallet_screen.dart';
import 'driver_profile_screen.dart';
import '../utils/maps_launcher.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _selectedTab = 0;
  final MapController _mapController = MapController();
  final LatLng _driverLatLng = const LatLng(-6.2088, 106.8456); // SCBD, Jakarta

  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final driver = Provider.of<DriverProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _buildDashboardTab(driver),
            const DriverWalletScreen(),
            const DriverProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildDashboardTab(DriverProvider driver) {
    return Stack(
      children: [
        // 1. LIVE MAP BACKGROUND
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _driverLatLng,
            initialZoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bispira.driverapp',
            ),
            // GACOR HOTSPOT ZONES
            CircleLayer(
              circles: [
                CircleMarker(
                  point: const LatLng(-6.2088, 106.8456),
                  color: NeoColors.brand.withOpacity(0.2),
                  borderColor: NeoColors.brand,
                  borderStrokeWidth: 2,
                  radius: 1200,
                ),
                CircleMarker(
                  point: const LatLng(-6.2240, 106.8090),
                  color: NeoColors.gold.withOpacity(0.25),
                  borderColor: NeoColors.gold,
                  borderStrokeWidth: 2,
                  radius: 800,
                ),
              ],
            ),
            // DRIVER LOCATION MARKER
            MarkerLayer(
              markers: [
                Marker(
                  point: _driverLatLng,
                  width: 48,
                  height: 48,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: driver.isOnline ? NeoColors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, blurRadius: 8, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        driver.armada == DriverArmada.motor
                            ? '🛵'
                            : driver.armada == DriverArmada.ambulance
                                ? '🚑'
                                : '🚗',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // 2. TOP HEADER STATUS BAR (ONLINE / OFFLINE TOGGLE)
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: driver.isOnline ? NeoColors.green : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver.isOnline ? 'SIAP TERIMA ORDER ⚡' : 'SEDANG OFFLINE',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: driver.isOnline ? NeoColors.greenDark : NeoColors.black,
                              ),
                            ),
                            Text(
                              driver.driverName,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: driver.isOnline,
                      activeColor: NeoColors.green,
                      onChanged: (val) => driver.toggleOnline(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // PERFORMANCE STATS CARD
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Pendapatan', currencyFmt.format(driver.todayEarnings), NeoColors.brand),
                    _buildStatDivider(),
                    _buildStatItem('Trip', '${driver.todayTrips} Selesai', NeoColors.black),
                    _buildStatDivider(),
                    _buildStatItem('Rating', '${driver.rating} ★', NeoColors.gold),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 3. FLOATING ACTION SIMULATION & ACTIVE TRIP BAR
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            children: [
              if (driver.activeOrder != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ActiveTripScreen()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: NeoColors.gold,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: NeoColors.black, width: 2.2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(driver.activeOrder!.serviceEmoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ORDERAN AKTIF BERJALAN 🚀', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                              Text('${driver.activeOrder!.serviceName} • ${driver.activeOrder!.customerName}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.black)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final o = driver.activeOrder!;
                            final isPickup = o.status == 'accepted';
                            MapsLauncherHelper.openDirections(
                              lat: isPickup ? o.pickupLat : o.dropoffLat,
                              lng: isPickup ? o.pickupLng : o.dropoffLng,
                              destinationLabel: isPickup ? o.pickupAddress : o.dropoffAddress,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: NeoColors.brand,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.navigation_rounded, color: NeoColors.white, size: 14),
                                SizedBox(width: 4),
                                Text('Maps', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: NeoColors.black, size: 18),
                      ],
                    ),
                  ),
                ),

              // SIMULATE INCOMING ORDER BUTTON (FOR DEMONSTRATION & TESTING)
              GestureDetector(
                onTap: () {
                  if (!driver.isOnline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Aktifkan Status ONLINE terlebih dahulu!')),
                    );
                    return;
                  }
                  driver.simulateIncomingOrder();
                  _showIncomingOrderSheet(context, driver);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: NeoColors.brand,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: NeoColors.black, width: 2.2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt_rounded, color: NeoColors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'SIMULASI ORDER MASUK ⚡',
                        style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
        const SizedBox(height: 3),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: valueColor)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 26, color: NeoColors.black.withOpacity(0.15));
  }

  // INCOMING ORDER MODAL DIALOG (15 SECOND COUNTDOWN)
  void _showIncomingOrderSheet(BuildContext context, DriverProvider driver) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Consumer<DriverProvider>(
          builder: (_, d, __) {
            final order = d.incomingOrder;
            if (order == null) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.all(22),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(order.serviceEmoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.serviceName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                              Text('Metode: ${order.paymentMethod}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.brand)),
                            ],
                          ),
                        ],
                      ),

                      // Countdown timer badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: NeoColors.red,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: NeoColors.black, width: 1.5),
                        ),
                        child: Text(
                          '${d.countdownSeconds}s ⏱️',
                          style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: NeoColors.black, height: 1, thickness: 1.5),
                  const SizedBox(height: 14),

                  // NET FARE DRIVER HIGHLIGHT CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: NeoColors.greenSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.green, width: 1.8),
                    ),
                    child: Column(
                      children: [
                        const Text('PENDAPATAN BERSIH DRIVER (95%)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.greenDark, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text(
                          currencyFmt.format(order.netDriverEarning),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: NeoColors.greenDark),
                        ),
                        Text('Jarak Tempuh: ${order.distanceKm} km', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.black)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // LOCATION INFO
                  Row(
                    children: [
                      const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Jemput: ${order.pickupAddress}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tujuan: ${order.dropoffAddress}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ACCEPT & REJECT BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            d.rejectOrder();
                            Navigator.pop(ctx);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: NeoColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: NeoColors.black, width: 2),
                            ),
                            child: const Center(
                              child: Text('TOLAK ✖️', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            final targetOrder = d.incomingOrder;
                            d.acceptOrder();
                            Navigator.pop(ctx);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ActiveTripScreen()),
                                );
                              }
                            });
                            if (targetOrder != null) {
                              MapsLauncherHelper.openDirections(
                                lat: targetOrder.pickupLat,
                                lng: targetOrder.pickupLng,
                                destinationLabel: targetOrder.pickupAddress,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: NeoColors.green,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: NeoColors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                              ],
                            ),
                            child: const Center(
                              child: Text('TERIMA ORDER 🚀', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: NeoColors.surface,
        border: Border(top: BorderSide(color: NeoColors.black, width: 2)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        selectedItemColor: NeoColors.brand,
        unselectedItemColor: NeoColors.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Dompet BI-FAST'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil Driver'),
        ],
      ),
    );
  }
}
