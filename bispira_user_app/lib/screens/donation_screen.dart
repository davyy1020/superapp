import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

class DonationScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const DonationScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int _userBalance = 250000;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Semua',
    '🍲 Makan Gratis Anak Yatim',
    '🤝 Yayasan Sosial',
    '🕌 Yayasan Keagamaan',
    '🌋 Bencana Alam',
    '🎓 Pendidikan',
  ];

  final List<Map<String, dynamic>> _campaigns = [
    {
      'title': 'Program Makan Gratis Anak Yatim Piatu (Rp 1.000 / Rp 2.000)',
      'category': '🍲 Makan Gratis Anak Yatim',
      'badge': 'SHEET 11 RESMI',
      'badgeColor': const Color(0xFF10B981),
      'description': 'Pemberian makan sehat dan bergizi untuk anak-anak yatim piatu dhuafa. Donasi mikro mulai dari Rp 1.000 dan Rp 2.000 tanpa potongan biaya apa pun.',
      'collected': 18500000,
      'target': 25000000,
      'percentage': 0.74,
      'percentText': '74%',
      'donorCount': '+3.4k',
      'emoji': '🍲',
      'isPrimary': true,
      'bgGradient': [const Color(0xFF0F172A), const Color(0xFF059669)],
    },
    {
      'title': 'Program Kegiatan Yayasan Sosial Nusantara',
      'category': '🤝 Yayasan Sosial',
      'badge': 'SOSIAL',
      'badgeColor': const Color(0xFF0284C7),
      'description': 'Bantuan operasional yayasan sosial mitra Bispira, santunan panti jompo, dan pemberdayaan tunawisma.',
      'collected': 34200000,
      'target': 50000000,
      'percentage': 0.68,
      'percentText': '68%',
      'donorCount': '+1.8k',
      'emoji': '🤝',
      'isPrimary': false,
      'bgGradient': [const Color(0xFF0284C7), const Color(0xFF0F172A)],
    },
    {
      'title': 'Program Kegiatan Yayasan Keagamaan Peduli Umat',
      'category': '🕌 Yayasan Keagamaan',
      'badge': 'KEAGAMAAN',
      'badgeColor': const Color(0xFFD4A017),
      'description': 'Renovasi sarana ibadah di pelosok, santunan guru ngaji, dan program keagamaan lintas daerah terpencil.',
      'collected': 42000000,
      'target': 60000000,
      'percentage': 0.70,
      'percentText': '70%',
      'donorCount': '+2.1k',
      'emoji': '🕌',
      'isPrimary': false,
      'bgGradient': [const Color(0xFF78350F), const Color(0xFFD97706)],
    },
    {
      'title': 'Bantu Korban Banjir Bandang Luwu Timur',
      'category': '🌋 Bencana Alam',
      'badge': 'URGENT',
      'badgeColor': const Color(0xFFEF4444),
      'description': 'Ribuan warga kehilangan tempat tinggal akibat luapan sungai. BISPIRA bersama relawan menyalurkan sembako dan tempat pengungsian.',
      'collected': 45200000,
      'target': 60000000,
      'percentage': 0.75,
      'percentText': '75%',
      'donorCount': '+1.2k',
      'emoji': '🌊',
      'isPrimary': false,
      'bgGradient': [const Color(0xFF0F172A), const Color(0xFF0040B8)],
    },
    {
      'title': 'Beasiswa Masa Depan Anak Pesosial',
      'category': '🎓 Pendidikan',
      'badge': 'PENDIDIKAN',
      'badgeColor': const Color(0xFFD4A017),
      'description': 'Bantuan seragam, buku, dan SPP sekolah untuk 100 siswa berprestasi di pelosok.',
      'collected': 27500000,
      'target': 30000000,
      'percentage': 0.91,
      'percentText': '91%',
      'donorCount': '+890',
      'emoji': '🎓',
      'isPrimary': false,
      'bgGradient': [const Color(0xFF7C3AED), const Color(0xFF0040B8)],
    },
  ];

  late List<Map<String, dynamic>> _filteredCampaigns;

  @override
  void initState() {
    super.initState();
    _filteredCampaigns = List.from(_campaigns);
  }

  void _filterCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      if (index == 0) {
        _filteredCampaigns = List.from(_campaigns);
      } else {
        final cat = _categories[index];
        _filteredCampaigns = _campaigns.where((c) => c['category'] == cat).toList();
      }
    });
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _openDonationModal(Map<String, dynamic> campaign) {
    int selectedAmount = 2000;
    final List<int> presetAmounts = [1000, 2000, 5000, 10000, 25000, 50000, 100000];
    final int uniqueCode = 100 + (DateTime.now().millisecondsSinceEpoch % 899);
    bool isAnonymous = false;
    TextEditingController noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
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
                          'Donasi Kebaikan 🤲',
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

                    // Campaign Summary Card
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
                                colors: campaign['bgGradient'] as List<Color>,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Center(
                              child: Text(campaign['emoji'] as String, style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  campaign['title'] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Terkumpul: Rp ${_formatPrice(campaign['collected'] as int)}',
                                  style: const TextStyle(fontSize: 11, color: NeoColors.brand, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sheet 11 Special Rule Banner
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCA8A04), width: 1.5),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified, size: 18, color: Color(0xFF854D0E)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Aturan Sheet 11: Rp 0 Biaya Layanan & Rp 0 Biaya Aplikasi. Donasi mikro mulai Rp 1.000 / Rp 2.000 hanya ditambah kode unik 3 digit.',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF854D0E)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Preset Amount Chips
                    const Text('Pilih Nominal Donasi:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: presetAmounts.map((amt) {
                        final bool isSel = selectedAmount == amt;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedAmount = amt),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF00B4D8) : NeoColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Text(
                              'Rp ${_formatPrice(amt)}',
                              style: TextStyle(
                                color: isSel ? NeoColors.white : NeoColors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Anonymous Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Donasi Anonim (Hamba Allah)',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black),
                        ),
                        Switch(
                          value: isAnonymous,
                          activeColor: const Color(0xFF00B4D8),
                          onChanged: (val) => setModalState(() => isAnonymous = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Message Field
                    TextField(
                      controller: noteController,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan / doa dukungan (Opsional)...',
                        hintStyle: const TextStyle(color: NeoColors.textMuted, fontSize: 11.5),
                        fillColor: NeoColors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: NeoColors.black, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Breakdown Payment
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NeoColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nominal Donasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              Text('Rp ${_formatPrice(selectedAmount)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Biaya Layanan & Aplikasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              Text('Rp 0 (GRATIS)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Kode Unik 3 Digit (Sheet 11)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              Text('+$uniqueCode', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.brand)),
                            ],
                          ),
                          const Divider(height: 12, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Pembayaran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                              Text(
                                'Rp ${_formatPrice(selectedAmount + uniqueCode)}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() {
                          campaign['collected'] = (campaign['collected'] as int) + selectedAmount;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Terima kasih! Donasi sebesar Rp ${_formatPrice(selectedAmount + uniqueCode)} telah disalurkan ❤️',
                            ),
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
                            'Salurkan Donasi Rp ${_formatPrice(selectedAmount + uniqueCode)} 🚀',
                            style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
              // 2. HERO BANNER (DIGITAL PHILANTHROPY)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF0040B8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B4D8).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00B4D8), width: 1.2),
                      ),
                      child: const Text(
                        'DIGITAL PHILANTHROPY',
                        style: TextStyle(
                          color: Color(0xFF00B4D8),
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kebaikan Berawal dari\nSatu Langkah.',
                      style: TextStyle(
                        color: NeoColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Platform donasi digital yang transparan dan amanah untuk membantu saudara kita yang membutuhkan.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        if (_filteredCampaigns.isNotEmpty) {
                          _openDonationModal(_filteredCampaigns.first);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B4D8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.black, width: 1.8),
                          boxShadow: const [
                            BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Eksplor Program',
                              style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, color: NeoColors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 3. CATEGORY CHIPS (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = _selectedCategoryIndex == index;

                    return GestureDetector(
                      onTap: () => _filterCategory(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0F172A) : NeoColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: NeoColors.black,
                            width: isSelected ? 2 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: isSelected ? NeoColors.white : NeoColors.black,
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
              const SizedBox(height: 20),

              // ============================================================
              // 4. CAMPAIGN CARDS (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredCampaigns.length,
                itemBuilder: (context, index) {
                  final item = _filteredCampaigns[index];
                  final bool isPrimary = item['isPrimary'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: NeoColors.black, width: 2.2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Container with Badge
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
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                              ),
                              child: Center(
                                child: Text(
                                  item['emoji'] as String,
                                  style: const TextStyle(fontSize: 70),
                                ),
                              ),
                            ),

                            // Urgent / Category Badge
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item['badgeColor'] as Color,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                ),
                                child: Text(
                                  item['badge'] as String,
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
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  color: NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Text(
                                item['description'] as String,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: NeoColors.textMuted,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Progress Indicator Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Terkumpul : Rp ${_formatPrice(item['collected'] as int)}',
                                    style: const TextStyle(
                                      color: NeoColors.brand,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                  Text(
                                    item['percentText'] as String,
                                    style: const TextStyle(
                                      color: NeoColors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: item['percentage'] as double,
                                  backgroundColor: NeoColors.bg,
                                  color: const Color(0xFF00B4D8),
                                  minHeight: 7,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Donors Row & Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Donor avatars pill
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: NeoColors.brandSoft,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: NeoColors.black, width: 1.2),
                                        ),
                                        child: Text(
                                          '👥 ${item['donorCount']} Donatur',
                                          style: const TextStyle(
                                            color: NeoColors.brand,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 10.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Donation Action Button
                                  GestureDetector(
                                    onTap: () => _openDonationModal(item),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isPrimary ? const Color(0xFF00B4D8) : NeoColors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isPrimary ? NeoColors.black : const Color(0xFF00B4D8),
                                          width: 1.8,
                                        ),
                                        boxShadow: isPrimary
                                            ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                                            : null,
                                      ),
                                      child: Text(
                                        isPrimary ? 'Donasi Sekarang' : 'Donasi',
                                        style: TextStyle(
                                          color: isPrimary ? NeoColors.white : const Color(0xFF00B4D8),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
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
              const SizedBox(height: 20),

              // ============================================================
              // 5. MONTHLY IMPACT REPORT (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Laporan Dampak Bulanan',
                      style: TextStyle(
                        color: NeoColors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Melalui BISPIRA, Anda telah membantu lebih dari 5,000+ penerima manfaat di 12 provinsi selama bulan ini.',
                      style: TextStyle(
                        color: NeoColors.textMuted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Metrics Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: NeoColors.bg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '12k+',
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: NeoColors.black),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'RELAWAN',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: NeoColors.textMuted, letterSpacing: 0.8),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: NeoColors.bg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '85+',
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: NeoColors.black),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'PROGRAM SELESAI',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: NeoColors.textMuted, letterSpacing: 0.8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Donut Chart Graphic
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: 0.92,
                              strokeWidth: 16,
                              backgroundColor: NeoColors.bg,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00B4D8)),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '92%',
                                style: TextStyle(
                                  color: NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                'TRANSPARANSI',
                                style: TextStyle(
                                  color: NeoColors.textMuted,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 9,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ],
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
}
