import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';
import '../widgets/curved_nav_bar.dart';
import 'home_screen.dart';
import 'ride_screen.dart';
import 'food_screen.dart';
import 'send_screen.dart';
import 'health_screen.dart';
import 'expert_screen.dart';
import 'kost_screen.dart';
import 'donation_screen.dart';
import 'evoting_screen.dart';
import 'mart_screen.dart';
import 'tax_screen.dart';
import 'tickets_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String? _activeSubService;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
      _activeSubService = null;
    });
  }

  void _openService(String serviceKey) {
    setState(() => _activeSubService = serviceKey);
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_activeSubService == 'ride') {
      bodyContent = RideScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'food') {
      bodyContent = FoodScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'send') {
      bodyContent = SendScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'health') {
      bodyContent = HealthScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'jasa' || _activeSubService == 'expert') {
      bodyContent = ExpertScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'kost') {
      bodyContent = KostScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'donation' || _activeSubService == 'donasi') {
      bodyContent = DonationScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'vote' || _activeSubService == 'evoting') {
      bodyContent = EVotingScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'tax' || _activeSubService == 'pajak') {
      bodyContent = TaxScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'mart' || _activeSubService == 'belanja') {
      bodyContent = MartScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else {
      switch (_currentIndex) {
        case 0:
          bodyContent = HomeScreen(onNavigateTab: _navigateToTab, onOpenService: _openService);
          break;
        case 1:
          bodyContent = const TicketsScreen();
          break;
        case 2:
          bodyContent = const EVotingScreen();
          break;
        case 3:
          bodyContent = const ProfileScreen();
          break;
        default:
          bodyContent = HomeScreen(onNavigateTab: _navigateToTab, onOpenService: _openService);
      }
    }

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: bodyContent,
      extendBody: true,
      bottomNavigationBar: AnimatedCurvedNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _activeSubService = null;
          });
        },
        items: [
          CurvedNavItem(emoji: '🏠', label: 'Home'),
          CurvedNavItem(emoji: '📜', label: 'Activity'),
          CurvedNavItem(emoji: '🗳️', label: 'Voting'),
          CurvedNavItem(emoji: '👑', label: 'Profile'),
        ],
      ),
    );
  }

  // OFFICIAL BISPIRA "PUSAT USER" PROFILE PAGE (MATCHING GOOGLE SHEETS SPECIFICATION)
  Widget _buildProfilePage() {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NeoColors.brand,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: NeoColors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(4, 4), blurRadius: 0),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            shape: BoxShape.circle,
                            border: Border.all(color: NeoColors.black, width: 2.5),
                          ),
                          child: const Center(
                            child: Text('D', style: TextStyle(color: NeoColors.black, fontSize: 36, fontWeight: FontWeight.w900)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: NeoColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: const Text('👑', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 1. NAMA LENGKAP
                    const Text(
                      'Davy Wahyu Saputra',
                      style: TextStyle(color: NeoColors.white, fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),

                    // 2. ID MEMBER & AKUN TYPE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: NeoColors.black, width: 1.5),
                          ),
                          child: const Text(
                            'ID: BSP-2026-9042',
                            style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: NeoColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: NeoColors.black, width: 1.5),
                          ),
                          child: const Text(
                            'AKUN: Pusat User 👑',
                            style: TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // OFFICIAL USER DATA SCHEMA DETAILS (9 COLUMNS FROM GOOGLE SHEETS)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'DATA RESMI PUSAT USER',
                    style: TextStyle(color: NeoColors.black, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                  ),
                  Text(
                    'Tersinkronisasi ⚡',
                    style: TextStyle(color: NeoColors.brand, fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _profileDetailTile(
                num: '1',
                title: 'NAMA LENGKAP',
                value: 'Davy Wahyu Saputra',
                icon: Icons.badge_rounded,
                badge: 'Verified',
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '2',
                title: 'AKUN (TYPE / ROLE)',
                value: 'Pusat User (VIP National)',
                icon: Icons.workspace_premium_rounded,
                badge: 'Pusat',
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '3',
                title: 'USER NAME',
                value: '@davywahyu',
                icon: Icons.alternate_email_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '4',
                title: 'PASSWORD',
                value: '•••••••••••• (Terenkripsi)',
                icon: Icons.lock_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '5',
                title: 'ID USER BISPIRA',
                value: 'BSP-2026-9042',
                icon: Icons.fingerprint_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '6',
                title: 'NOMOR WA (WHATSAPP)',
                value: '+62 812-3456-7890',
                icon: Icons.phone_android_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '7',
                title: 'EMAIL TERDAFTAR',
                value: 'davy@bispira.id',
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '8',
                title: 'KABUPATEN / KOTA',
                value: 'Jakarta Selatan',
                icon: Icons.location_city_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '9',
                title: 'PROVINSI',
                value: 'DKI Jakarta',
                icon: Icons.map_rounded,
              ),
              const SizedBox(height: 24),

              // LOGOUT BUTTON IN PROFILE PAGE
              SoftNeoButton(
                text: 'Keluar Akun BISPIRA 🚪',
                backgroundColor: const Color(0xFFFFEBEE),
                textColor: const Color(0xFFD32F2F),
                borderColor: const Color(0xFFD32F2F),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: NeoColors.black, width: 2.5),
                      ),
                      title: const Row(
                        children: [
                          Text('🚪', style: TextStyle(fontSize: 22)),
                          SizedBox(width: 8),
                          Text('Keluar Akun?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                        ],
                      ),
                      content: const Text(
                        'Apakah Anda yakin ingin keluar dari akun BISPIRA?',
                        style: TextStyle(color: NeoColors.black, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Batal', style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w800)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text('Keluar', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileDetailTile({
    required String num,
    required String title,
    required String value,
    required IconData icon,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: NeoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoColors.black, width: 1.8),
        boxShadow: const [
          BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: NeoColors.brandSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: NeoColors.black, width: 1.2),
            ),
            child: Icon(icon, color: NeoColors.brand, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$num. $title',
                  style: const TextStyle(color: NeoColors.textMuted, fontSize: 10, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: NeoColors.black, fontSize: 13.5, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: NeoColors.gold,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: NeoColors.black, width: 1.2),
              ),
              child: Text(
                badge,
                style: const TextStyle(color: NeoColors.black, fontSize: 9.5, fontWeight: FontWeight.w900),
              ),
            ),
        ],
      ),
    );
  }
}
