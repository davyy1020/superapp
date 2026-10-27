import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class KostScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const KostScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<KostScreen> createState() => _KostScreenState();
}

class _KostScreenState extends State<KostScreen> {
  int _userBalance = 250000;
  bool _isPaid = true;
  int _selectedFilterIndex = 0;

  final List<String> _filters = ['Semua Unit', 'Aktif Saya', 'Populer', 'Putri', 'Putra', 'Campur'];

  final List<Map<String, dynamic>> _kostUnits = [
    {
      'name': 'The Heritage Executive Kost',
      'unit': 'Unit 402B',
      'location': 'Menteng, Jakarta Pusat',
      'price': 4500000,
      'status': 'ACTIVE',
      'statusColor': const Color(0xFF00B4D8),
      'emoji': '🛏️',
      'isActive': true,
      'amenities': ['❄️ AC', '📶 Fiber WiFi', '🚿 Private Bath', '🅿️ Car Park'],
      'bgGradient': [const Color(0xFF0F172A), const Color(0xFF0040B8)],
    },
    {
      'name': 'South Quarter Residence',
      'unit': 'Unit 210A',
      'location': 'Cilandak, Jakarta Selatan',
      'price': 3800000,
      'status': 'POPULER',
      'statusColor': const Color(0xFF10B981),
      'emoji': '🏢',
      'isActive': false,
      'amenities': ['🔑 Smart Lock', '🏊 Pool Access', '🏋️ Gym', '🍳 Shared Kitchen'],
      'bgGradient': [const Color(0xFF10B981), const Color(0xFF0F172A)],
    },
    {
      'name': 'Senopati Boutique Residence',
      'unit': 'Unit 501VIP',
      'location': 'Kebayoran Baru, Jakarta Selatan',
      'price': 5200000,
      'status': 'PREMIUM',
      'statusColor': const Color(0xFFD4A017),
      'emoji': '👑',
      'isActive': false,
      'amenities': ['👑 King Bed', '📺 Smart TV 43"', '🚿 Water Heater', '🧹 Housekeeping'],
      'bgGradient': [const Color(0xFFD4A017), const Color(0xFF0040B8)],
    },
    {
      'name': 'Gading Luxury Living Kost',
      'unit': 'Unit 105',
      'location': 'Kelapa Gading, Jakarta Utara',
      'price': 2900000,
      'status': 'REKOMENDASI',
      'statusColor': const Color(0xFF0284C7),
      'emoji': '🏡',
      'isActive': false,
      'amenities': ['❄️ AC Dual Inverter', '🌅 Balcony', '🧺 Free Laundry', '🛡️ Security 24H'],
      'bgGradient': [const Color(0xFF0284C7), const Color(0xFF0F172A)],
    },
    {
      'name': 'Kemang Garden Exclusive Kost',
      'unit': 'Unit 304',
      'location': 'Kemang, Jakarta Selatan',
      'price': 3200000,
      'status': 'TERLARIS',
      'statusColor': const Color(0xFF7C3AED),
      'emoji': '🌿',
      'isActive': false,
      'amenities': ['📶 High-Speed WiFi', '❄️ AC', '🛋️ Living Lounge', '🌳 Garden View'],
      'bgGradient': [const Color(0xFF7C3AED), const Color(0xFF0040B8)],
    },
    {
      'name': 'BSD Green Park Kost Hub',
      'unit': 'Unit 112',
      'location': 'Serpong, Tangerang Selatan',
      'price': 2200000,
      'status': 'STUDENT',
      'statusColor': const Color(0xFFE11D48),
      'emoji': '🎒',
      'isActive': false,
      'amenities': ['📚 Study Area', '📶 Fiber 100Mbps', '🍳 Pantry 24H', '📹 CCTV Grid'],
      'bgGradient': [const Color(0xFFE11D48), const Color(0xFF0F172A)],
    },
  ];

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _showPaymentModal(Map<String, dynamic> unit) {
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
                    'Sewa / Bayar Kost 🏢',
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

              // Unit Card Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: unit['bgGradient'] as List<Color>,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: Center(
                        child: Text(unit['emoji'] as String, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(unit['name'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: NeoColors.black)),
                          const SizedBox(height: 2),
                          Text('${unit['unit']} • ${unit['location']}', style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Rent Breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Biaya Sewa Bulanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.black)),
                  Text('Rp ${_formatPrice(unit['price'] as int)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: NeoColors.black)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Metode Pembayaran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.black)),
                  Text('BISPIRA Pay 💳', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                ],
              ),
              const SizedBox(height: 20),

              // Confirm Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  if (unit['isActive'] == true) {
                    setState(() => _isPaid = true);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sewa ${unit['name']} (${unit['unit']}) Berhasil Dikonfirmasi! 📜'),
                      backgroundColor: NeoColors.brand,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B4D8),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Konfirmasi Pembayaran Rp ${_formatPrice(unit['price'] as int)} 💳',
                      style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showContactManagerSheet() {
    showModalBottomSheet(
      context: context,
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
                    '24/7 Concierge Support 🎧',
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
              const Text(
                'Manajer Kost: Pak Agus Haryanto\nKontak Darurat: 0812-9988-7711\nLayanan: Maintenance AC, Akses Kamar, Tagihan Air/Listrik',
                style: TextStyle(fontSize: 12, height: 1.5, color: NeoColors.black, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: NeoColors.black, width: 1.8),
                      ),
                      child: const Center(
                        child: Text('💬 WhatsApp', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12.5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: NeoColors.black, width: 1.8),
                      ),
                      child: const Center(
                        child: Text('📞 Telepon', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12.5)),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // 1. TOP HEADER BAR (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.onBackPressed != null) ...[
                        GestureDetector(
                          onTap: widget.onBackPressed,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: NeoColors.brandSoft,
                              shape: BoxShape.circle,
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, size: 16, color: NeoColors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'BISPIRA',
                        style: TextStyle(
                          color: NeoColors.brand,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),

                  // Balance Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: NeoColors.brandSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.brand, width: 1.5),
                    ),
                    child: Text(
                      '💳 Rp ${_formatPrice(_userBalance)}',
                      style: const TextStyle(
                        color: NeoColors.brand,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 2. BILLING STATUS CARD (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Billing Status',
                      style: TextStyle(
                        color: NeoColors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Current month: October 2026',
                      style: TextStyle(
                        color: NeoColors.textMuted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RENT PROGRESS',
                          style: TextStyle(
                            color: NeoColors.textMuted,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          _isPaid ? 'Paid' : 'Unpaid',
                          style: TextStyle(
                            color: _isPaid ? const Color(0xFF00B4D8) : Colors.redAccent,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Linear Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _isPaid ? 1.0 : 0.4,
                        backgroundColor: NeoColors.bg,
                        color: const Color(0xFF00B4D8),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      'Due in 14 days for next cycle',
                      style: TextStyle(
                        color: NeoColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ============================================================
              // 3. PREMIUM PARTNER BANNER (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4A017), Color(0xFFB8860B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PREMIUM PARTNER',
                        style: TextStyle(
                          color: NeoColors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Elevate Your Living Standard.',
                      style: TextStyle(
                        color: NeoColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Status Akun BISPIRA Premium Aktif! ✨'),
                            backgroundColor: NeoColors.brand,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B4D8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: NeoColors.black, width: 1.5),
                          boxShadow: const [
                            BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                          ],
                        ),
                        child: const Text(
                          'Upgrade Account',
                          style: TextStyle(
                            color: NeoColors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ============================================================
              // 4. FILTER CHIPS
              // ============================================================
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final bool isSel = _selectedFilterIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF0F172A) : NeoColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: NeoColors.black,
                            width: isSel ? 2 : 1.5,
                          ),
                          boxShadow: isSel
                              ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _filters[index],
                            style: TextStyle(
                              color: isSel ? NeoColors.white : NeoColors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 5. YOUR ACTIVE UNITS / KOST SELECTION GRID
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Active Units & Pilihan Kost',
                    style: TextStyle(
                      color: NeoColors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '${_kostUnits.length} Unit Available',
                    style: const TextStyle(
                      color: NeoColors.brand,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Dynamic Kost Unit Cards List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _kostUnits.length,
                itemBuilder: (context, index) {
                  final item = _kostUnits[index];
                  final bool isActive = item['isActive'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: NeoColors.black, width: 2.2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Banner Gradient with Emoji
                        Stack(
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: item['bgGradient'] as List<Color>,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Center(
                                child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 70)),
                              ),
                            ),

                            // Unit Number Badge
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                ),
                                child: Text(
                                  item['unit'] as String,
                                  style: const TextStyle(
                                    color: NeoColors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),

                            // Status Tag Badge
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item['statusColor'] as Color,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                ),
                                child: Text(
                                  item['status'] as String,
                                  style: const TextStyle(
                                    color: NeoColors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Card Body
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['name'] as String,
                                      style: const TextStyle(
                                        color: NeoColors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (isActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: NeoColors.brandSoft,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: NeoColors.brand, width: 1.2),
                                      ),
                                      child: const Text(
                                        'Active Now',
                                        style: TextStyle(
                                          color: NeoColors.brand,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: NeoColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['location'] as String,
                                    style: const TextStyle(
                                      color: NeoColors.textMuted,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Amenities Chips
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: (item['amenities'] as List<String>).map((amenity) {
                                  return _amenityChip(amenity);
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: NeoColors.black, thickness: 1.2),
                              const SizedBox(height: 10),

                              // Price & Action Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isActive ? 'NEXT BILL' : 'HARGA SEWA',
                                        style: const TextStyle(fontSize: 10, color: NeoColors.textMuted, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rp ${_formatPrice(item['price'] as int)}/bln',
                                        style: const TextStyle(
                                          color: NeoColors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14.5,
                                        ),
                                      ),
                                    ],
                                  ),

                                  GestureDetector(
                                    onTap: () => _showPaymentModal(item),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isActive ? const Color(0xFF0F172A) : const Color(0xFF00B4D8),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: NeoColors.black, width: 1.8),
                                        boxShadow: const [
                                          BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                                        ],
                                      ),
                                      child: Text(
                                        isActive ? 'Pay Rent' : 'Pesan Unit',
                                        style: const TextStyle(
                                          color: NeoColors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // ============================================================
              // 6. NEED HELP / CONCIERGE BANNER (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B4D8),
                            shape: BoxShape.circle,
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: const Text('🎧', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Need help?',
                              style: TextStyle(
                                color: NeoColors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '24/7 Concierge Support',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    GestureDetector(
                      onTap: _showContactManagerSheet,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.white, width: 1.2),
                        ),
                        child: const Center(
                          child: Text(
                            'Contact Manager',
                            style: TextStyle(
                              color: NeoColors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amenityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: NeoColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NeoColors.black, width: 1.2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: NeoColors.black,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
