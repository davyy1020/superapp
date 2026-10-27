import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class ExpertScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const ExpertScreen({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<ExpertScreen> createState() => _ExpertScreenState();
}

class _ExpertScreenState extends State<ExpertScreen> {
  int _selectedCategoryIndex = 0;
  int _userBalance = 250000;
  bool _showAllMitra = false;

  final List<String> _categories = [
    'Semua',
    'Pajak',
    'Guru',
    'Seni',
    'Bisnis',
    'Hukum',
    'Teknologi',
  ];

  final List<Map<String, dynamic>> _allExperts = [
    {
      'name': 'Bambang S. Praja, M.Ak',
      'title': 'Konsultan Pajak & Audit Finansial',
      'category': 'Pajak',
      'rating': '4.9 (120+)',
      'isUtama': true,
      'description':
          'Berpengalaman lebih dari 15 tahun dalam restrukturisasi pajak korporasi dan pendampingan audit untuk UMKM serta perusahaan multinasional.',
      'tags': ['SPT Tahunan', 'Audit', 'Legalitas'],
      'price': 450000,
      'unit': '/sesi',
      'avatarEmoji': '👔',
      'avatarBg': const Color(0xFF0040B8),
      'hasFullBtn': true,
    },
    {
      'name': 'Siti Aminah, M.Pd',
      'title': 'Guru Matematika & Fisika',
      'category': 'Guru',
      'rating': '4.8',
      'isUtama': false,
      'description':
          'Spesialis persiapan ujian masuk perguruan tinggi negeri (UTBK) dengan metode visual yang mudah dipahami.',
      'tags': ['UTBK', 'Fisika Dasar', 'Matematika'],
      'price': 150000,
      'unit': '/jam',
      'avatarEmoji': '👩‍🏫',
      'avatarBg': const Color(0xFFD4A017),
      'hasFullBtn': false,
    },
    {
      'name': 'Ananda Rizky',
      'title': 'Penari Tradisional & Koreografer',
      'category': 'Seni',
      'rating': '5.0',
      'isUtama': false,
      'description':
          'Tersedia untuk pengisi acara formal, workshop tari, maupun les privat tari kreasi nusantara.',
      'tags': ['Tari Jawa', 'Koreografi', 'Privat'],
      'price': 1200000,
      'unit': '/event',
      'avatarEmoji': '💃',
      'avatarBg': const Color(0xFF0284C7),
      'hasFullBtn': false,
    },
    {
      'name': 'Dr. Hendra Wijaya',
      'title': 'Konsultan Strategi Bisnis',
      'category': 'Bisnis',
      'rating': '4.7 (88)',
      'isUtama': false,
      'description':
          'Membantu digitalisasi UMKM dan pengembangan strategi ekspansi pasar. Ahli dalam analisa pasar dan efisiensi operasional.',
      'stats': {'sesi': '2.4k+', 'kepuasan': '98%'},
      'tags': ['Digitalisasi', 'Scale-up', 'Pemasaran'],
      'price': 800000,
      'unit': '/sesi',
      'avatarEmoji': '👨‍💼',
      'avatarBg': const Color(0xFF0F172A),
      'hasFullBtn': true,
    },
    {
      'name': 'Advokat Richard Tambunan, S.H.',
      'title': 'Konsultan Hukum Bisnis & Kontrak',
      'category': 'Hukum',
      'rating': '4.9 (95)',
      'isUtama': true,
      'description':
          'Pendampingan pendirian PT/CV, pembuatan MoU bisnis, serta perlindungan HAKI dan hak cipta merek usaha.',
      'tags': ['Kontrak', 'Pendirian PT', 'HAKI'],
      'price': 600000,
      'unit': '/sesi',
      'avatarEmoji': '⚖️',
      'avatarBg': const Color(0xFF7C3AED),
      'hasFullBtn': true,
    },
  ];

  String _formatPrice(int amount) {
    if (amount >= 1000000) {
      final double inJt = amount / 1000000;
      return '${inJt.toStringAsFixed(1).replaceAll('.0', '')}jt';
    }
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _bookAppointment(Map<String, dynamic> expert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final int price = expert['price'] as int;
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
                    'Book Appointment 🗓️',
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

              // Expert Info Card
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
                        color: expert['avatarBg'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: Center(
                        child: Text(expert['avatarEmoji'] as String, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(expert['name'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black)),
                          Text(expert['title'] as String, style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Session Date Selector
              const Text('Pilih Tanggal & Sesi Konsultasi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dateChip('Hari Ini, 14:00', true),
                  const SizedBox(width: 8),
                  _dateChip('Besok, 10:00', false),
                  const SizedBox(width: 8),
                  _dateChip('Lusa, 16:00', false),
                ],
              ),
              const SizedBox(height: 16),

              // Cost Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Investasi Konsultasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.black)),
                  Text('Rp ${_formatPrice(price)}${expert['unit']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: NeoColors.black)),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Jadwal Konsultasi dengan ${expert['name']} Berhasil Dibuat! 🚀'),
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
                  child: const Center(
                    child: Text(
                      'Konfirmasi Booking Sesi 📅',
                      style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
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

  Widget _dateChip(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? NeoColors.brand : NeoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NeoColors.black, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? NeoColors.white : NeoColors.black,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allExperts.where((exp) {
      if (_selectedCategoryIndex == 0) return true;
      return exp['category'] == _categories[_selectedCategoryIndex];
    }).toList();

    final displayed = _showAllMitra ? filtered : filtered.take(4).toList();

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
              // 1. TOP HEADER BAR (EXACT REFERENCE DESIGN)
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
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
              // 2. TITLE & SUBTITLE (EXACT REFERENCE MATCH)
              // ============================================================
              const Text(
                'Temukan Mitra Ahli',
                style: TextStyle(
                  color: NeoColors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Konsultasi profesional dengan konsultan pajak, edukator, dan talenta terbaik di bidangnya.',
                style: TextStyle(
                  color: NeoColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

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
                      onTap: () => setState(() => _selectedCategoryIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
              // 4. EXPERT CARDS LIST (EXACT REFERENCE MATCH DESIGN)
              // ============================================================
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayed.length,
                itemBuilder: (context, index) {
                  final expert = displayed[index];
                  final bool isUtama = expert['isUtama'] as bool;
                  final bool hasFullBtn = expert['hasFullBtn'] as bool;
                  final List<String>? tags = expert['tags'] as List<String>?;
                  final Map<String, String>? stats = expert['stats'] as Map<String, String>?;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(16),
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
                        // Image / Avatar Container with Badge
                        Stack(
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: expert['avatarBg'] as Color,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                              ),
                              child: Center(
                                child: Text(
                                  expert['avatarEmoji'] as String,
                                  style: const TextStyle(fontSize: 80),
                                ),
                              ),
                            ),

                            // MITRA UTAMA Badge
                            if (isUtama)
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00B4D8),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: NeoColors.black, width: 1.2),
                                  ),
                                  child: const Text(
                                    'MITRA UTAMA',
                                    style: TextStyle(
                                      color: NeoColors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 10,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ),

                            // Rating Badge
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: NeoColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                ),
                                child: Row(
                                  children: [
                                    const Text('⭐ ', style: TextStyle(fontSize: 11)),
                                    Text(
                                      expert['rating'] as String,
                                      style: const TextStyle(
                                        color: NeoColors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Name & Title
                        Text(
                          expert['name'] as String,
                          style: const TextStyle(
                            color: NeoColors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          expert['title'] as String,
                          style: const TextStyle(
                            color: Color(0xFF00B4D8),
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          expert['description'] as String,
                          style: const TextStyle(
                            color: NeoColors.textMuted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Skill Tags Chips
                        if (tags != null)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: tags.map((t) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: NeoColors.bg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                ),
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    color: NeoColors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                        // Stats if available
                        if (stats != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: NeoColors.bg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: NeoColors.black, width: 1),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Sesi Selesai', style: TextStyle(fontSize: 9.5, color: NeoColors.textMuted, fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 2),
                                      Text(stats['sesi']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: NeoColors.bg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: NeoColors.black, width: 1),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Kepuasan', style: TextStyle(fontSize: 9.5, color: NeoColors.textMuted, fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 2),
                                      Text(stats['kepuasan']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 14),

                        // Price & Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mulai dari',
                                  style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Rp ${_formatPrice(expert['price'] as int)}${expert['unit']}',
                                  style: const TextStyle(
                                    color: NeoColors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            // Button Action
                            if (hasFullBtn)
                              GestureDetector(
                                onTap: () => _bookAppointment(expert),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00B4D8),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: NeoColors.black, width: 1.8),
                                    boxShadow: const [
                                      BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Book\nAppointment',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: NeoColors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11.5,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () => _bookAppointment(expert),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: NeoColors.black, width: 1.8),
                                    boxShadow: const [
                                      BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                                    ],
                                  ),
                                  child: const Icon(Icons.calendar_today_rounded, color: NeoColors.white, size: 20),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ============================================================
              // 5. BOTTOM LOAD MORE BUTTON (EXACT REFERENCE MATCH DESIGN)
              // ============================================================
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _showAllMitra = !_showAllMitra),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: NeoColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _showAllMitra ? 'Sembunyikan Mitra ∧' : 'Lihat Mitra Lainnya ∨',
                          style: const TextStyle(
                            color: NeoColors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
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
