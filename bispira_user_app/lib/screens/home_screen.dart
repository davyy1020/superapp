import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';
import '../widgets/custom_vector_icons.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;
  final Function(String) onOpenService;

  const HomeScreen({
    Key? key,
    required this.onNavigateTab,
    required this.onOpenService,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _promoIndex = 0;
  int _sponsorIndex = 0;
  late Timer _promoTimer;
  late Timer _sponsorTimer;
  late PageController _sponsorPageController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _sponsorCards = [
    {
      'tag': '👑 SPONSOR UTAMA',
      'title': 'Solusi Transportasi & Logistik Terpercaya 2026',
      'sub': 'Diskon s.d 70% perjalanan pertama dengan BISPIRA Ride & Car.',
      'gradient': const [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0052CC)],
      'badgeBg': NeoColors.gold,
      'badgeText': NeoColors.black,
      'emoji': '🚀',
    },
    {
      'tag': '💳 BISPIRA PAY EXCLUSIVE',
      'title': 'Cashback 100% Belanja & Bayar Tagihan',
      'sub': 'Bebas biaya admin transfer bank & Top Up saldo e-money se-Indonesia.',
      'gradient': const [Color(0xFF0040B8), Color(0xFF0066FF), Color(0xFF1E293B)],
      'badgeBg': NeoColors.white,
      'badgeText': NeoColors.brand,
      'emoji': '💎',
    },
    {
      'tag': '🗳️ CIVIC TECH PLATFORM',
      'title': 'E-Voting Transparan & Bebas Manipulasi',
      'sub': 'Teknologi enkripsi terintegrasi untuk suara organisasi yang akuntabel.',
      'gradient': const [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
      'badgeBg': NeoColors.gold,
      'badgeText': NeoColors.black,
      'emoji': '🗳️',
    },
  ];

  final List<Map<String, dynamic>> _promos = [
    {
      'tag': '⚡ PROMO BISPIRA BLUE',
      'title': 'Diskon 50% Ride & Food BISPIRA →',
      'sub': 'Kode Voucher: BISPIRA50 • S.d Rp 50rb',
      'bg': NeoColors.brandSoft,
      'badgeBg': NeoColors.brand,
      'badgeText': NeoColors.white,
      'emoji': '🚀',
    },
    {
      'tag': '🛵 GRATIS ONGKIR SE-INDONESIA',
      'title': 'Bebas Ongkir Antar Paket & Food →',
      'sub': 'Kode Voucher: FREESHIP • Tanpa Min Transaksi',
      'bg': NeoColors.goldSoft,
      'badgeBg': NeoColors.gold,
      'badgeText': NeoColors.black,
      'emoji': '📦',
    },
    {
      'tag': '🗳️ CIVIC E-VOTING CASHBACK',
      'title': 'Cashback 100% Saldo E-Voting →',
      'sub': 'Kode Voucher: VOTESUPER • Transparan',
      'bg': NeoColors.brandSoft,
      'badgeBg': NeoColors.brand,
      'badgeText': NeoColors.white,
      'emoji': '🗳️',
    },
  ];

  @override
  void initState() {
    super.initState();
    _sponsorPageController = PageController();

    _promoTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        setState(() => _promoIndex = (_promoIndex + 1) % _promos.length);
      }
    });

    _sponsorTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && _sponsorPageController.hasClients) {
        final nextPage = (_sponsorIndex + 1) % _sponsorCards.length;
        _sponsorPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _promoTimer.cancel();
    _sponsorTimer.cancel();
    _sponsorPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPromo = _promos[_promoIndex];

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 👋 HEADER WITH OFFICIAL LOGO & NATIVE VECTOR TOP-RIGHT ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // OFFICIAL BISPIRA LOGO
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: NeoColors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: NeoColors.brand,
                              child: const Center(
                                child: Text('B', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'BISPIRA SuperApp',
                            style: TextStyle(
                              color: NeoColors.brand,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '👋 Hey, Davy',
                            style: TextStyle(
                              color: NeoColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // TOP RIGHT ACTION BUTTONS: NATIVE CUSTOM VECTOR CANVAS
                  Row(
                    children: [
                      // Notification Bell with Solar Gold Dot
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: NeoColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: NeoColors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                              ],
                            ),
                            child: const VectorNotificationBell(size: 18, color: NeoColors.black),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: NeoColors.gold,
                                shape: BoxShape.circle,
                                border: Border.all(color: NeoColors.black, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      // LOGOUT BUTTON (NATIVE VECTOR DOOR ARROW)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: NeoColors.black, width: 2.5),
                              ),
                              title: Row(
                                children: const [
                                  VectorLogoutIcon(size: 22, color: Colors.redAccent),
                                  SizedBox(width: 10),
                                  Text('Keluar Akun?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                                ],
                              ),
                              content: const Text(
                                'Apakah Anda yakin ingin keluar dari aplikasi BISPIRA?',
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
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            shape: BoxShape.circle,
                            border: Border.all(color: NeoColors.black, width: 2),
                            boxShadow: const [
                              BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                            ],
                          ),
                          child: const VectorLogoutIcon(size: 18, color: Color(0xFFD32F2F)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. 🔍 SEARCH BAR WITH VECTOR SEARCH ICON
              Container(
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: VectorSearchIcon(size: 20, color: NeoColors.brand),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari layanan, ride, food, atau tagihan...',
                          hintStyle: TextStyle(color: NeoColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 3. 💳 SISTEM PEMBAYARAN: TRANSFER BANK (KODE UNIK) & QRIS (CEK MANUAL ADMIN)
              SoftNeoCard(
                backgroundColor: NeoColors.brand,
                borderColor: NeoColors.black,
                shadowOffset: 4.5,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Metode Pembayaran Resmi',
                              style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Transfer Bank & QRIS',
                              style: TextStyle(color: NeoColors.white, fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: NeoColors.black, width: 1.5),
                            boxShadow: const [
                              BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                            ],
                          ),
                          child: const Text(
                            '🛡️ Verifikasi Manual Admin',
                            style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 10.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: NeoColors.gold, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'BISPIRA tidak menyimpan saldo dompet. Pembayaran via Transfer Bank + Kode Unik atau QRIS diverifikasi tim Admin.',
                              style: TextStyle(color: NeoColors.white, fontSize: 10.5, fontWeight: FontWeight.w600, height: 1.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(height: 1, color: Colors.white.withOpacity(0.18)),
                    const SizedBox(height: 12),
                    // Quick Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _brandWalletBtn('🏦', 'Transfer', onTap: () => _showBankAccountsModal(context)),
                        _brandWalletBtn('📱', 'QRIS Pay', onTap: () => _showQrisModal(context)),
                        _brandWalletBtn('🔍', 'Cek Mutasi', onTap: () => _showVerificationStatusModal(context)),
                        _brandWalletBtn('📜', 'Riwayat', onTap: () => widget.onNavigateTab(1)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 🌟 4. INTERACTIVE SWIPEABLE SPONSOR HERO BANNER CAROUSEL
              Column(
                children: [
                  SizedBox(
                    height: 190,
                    child: PageView.builder(
                      controller: _sponsorPageController,
                      onPageChanged: (index) => setState(() => _sponsorIndex = index),
                      itemCount: _sponsorCards.length,
                      itemBuilder: (context, index) {
                        final card = _sponsorCards[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 2),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: card['gradient'] as List<Color>,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: NeoColors.black, width: 2.5),
                            boxShadow: const [
                              BoxShadow(color: NeoColors.black, offset: Offset(4, 4), blurRadius: 0),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sponsor Tag Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: card['badgeBg'] as Color,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: NeoColors.black, width: 1.5),
                                    ),
                                    child: Text(
                                      card['tag'] as String,
                                      style: TextStyle(
                                        color: card['badgeText'] as Color,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  const Text('Geser ›', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 12),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card['title'] as String,
                                          style: const TextStyle(
                                            color: NeoColors.white,
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w900,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          card['sub'] as String,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Sponsor Avatar Pin / Emoji mark
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: NeoColors.white,
                                      border: Border.all(color: NeoColors.gold, width: 2.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: NeoColors.gold.withOpacity(0.4),
                                          blurRadius: 14,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        card['emoji'] as String,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Carousel Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_sponsorCards.length, (index) {
                      final bool isSelected = _sponsorIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected ? NeoColors.brand : NeoColors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: isSelected ? Border.all(color: NeoColors.black, width: 1) : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 5. ⚡ 12 VERTICAL SERVICES GRID (OPSI A: SOFT ROYAL ACCENT - CLEAN & LUXURY)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'LAYANAN UTAMA',
                    style: TextStyle(
                      color: NeoColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    '12 Vertikal • Royal Soft',
                    style: TextStyle(
                      color: NeoColors.brand,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.76,
                children: [
                  SoftNeoServiceTile(emoji: '🍔', label: '1. FOOD', color: NeoColors.brandSoft, onTap: () => widget.onOpenService('food')),
                  SoftNeoServiceTile(emoji: '🎓', label: '2. AHLI', color: NeoColors.goldSoft, onTap: () => widget.onOpenService('jasa')),
                  SoftNeoServiceTile(emoji: '🏥', label: '3. SEHAT', color: NeoColors.brandSoft, onTap: () => widget.onOpenService('health')),
                  SoftNeoServiceTile(emoji: '🛵', label: '4. DRIVER', color: NeoColors.goldSoft, onTap: () => widget.onOpenService('ride')),
                  SoftNeoServiceTile(emoji: '🎟️', label: '5. TIKET', color: NeoColors.brandSoft, onTap: () => widget.onOpenService('tickets')),
                  SoftNeoServiceTile(emoji: '🏢', label: '6. KOST', color: NeoColors.goldSoft, onTap: () => widget.onOpenService('kost')),
                  SoftNeoServiceTile(emoji: '📢', label: '7. ADS', color: NeoColors.brandSoft, onTap: () => _showAdsModal(context)),
                  SoftNeoServiceTile(emoji: '🤝', label: '8. DONASI', color: NeoColors.goldSoft, onTap: () => widget.onOpenService('donasi')),
                  SoftNeoServiceTile(emoji: '📍', label: '9. VOTE CBG', color: NeoColors.brandSoft, onTap: () => widget.onOpenService('evoting_cabang')),
                  SoftNeoServiceTile(emoji: '🗳️', label: '10. VOTE PST', color: NeoColors.goldSoft, onTap: () => widget.onOpenService('evoting_pusat')),
                  SoftNeoServiceTile(emoji: '⚡', label: '11. EO CBG', color: NeoColors.brandSoft, onTap: () => widget.onOpenService('eo_cabang')),
                  SoftNeoServiceTile(emoji: '🏆', label: '12. EO PST', color: NeoColors.goldSoft, onTap: () => widget.onOpenService('eo_pusat')),
                ],
              ),
              const SizedBox(height: 24),

              // 6. 🎁 HERO PROMO CARD
              SoftNeoCard(
                backgroundColor: currentPromo['bg'] as Color,
                shadowOffset: 4.5,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SoftNeoBadge(
                            label: currentPromo['tag'] as String,
                            backgroundColor: currentPromo['badgeBg'] as Color,
                            textColor: currentPromo['badgeText'] as Color,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentPromo['title'] as String,
                            style: const TextStyle(
                              color: NeoColors.black,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            currentPromo['sub'] as String,
                            style: const TextStyle(
                              color: NeoColors.black,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      currentPromo['emoji'] as String,
                      style: const TextStyle(fontSize: 42),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 7. 📜 RECENT ACTIVITY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RECENT ACTIVITY',
                    style: TextStyle(
                      color: NeoColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.onNavigateTab(1),
                    child: const Text(
                      'See all ›',
                      style: TextStyle(
                        color: NeoColors.brand,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Column(
                children: [
                  _recentActivityItem(
                    emoji: '🛵',
                    title: 'Ride to Sudirman Center',
                    sub: 'Today • 14:20 WIB',
                    price: 'Rp 14.000',
                    status: 'Completed',
                    onTap: () => widget.onOpenService('ride'),
                  ),
                  const SizedBox(height: 10),
                  _recentActivityItem(
                    emoji: '🍔',
                    title: 'Food — Ayam Geprek Sambal',
                    sub: 'Yesterday • 18:45 WIB',
                    price: 'Rp 25.000',
                    status: 'Success',
                    onTap: () => widget.onOpenService('food'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 8. 🗳️ CIVIC E-VOTING CARD
              SoftNeoCard(
                backgroundColor: NeoColors.white,
                shadowOffset: 4.0,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: NeoColors.brandSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.black, width: 2),
                      ),
                      child: const Text('🗳️', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Civic E-Voting BISPIRA',
                            style: TextStyle(color: NeoColors.black, fontSize: 15, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Suara Anda menentukan masa depan organisasi.',
                            style: TextStyle(color: NeoColors.textMuted, fontSize: 11.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SoftNeoButton(
                      text: 'Vote',
                      backgroundColor: NeoColors.gold,
                      textColor: NeoColors.black,
                      onPressed: () => widget.onNavigateTab(2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Wallet Quick Action Button Helper
  Widget _brandWalletBtn(String emoji, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: NeoColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: NeoColors.black, width: 1.8),
              boxShadow: const [
                BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
              ],
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: NeoColors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // Recent Activity Item Helper
  Widget _recentActivityItem({
    required String emoji,
    required String title,
    required String sub,
    required String price,
    required String status,
    required VoidCallback onTap,
  }) {
    return MinimalCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: NeoColors.brandSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: NeoColors.black, width: 1.5),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: NeoColors.black, fontSize: 13.5, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: const TextStyle(color: NeoColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(color: NeoColors.brand, fontSize: 13, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: NeoColors.mint,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: NeoColors.white, fontSize: 9.5, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAdsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: NeoColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mitra Ads (Sistem Iklan Mandiri) 📢',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: NeoColors.brandSoft, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 18, color: NeoColors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Feature 1: Brand Awareness
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.brandSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('👑', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1. Brand Awareness', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                          SizedBox(height: 3),
                          Text(
                            'Menampilkan profil & brand mitra terverifikasi sesuai kategori produk di papan atas (Top Hero) secara bergantian otomatis.',
                            style: TextStyle(fontSize: 11, color: NeoColors.black, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Feature 2: Banner Produk & Harga
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.goldSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('🏷️', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('2. Banner Produk & Harga', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                          SizedBox(height: 3),
                          Text(
                            'Spanduk utama (top tier banner) menampilkan foto produk + harga diskon, berputar otomatis (auto-scroll) setiap User membuka aplikasi.',
                            style: TextStyle(fontSize: 11, color: NeoColors.black, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Banner Iklan Mandiri Anda Berhasil Diaktifkan di Top Carousel!'),
                        backgroundColor: NeoColors.brand,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NeoColors.brand,
                    foregroundColor: NeoColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: NeoColors.black, width: 2),
                    ),
                  ),
                  child: const Text('Pasang Iklan Produk Sekarang 🚀', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBankAccountsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: NeoColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rekening Transfer Resmi BISPIRA 🏦', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Setiap pembayaran wajib menyertakan 3 digit kode unik agar diverifikasi oleh Admin BISPIRA.',
              style: TextStyle(fontSize: 11.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            _bankRow('BCA', '8840-192-381', 'PT BISPIRA DIGITAL NUSANTARA'),
            const SizedBox(height: 10),
            _bankRow('MANDIRI', '136-00-9821-4401', 'PT BISPIRA DIGITAL NUSANTARA'),
            const SizedBox(height: 10),
            _bankRow('BRI', '0012-01-002938-501', 'PT BISPIRA DIGITAL NUSANTARA'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoColors.brand,
                foregroundColor: NeoColors.white,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: NeoColors.black, width: 1.8),
                ),
              ),
              child: const Text('Mengerti 👍', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bankRow(String bank, String accNo, String holder) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoColors.black, width: 1.6),
        boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: NeoColors.brand,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(bank, style: const TextStyle(fontWeight: FontWeight.w900, color: NeoColors.white, fontSize: 11)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(accNo, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black, letterSpacing: 0.5)),
                Text(holder, style: const TextStyle(fontSize: 10, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQrisModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: NeoColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('QRIS Standar Pembayaran 📱', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: NeoColors.black, width: 2),
                boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: Column(
                children: [
                  const Text('QRIS BISPIRA SUPERAPP', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                  const SizedBox(height: 4),
                  const Text('NMID: ID1026904288190', style: TextStyle(fontSize: 10, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  const Icon(Icons.qr_code_2_rounded, size: 160, color: NeoColors.black),
                  const SizedBox(height: 8),
                  const Text('BCA • Mandiri • BRI • BNI • GoPay • OVO • Dana • ShopeePay', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: NeoColors.brand)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Setelah scan QRIS, admin BISPIRA akan memverifikasi mutasi Anda.',
              style: TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoColors.brand,
                foregroundColor: NeoColors.white,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: NeoColors.black, width: 1.8),
                ),
              ),
              child: const Text('Tutup QRIS 👍', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  void _showVerificationStatusModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: NeoColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status Verifikasi Mutasi Bank 🔍', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF22C55E), width: 1.8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.verified_rounded, color: Color(0xFF16A34A), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mutasi Terverifikasi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF166534))),
                        Text('Order #BSP-8812 • Rp 34.439 (Kode Unik 439) telah disetujui Admin BISPIRA.', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoColors.brand,
                foregroundColor: NeoColors.white,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: NeoColors.black, width: 1.8),
                ),
              ),
              child: const Text('Tutup 👍', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}


