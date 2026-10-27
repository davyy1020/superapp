import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class TicketsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const TicketsScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _userBalance = 250000;

  final List<String> _categories = [
    'All Categories',
    'Seminars',
    'Workshops',
    'Executive Tours',
    'Exhibitions',
  ];

  final List<Map<String, dynamic>> _events = [
    {
      'title': 'National Digital Economy Summit 2024',
      'category': 'Seminars',
      'badge': 'SEMINAR',
      'date': '24 Oct 2024',
      'location': 'Jakarta Convention Center',
      'price': 1500000,
      'emoji': '🏙️',
      'bgGradient': [const Color(0xFF0F172A), const Color(0xFF0040B8)],
      'badgeColor': const Color(0xFF0040B8),
    },
    {
      'title': 'Raja Ampat Executive Retreat',
      'category': 'Executive Tours',
      'badge': 'PREMIUM TOUR',
      'date': 'Flexible Dates',
      'location': 'West Papua, Indonesia',
      'price': 12450000,
      'emoji': '🏝️',
      'bgGradient': [const Color(0xFFD4A017), const Color(0xFF0284C7)],
      'badgeColor': const Color(0xFFD4A017),
    },
    {
      'title': 'ASEAN Public Policy Workshop',
      'category': 'Workshops',
      'badge': 'WORKSHOP',
      'date': '12 Nov 2024',
      'location': 'The Ritz-Carlton, Mega Kuningan',
      'price': 2750000,
      'emoji': '📊',
      'bgGradient': [const Color(0xFF0284C7), const Color(0xFF0F172A)],
      'badgeColor': const Color(0xFF0284C7),
    },
    {
      'title': 'Ubud Spiritual & Wellness Journey',
      'category': 'Executive Tours',
      'badge': 'PREMIUM TOUR',
      'date': '15-18 Dec 2024',
      'location': 'Ubud, Bali',
      'price': 8900000,
      'emoji': '🌿',
      'bgGradient': [const Color(0xFF10B981), const Color(0xFF0040B8)],
      'badgeColor': const Color(0xFFD4A017),
    },
    {
      'title': 'Future of Fintech Leadership',
      'category': 'Seminars',
      'badge': 'SEMINAR',
      'date': '08 Jan 2025',
      'location': 'Grand Hyatt, Jakarta',
      'price': 3200000,
      'emoji': '💳',
      'bgGradient': [const Color(0xFF7C3AED), const Color(0xFF0F172A)],
      'badgeColor': const Color(0xFF0040B8),
    },
    {
      'title': 'Green Energy Infrastructure Plan',
      'category': 'Workshops',
      'badge': 'WORKSHOP',
      'date': '20 Jan 2025',
      'location': 'ITB Innovation Hub, Bandung',
      'price': 1850000,
      'emoji': '⚡',
      'bgGradient': [const Color(0xFF00B4D8), const Color(0xFF0040B8)],
      'badgeColor': const Color(0xFF0284C7),
    },
  ];

  late List<Map<String, dynamic>> _filteredEvents;

  @override
  void initState() {
    super.initState();
    _filteredEvents = List.from(_events);
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
      _filteredEvents = _events.where((item) {
        final matchesQuery = item['title'].toString().toLowerCase().contains(query) ||
            item['location'].toString().toLowerCase().contains(query);
        final matchesCategory = _selectedCategoryIndex == 0 ||
            item['category'] == _categories[_selectedCategoryIndex];
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _openBookingSheet(Map<String, dynamic> item) {
    int ticketQty = 1;
    int selectedTierIndex = 0;
    final List<String> tiers = ['Reguler', 'Executive', 'VIP Pass'];
    final List<int> tierMultipliers = [1, 2, 3];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final int basePrice = item['price'] as int;
            final int totalPrice = basePrice * tierMultipliers[selectedTierIndex] * ticketQty;

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
                        'Pesan Tiket & MICE 🎟️',
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

                  // Event Summary Card
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
                            gradient: LinearGradient(
                              colors: item['bgGradient'] as List<Color>,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: NeoColors.black, width: 1.5),
                          ),
                          child: Center(
                            child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 26)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: NeoColors.black)),
                              const SizedBox(height: 2),
                              Text('📍 ${item['location']}', style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tier Selection
                  const Text('Pilih Kategori Tiket:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(tiers.length, (idx) {
                      final bool isSel = selectedTierIndex == idx;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedTierIndex = idx),
                          child: Container(
                            margin: EdgeInsets.only(right: idx < tiers.length - 1 ? 8 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF00B4D8) : NeoColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                tiers[idx],
                                style: TextStyle(
                                  color: isSel ? NeoColors.white : NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Ticket Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jumlah Tiket', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (ticketQty > 1) setModalState(() => ticketQty--);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: NeoColors.brandSoft,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: NeoColors.black, width: 1.2),
                              ),
                              child: const Icon(Icons.remove, size: 16, color: NeoColors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '$ticketQty',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NeoColors.black),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setModalState(() => ticketQty++),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B4D8),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: NeoColors.black, width: 1.2),
                              ),
                              child: const Icon(Icons.add, size: 16, color: NeoColors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Total & Balance Check
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.black)),
                      Text('Rp ${_formatPrice(totalPrice)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: NeoColors.black)),
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

                  // Action Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showETicketDialog(item, totalPrice);
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
                          'Bayar & Dapatkan E-Tiket 🎫',
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
      },
    );
  }

  void _showETicketDialog(Map<String, dynamic> item, int amount) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: NeoColors.black, width: 2.2),
          ),
          backgroundColor: NeoColors.surface,
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24),
              SizedBox(width: 8),
              Text('E-Tiket Terbit 🎉', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['title'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black),
              ),
              const SizedBox(height: 4),
              Text(
                '📍 ${item['location']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),

              // Simulated Barcode Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.brandSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: Column(
                  children: const [
                    Text(
                      '||||| | |||| ||||| || ||||',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: NeoColors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 4.0,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'QR VALIDATION: BSP-TKT-2026',
                      style: TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: NeoColors.brand,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NeoColors.black, width: 1.5),
                ),
                child: const Text('Simpan E-Tiket', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12)),
              ),
            ),
          ],
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
              // 2. HERO BANNER (DISCOVER MICE & DESTINATIONS)
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
                    const Text(
                      'Discover\nMICE &\nDestinations',
                      style: TextStyle(
                        color: NeoColors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Exclusive access to premium seminars, workshops, and executive tours tailored for national progress.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Book Now Primary Button
                        GestureDetector(
                          onTap: () {
                            if (_filteredEvents.isNotEmpty) {
                              _openBookingSheet(_filteredEvents.first);
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
                            child: const Text(
                              'Book Now',
                              style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Learn More Secondary Button
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('BISPIRA MICE & Destinations Portal Layanan Resmi 🌟'),
                                backgroundColor: NeoColors.brand,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.white, width: 1.5),
                            ),
                            child: const Text(
                              'Learn More',
                              style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 3. SEARCH BAR (EXACT MATCH REFERENCE DESIGN)
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
                          hintText: 'Search seminars, workshops, or tours...',
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
              // 4. CATEGORY CHIPS (EXACT MATCH REFERENCE DESIGN)
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
                      onTap: () {
                        setState(() => _selectedCategoryIndex = index);
                        _onSearchChanged();
                      },
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
              // 5. EVENT & TOUR CARDS (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredEvents.length,
                itemBuilder: (context, index) {
                  final item = _filteredEvents[index];

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
                              height: 170,
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

                            // Event Category Badge
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
                              // Date
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded, size: 14, color: NeoColors.brand),
                                  const SizedBox(width: 6),
                                  Text(
                                    item['date'] as String,
                                    style: const TextStyle(
                                      color: NeoColors.brand,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Title
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  color: NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Location
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: NeoColors.textMuted),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item['location'] as String,
                                      style: const TextStyle(
                                        color: NeoColors.textMuted,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
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
                                      const Text(
                                        'Starting from',
                                        style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rp ${_formatPrice(item['price'] as int)}',
                                        style: const TextStyle(
                                          color: NeoColors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Cyan Arrow Button
                                  GestureDetector(
                                    onTap: () => _openBookingSheet(item),
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00B4D8),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: NeoColors.black, width: 1.8),
                                        boxShadow: const [
                                          BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.arrow_forward_rounded, color: NeoColors.white, size: 20),
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
