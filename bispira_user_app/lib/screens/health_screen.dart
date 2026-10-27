import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class HealthScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const HealthScreen({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _userBalance = 250000;

  final List<String> _categories = [
    'Semua',
    'Dokter Umum',
    'Spesialis Anak',
    'Spesialis Kandungan (Obgyn)',
    'Spesialis Kulit',
    'Psikiater',
  ];

  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Adrian Wijaya',
      'specialist': 'Spesialis Anak (Pediatri)',
      'category': 'Spesialis Anak',
      'experience': '12 Tahun',
      'rating': '98%',
      'price': 50000,
      'status': 'Online',
      'isOnline': true,
      'avatarColor': const Color(0xFF0040B8),
      'avatarEmoji': '👨‍⚕️',
    },
    {
      'name': 'Dr. Sarah Anindita',
      'specialist': 'Spesialis Kandungan (Obgyn)',
      'category': 'Spesialis Kandungan (Obgyn)',
      'experience': '8 Tahun',
      'rating': '95%',
      'price': 75000,
      'status': 'Online',
      'isOnline': true,
      'avatarColor': const Color(0xFFD4A017),
      'avatarEmoji': '👩‍⚕️',
    },
    {
      'name': 'Dr. Budi Santoso',
      'specialist': 'Dokter Umum',
      'category': 'Dokter Umum',
      'experience': '20 Tahun',
      'rating': '99%',
      'price': 35000,
      'status': 'Sibuk',
      'isOnline': false,
      'avatarColor': const Color(0xFF1E293B),
      'avatarEmoji': '👨‍⚕️',
    },
    {
      'name': 'Dr. Clarissa Putri',
      'specialist': 'Spesialis Kulit (Dermatologi)',
      'category': 'Spesialis Kulit',
      'experience': '10 Tahun',
      'rating': '97%',
      'price': 80000,
      'status': 'Online',
      'isOnline': true,
      'avatarColor': const Color(0xFF0284C7),
      'avatarEmoji': '👩‍⚕️',
    },
    {
      'name': 'Dr. Hendra Kusuma',
      'specialist': 'Psikiater & Kesehatan Jiwa',
      'category': 'Psikiater',
      'experience': '15 Tahun',
      'rating': '99%',
      'price': 90000,
      'status': 'Online',
      'isOnline': true,
      'avatarColor': const Color(0xFF7C3AED),
      'avatarEmoji': '👨‍⚕️',
    },
  ];

  late List<Map<String, dynamic>> _filteredDoctors;

  @override
  void initState() {
    super.initState();
    _filteredDoctors = List.from(_doctors);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _doctors.where((doc) {
        final matchesQuery = doc['name'].toString().toLowerCase().contains(query) ||
            doc['specialist'].toString().toLowerCase().contains(query);
        final matchesCategory = _selectedCategoryIndex == 0 ||
            doc['category'] == _categories[_selectedCategoryIndex];
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _onSearchChanged();
    });
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _startConsultation(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final int price = doctor['price'] as int;
        return Container(
          padding: const EdgeInsets.all(20),
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
                  const Text('Konfirmasi Konsultasi 🏥', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
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

              // Doctor Info Card
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: doctor['avatarColor'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: Center(
                        child: Text(doctor['avatarEmoji'] as String, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor['name'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black)),
                          Text(doctor['specialist'] as String, style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Biaya Konsultasi Dokter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.black)),
                  Text('Rp ${_formatPrice(price)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: NeoColors.black)),
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
              const SizedBox(height: 18),

              // Start Chat Action Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  _openChatRoom(doctor);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                      'Bayar & Mulai Chat Konsultasi 💬',
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

  void _openChatRoom(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: NeoColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
          ),
          child: Column(
            children: [
              // Chat Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: NeoColors.brand,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.arrow_back_rounded, color: NeoColors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: doctor['avatarColor'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(color: NeoColors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(doctor['avatarEmoji'] as String, style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor['name'] as String, style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5)),
                          const Text('🟢 Konsultasi Aktif', style: TextStyle(color: NeoColors.gold, fontSize: 10.5, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Chat Messages List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: NeoColors.goldSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: NeoColors.gold, width: 1.2),
                        ),
                        child: const Text(
                          'Sesi konsultasi resmi dimulai • Bebas rahasia medis 🔒',
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: NeoColors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Doctor Message
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(right: 40, bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: NeoColors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border.all(color: NeoColors.black, width: 1.5),
                        ),
                        child: Text(
                          'Halo Davy! Saya ${doctor['name']}. Ada keluhan kesehatan apa yang bisa saya bantu hari ini? 🩺',
                          style: const TextStyle(fontSize: 12, color: NeoColors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),

                    // User Message
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(left: 40, bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: NeoColors.brandSoft,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          border: Border.all(color: NeoColors.brand, width: 1.5),
                        ),
                        child: const Text(
                          'Halo Dok, anak saya demam sejak semalam dan batuk ringan. Apa rekomendasi penanganan pertamanya?',
                          style: TextStyle(fontSize: 12, color: NeoColors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Chat Input Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  border: const Border(top: BorderSide(color: NeoColors.black, width: 1.8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: NeoColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: NeoColors.black, width: 1.5),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Tulis pesan kesehatan...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: NeoColors.brand,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: NeoColors.white, size: 18),
                    ),
                  ],
                ),
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
              // 1. TOP HEADER BAR (EXACT REFERENCE DESIGN)
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Location Indicator
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
                        'Semarang, ID',
                        style: TextStyle(
                          color: NeoColors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  // BISPIRA BRAND TITLE
                  const Text(
                    'BISPIRA',
                    style: TextStyle(
                      color: NeoColors.brand,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 1.2,
                    ),
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
                      'Rp ${_formatPrice(_userBalance)}',
                      style: const TextStyle(
                        color: NeoColors.brand,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ============================================================
              // 2. HERO BANNER (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF0040B8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Solusi Sehat Tanpa Antre.',
                      style: TextStyle(
                        color: NeoColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Konsultasi dengan dokter spesialis pilihan langsung dari genggaman Anda.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ============================================================
              // 3. SEARCH BAR (EXACT REFERENCE DESIGN)
              // ============================================================
              Container(
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Icon(Icons.search_rounded, color: NeoColors.brand, size: 22),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                          hintText: 'Cari nama dokter atau spesialis...',
                          hintStyle: TextStyle(color: NeoColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ============================================================
              // 4. CATEGORY HORIZONTAL CHIPS (EXACT MATCH REFERENCE DESIGN)
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
                      onTap: () => _onCategorySelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? NeoColors.brand : NeoColors.white,
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
              const SizedBox(height: 18),

              // ============================================================
              // 5. DOCTORS CARD LIST (EXACT REFERENCE MATCH DESIGN)
              // ============================================================
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doc = _filteredDoctors[index];
                  final bool isOnline = doc['isOnline'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NeoColors.black, width: 2.2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Header Info
                        Row(
                          children: [
                            // Doctor Avatar
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                color: doc['avatarColor'] as Color,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                              ),
                              child: Center(
                                child: Text(doc['avatarEmoji'] as String, style: const TextStyle(fontSize: 32)),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Doctor Name & Status
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Online Status Dot
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: isOnline ? const Color(0xFF10B981) : Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        doc['status'] as String,
                                        style: TextStyle(
                                          color: isOnline ? const Color(0xFF10B981) : Colors.grey,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc['name'] as String,
                                    style: const TextStyle(
                                      color: NeoColors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    doc['specialist'] as String,
                                    style: const TextStyle(
                                      color: NeoColors.textMuted,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Stats Pills (Pengalaman & Kepuasan)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: NeoColors.bg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: NeoColors.black, width: 1),
                                ),
                                child: Column(
                                  children: [
                                    const Text('PENGALAMAN', style: TextStyle(fontSize: 9.5, color: NeoColors.textMuted, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 2),
                                    Text(doc['experience'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: NeoColors.bg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: NeoColors.black, width: 1),
                                ),
                                child: Column(
                                  children: [
                                    const Text('KEPUASAN', style: TextStyle(fontSize: 9.5, color: NeoColors.textMuted, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('⭐ ', style: TextStyle(fontSize: 10)),
                                        Text(doc['rating'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Price & Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Biaya Konsultasi', style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(
                                  'Rp ${_formatPrice(doc['price'] as int)}',
                                  style: const TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                              ],
                            ),

                            // Action Button
                            GestureDetector(
                              onTap: () {
                                if (isOnline) {
                                  _startConsultation(doc);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${doc['name']} sedang sibuk. Silakan buat janji jadwal!'),
                                      backgroundColor: NeoColors.black,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isOnline ? const Color(0xFF00B4D8) : const Color(0xFFCBD5E1),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: NeoColors.black, width: 1.8),
                                  boxShadow: isOnline
                                      ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isOnline ? Icons.chat_rounded : Icons.calendar_today_rounded,
                                      color: isOnline ? NeoColors.white : NeoColors.black,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isOnline ? 'Chat Sekarang' : 'Buat Janji',
                                      style: TextStyle(
                                        color: isOnline ? NeoColors.white : NeoColors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
              const SizedBox(height: 10),

              // ============================================================
              // 6. PROMO SEHAT BANNER (EXACT REFERENCE MATCH DESIGN)
              // ============================================================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: NeoColors.gold,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: NeoColors.black, width: 1.2),
                      ),
                      child: const Text(
                        'PROMO SEHAT',
                        style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Diskon 50% Untuk Pengguna Baru',
                                style: TextStyle(
                                  color: NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Dapatkan potongan harga untuk konsultasi pertama dengan kode:\nBISPIRASEHAT',
                                style: TextStyle(
                                  color: NeoColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('🛡️', style: TextStyle(fontSize: 48)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Button
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voucher BISPIRASEHAT Berhasil Dipasang! 🎉'),
                            backgroundColor: NeoColors.brand,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: NeoColors.brand,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.black, width: 1.8),
                          boxShadow: const [
                            BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Gunakan Sekarang',
                            style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13),
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
}
