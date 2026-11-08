import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expert_provider.dart';
import '../theme/neo_theme.dart';
import 'booking_detail_screen.dart';
import 'services_catalog_screen.dart';
import 'expert_wallet_screen.dart';
import 'expert_profile_screen.dart';

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen> {
  int _currentTabIndex = 0;
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpertProvider>(context);

    final List<Widget> pages = [
      _buildDashboardView(context, provider),
      const ExpertServicesCatalogScreen(),
      const ExpertWalletScreen(),
      const ExpertProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: pages[_currentTabIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black, width: 2)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (idx) => setState(() => _currentTabIndex = idx),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: NeoColors.expertDark,
          unselectedItemColor: NeoColors.textMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Jadwal & Order'),
            BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Tarif & Layanan'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Dompet'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil Mitra'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardView(BuildContext context, ExpertProvider provider) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP EXPERT HEADER
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: NeoColors.expertSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Center(child: Text('👨‍🏫', style: TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              provider.expertName,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, color: NeoColors.expert, size: 16),
                        ],
                      ),
                      Text(provider.professionTitle, style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => provider.toggleAvailability(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: provider.isReadyForBooking ? NeoColors.green : Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Text(
                      provider.isReadyForBooking ? 'SIAGA ORDER' : 'OFFLINE',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // QUICK METRICS CARDS
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 1.8),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo Honorarium', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        const SizedBox(height: 4),
                        Text(currencyFmt.format(provider.walletBalance), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: NeoColors.greenDark)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 1.8),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sesi Selesai', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        const SizedBox(height: 4),
                        Text('${provider.totalSessionsCompleted} Sesi', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: NeoColors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // BOOKING LIST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('JADWAL BOOKING & SESI TERBARU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                Text('Real-time Sinkron Bispira', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.expertDark)),
              ],
            ),
            const SizedBox(height: 10),

            ...provider.bookings.map((b) {
              Color badgeColor;
              String badgeText;
              switch (b.status) {
                case 'confirmed':
                  badgeColor = NeoColors.greenSoft;
                  badgeText = 'Terkonfirmasi ✓';
                  break;
                case 'completed':
                  badgeColor = Colors.grey[200]!;
                  badgeText = 'Selesai';
                  break;
                case 'cancelled':
                  badgeColor = NeoColors.redSoft;
                  badgeText = 'Dibatalkan';
                  break;
                case 'pending':
                default:
                  badgeColor = NeoColors.goldSoft;
                  badgeText = 'Menunggu Konfirmasi';
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1.2),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(b.scheduleDate, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(b.serviceName, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 14, color: NeoColors.textMuted),
                        const SizedBox(width: 4),
                        Text('Klien: ${b.clientName}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.black)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: NeoColors.textMuted),
                        const SizedBox(width: 4),
                        Expanded(child: Text(b.locationAddress, style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Honor Bersih Mitra (100%)', style: TextStyle(fontSize: 9.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                            Text(currencyFmt.format(b.fee), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: NeoColors.greenDark)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: b)),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: NeoColors.expert,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: const Text(
                              'Kelola Sesi ➔',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
