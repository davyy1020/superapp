import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../theme/neo_theme.dart';
import 'telemedicine_chat_screen.dart';
import 'services_catalog_screen.dart';
import 'health_wallet_screen.dart';
import 'health_profile_screen.dart';

class HealthHomeScreen extends StatefulWidget {
  const HealthHomeScreen({Key? key}) : super(key: key);

  @override
  State<HealthHomeScreen> createState() => _HealthHomeScreenState();
}

class _HealthHomeScreenState extends State<HealthHomeScreen> {
  int _currentTabIndex = 0;
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    final List<Widget> pages = [
      _buildDashboardView(context, provider),
      const HealthServicesCatalogScreen(),
      const HealthWalletScreen(),
      const HealthProfileScreen(),
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
          selectedItemColor: NeoColors.healthDark,
          unselectedItemColor: NeoColors.textMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Ruang Praktik'),
            BottomNavigationBarItem(icon: Icon(Icons.medical_services_rounded), label: 'Tarif & Layanan'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Dompet'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'STR & Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardView(BuildContext context, HealthProvider provider) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP PRACTITIONER HEADER
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: NeoColors.healthSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Center(child: Text('👨‍⚕️', style: TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(provider.practitionerName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, color: NeoColors.health, size: 16),
                        ],
                      ),
                      Text('STR: ${provider.strNumber}', style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => provider.toggleOnlineStatus(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: provider.isOnline ? NeoColors.green : Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Text(
                      provider.isOnline ? 'ONLINE SIAGA' : 'OFFLINE',
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
                        const Text('Saldo Praktik', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        const SizedBox(height: 4),
                        Text(currencyFmt.format(provider.walletBalance), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: NeoColors.greenDark)),
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
                        const Text('Total Pasien', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        const SizedBox(height: 4),
                        Text('${provider.totalPatients} Pasien', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: NeoColors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ACTIVE PATIENT QUEUE (TELEMEDICINE & HOME VISIT)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('ANTEAN PASIEN SIAGA HARI INI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                Text('Real-time OSRM / Chat', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.healthDark)),
              ],
            ),
            const SizedBox(height: 10),

            ...provider.consultations.map((c) {
              final bool isActive = c.status == 'active';
              final bool isWaiting = c.status == 'waiting';

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
                            color: c.visitType == VisitType.chatTelemedicine ? NeoColors.healthSoft : NeoColors.goldSoft,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1.2),
                          ),
                          child: Text(
                            c.visitType == VisitType.chatTelemedicine ? '💬 Telemedicine' : '🏡 Home Visit',
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(c.scheduleTime, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(c.patientName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text('${c.patientAge} th • ${c.gender}', style: const TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                    const SizedBox(height: 6),
                    Text('Keluhan: "${c.complaint}"', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currencyFmt.format(c.fee), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: NeoColors.greenDark)),
                        if (isActive || isWaiting)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => TelemedicineChatScreen(consultation: c)),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: NeoColors.health,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: Text(
                                isActive ? 'Buka Ruang Konsultasi 💬' : 'Mulai Konsultasi 🚀',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                            child: const Text('Selesai ✓', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
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

