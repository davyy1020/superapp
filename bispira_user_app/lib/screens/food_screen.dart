import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class FoodScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const FoodScreen({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addressSearchController = TextEditingController();
  final TextEditingController _addressNoteController = TextEditingController();
  late PageController _bannerPageController;
  late Timer _bannerTimer;

  int _selectedCategoryIndex = 0;
  int _bannerIndex = 0;
  String _deliveryAddress = 'Rumahku, SCBD Sudirman, Jakarta Selatan';
  LatLng _mapCenter = const LatLng(-6.2088, 106.8456); // SCBD Jakarta
  int _userBalance = 250000;
  bool _isGpsDetected = true;

  // HERO PROMO & SPONSOR CAROUSEL BANNERS (SHOPEEFOOD TOP PROMO STYLE)
  final List<Map<String, dynamic>> _heroBanners = [
    {
      'tag': '⚡ SUPER PROMO 50%',
      'title': 'Diskon Makanan s.d 50% BISPIRA Food 🍔',
      'sub': 'Min. Transaksi Rp 40rb • Voucher: BISPIRA50',
      'bg': NeoColors.brand,
      'textColor': NeoColors.white,
      'badgeBg': NeoColors.gold,
      'badgeText': NeoColors.black,
      'emoji': '🔥',
    },
    {
      'tag': '🛵 FREESHIP SE-INDONESIA',
      'title': 'Voucher Ongkir Rp 0 Sepuasnya 🛵',
      'sub': 'Tanpa Min. Transaksi • Antar Super Cepat 15 Menit',
      'bg': NeoColors.gold,
      'textColor': NeoColors.black,
      'badgeBg': NeoColors.brand,
      'badgeText': NeoColors.white,
      'emoji': '📦',
    },
    {
      'tag': '👑 SPONSOR BISPIRA PAY',
      'title': 'Cashback 100% Pakai BISPIRA Pay 💳',
      'sub': 'Dapatkan Poin Hadiah & Bebas Biaya Layanan',
      'bg': const Color(0xFF0F172A),
      'textColor': NeoColors.white,
      'badgeBg': NeoColors.gold,
      'badgeText': NeoColors.black,
      'emoji': '💎',
    },
  ];

  // CLEAN STREET NAMES FOR MAP PICKER (NO RAW LAT/LNG!)
  final List<String> _cleanStreetNames = [
    'Sudirman Central Business District (SCBD), Jakarta Selatan',
    'Jl. Senopati Raya No. 45, Kebayoran Baru, Jakarta Selatan',
    'Jl. Jend. Sudirman Kav. 52, Area Pacific Place, Jakarta',
    'Jl. Jendral Gatot Subroto, Semanggi, Jakarta Selatan',
    'Kawasan Kebayoran Baru, Jakarta Selatan',
  ];

  // SAVED ADDRESSES
  final List<Map<String, String>> _savedAddresses = [
    {
      'label': 'Rumahku',
      'address': 'Jl. Sudirman Central District No. 12, Kebayoran Baru, Jakarta Selatan',
      'emoji': '🏠',
      'lat': '-6.2088',
      'lng': '106.8456',
    },
    {
      'label': 'Kantor SCBD',
      'address': 'Pacific Century Place Lt. 14, SCBD Lot 10, Jakarta Selatan',
      'emoji': '🏢',
      'lat': '-6.2250',
      'lng': '106.8080',
    },
    {
      'label': 'Apartemen Senopati',
      'address': 'Unit 18A, Senopati Suites, Kebayoran Baru, Jakarta Selatan',
      'emoji': '🏙️',
      'lat': '-6.2330',
      'lng': '106.8095',
    },
  ];

  // CART STATE
  final Map<String, Map<String, dynamic>> _cartItems = {
    'Wagyu Cheese Burger Special': {
      'name': 'Wagyu Cheese Burger Special',
      'price': 85000,
      'qty': 1,
      'emoji': '🍔',
    },
    'Iced Uji Matcha Latte': {
      'name': 'Iced Uji Matcha Latte',
      'price': 45000,
      'qty': 1,
      'emoji': '🍵',
    },
  };

  // CATEGORIES
  final List<Map<String, String>> _categories = [
    {'name': 'Semua', 'emoji': '🍱'},
    {'name': 'Resto', 'emoji': '🍗'},
    {'name': 'Toko Sembako', 'emoji': '🛒'},
    {'name': 'Kopi & Boba', 'emoji': '☕'},
    {'name': 'Fast Food', 'emoji': '🍔'},
  ];

  // 1. SERING DIREKOMENDASIKAN
  final List<Map<String, dynamic>> _seringDirekomendasikan = [
    {
      'name': 'McDonald\'s - Lippo SCBD',
      'tag': 'Diskon 30%',
      'rating': 4.9,
      'distance': '1.2 km',
      'time': '15 min',
      'emoji': '🍔',
      'bgColor': const Color(0xFFFFE5E5),
    },
    {
      'name': 'Prima Freshmart - Kebayoran',
      'tag': 'Gratis Ongkir',
      'rating': 4.8,
      'distance': '0.8 km',
      'time': '10 min',
      'emoji': '🍗',
      'bgColor': const Color(0xFFFFF3D6),
    },
    {
      'name': 'Holland Bakery - Sudirman',
      'tag': 'Diskon 20%',
      'rating': 4.9,
      'distance': '1.5 km',
      'time': '18 min',
      'emoji': '🎂',
      'bgColor': const Color(0xFFE6F0FF),
    },
  ];

  // 2. PERLU KAMU COBA
  final List<Map<String, dynamic>> _perluKamuCoba = [
    {
      'name': 'Gudeg Jogja Bu Kromo',
      'sub': 'Nasi gudeg komplit krecek & telur suwir',
      'price': 35000,
      'originalPrice': 45000,
      'tag': 'Jawara Rasa',
      'rating': 4.9,
      'emoji': '🍲',
    },
    {
      'name': 'Warung Nasi Uduk Mamah',
      'sub': 'Nasi uduk empal & sambal terasi pedas',
      'price': 28000,
      'originalPrice': 35000,
      'tag': 'Laris Manis',
      'rating': 4.8,
      'emoji': '🍛',
    },
    {
      'name': 'Bakmi Ayam Kampung Special',
      'sub': 'Bakmi kenyal topping ayam kampung asli',
      'price': 42000,
      'originalPrice': 50000,
      'tag': 'Top Rated',
      'rating': 4.9,
      'emoji': '🍜',
    },
    {
      'name': 'Wagyu Cheese Burger Special',
      'sub': 'Daging Wagyu premium saus keju melt',
      'price': 85000,
      'originalPrice': 105000,
      'tag': 'Best Seller',
      'rating': 5.0,
      'emoji': '🍔',
    },
  ];

  // 3. JAWARA LOKAL
  final List<Map<String, dynamic>> _jawaraLokal = [
    {
      'name': 'Sate Ayam Madura Pak Haji',
      'sub': '10 tusuk sate ayam empuk bumbu kacang',
      'price': 32000,
      'rating': 4.9,
      'distance': '0.9 km',
      'emoji': '🍢',
    },
    {
      'name': 'Martabak Red Velvet Cheese',
      'sub': 'Martabak manis adonan red velvet oreo',
      'price': 65000,
      'rating': 4.8,
      'distance': '1.4 km',
      'emoji': '🥞',
    },
    {
      'name': 'Es Teler Sultan SCBD',
      'sub': 'Es teler alpukat durian kelapa muda',
      'price': 25000,
      'rating': 4.9,
      'distance': '1.1 km',
      'emoji': '🍧',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted && _bannerPageController.hasClients) {
        final nextPage = (_bannerIndex + 1) % _heroBanners.length;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerPageController.dispose();
    _searchController.dispose();
    _addressSearchController.dispose();
    _addressNoteController.dispose();
    super.dispose();
  }

  void _addToCart(Map<String, dynamic> item) {
    final String key = item['name'] as String;
    setState(() {
      if (_cartItems.containsKey(key)) {
        _cartItems[key]!['qty'] = (_cartItems[key]!['qty'] as int) + 1;
      } else {
        _cartItems[key] = {
          'name': item['name'],
          'price': item['price'],
          'qty': 1,
          'emoji': item['emoji'],
        };
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: NeoColors.black,
        duration: const Duration(seconds: 1),
        content: Row(
          children: [
            Text('${item['emoji']} ', style: const TextStyle(fontSize: 16)),
            Expanded(
              child: Text(
                '${item['name']} ditambahkan ke Keranjang!',
                style: const TextStyle(color: NeoColors.gold, fontWeight: FontWeight.w900, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeFromCart(String key) {
    setState(() {
      if (_cartItems.containsKey(key)) {
        if ((_cartItems[key]!['qty'] as int) > 1) {
          _cartItems[key]!['qty'] = (_cartItems[key]!['qty'] as int) - 1;
        } else {
          _cartItems.remove(key);
        }
      }
    });
  }

  int _calculateCartTotal() {
    int sum = 0;
    _cartItems.forEach((_, val) {
      sum += (val['price'] as int) * (val['qty'] as int);
    });
    return sum;
  }

  int _calculateCartCount() {
    int count = 0;
    _cartItems.forEach((_, val) {
      count += (val['qty'] as int);
    });
    return count;
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  // ============================================================
  // SHOPEEFOOD MAP PICKER (AUTO GPS LOCATION + NO RAW LAT/LNG!)
  // ============================================================
  void _openInteractiveMapPicker() {
    final MapController mapController = MapController();
    LatLng tempPoint = _mapCenter;
    String currentDynamicAddress = 'Sudirman Central Business District (SCBD), Jakarta Selatan';
    int addressIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setMapState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Map Modal Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: NeoColors.brand,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                      border: Border(bottom: BorderSide(color: NeoColors.black, width: 2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text('📍 ', style: TextStyle(fontSize: 18)),
                            Text(
                              'Pilih Titik Lokasi Peta HP (ShopeeFood)',
                              style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: NeoColors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.close_rounded, color: NeoColors.black, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Real Interactive FlutterMap
                  Expanded(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: _mapCenter,
                            initialZoom: 16.5,
                            onPositionChanged: (pos, hasGesture) {
                              if (hasGesture && pos.center != null) {
                                tempPoint = pos.center!;
                                addressIndex = (tempPoint.latitude.abs() * 100).toInt() % _cleanStreetNames.length;
                                setMapState(() {
                                  currentDynamicAddress = _cleanStreetNames[addressIndex];
                                });
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.bispira.userapp',
                            ),
                          ],
                        ),

                        // CENTER PIN MARKER
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: NeoColors.black,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: NeoColors.gold, width: 1.5),
                                  ),
                                  child: const Text(
                                    'Geser peta untuk paskan pin 📍',
                                    style: TextStyle(color: NeoColors.gold, fontSize: 10.5, fontWeight: FontWeight.w900),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Icon(Icons.location_on, size: 48, color: Colors.redAccent),
                              ],
                            ),
                          ),
                        ),

                        // GPS DETECTED AUTO BADGE & BUTTON
                        Positioned(
                          top: 14,
                          right: 14,
                          child: GestureDetector(
                            onTap: () {
                              final LatLng myGps = const LatLng(-6.2088, 106.8456);
                              mapController.move(myGps, 17.0);
                              setMapState(() {
                                tempPoint = myGps;
                                currentDynamicAddress = 'Lokasi HP Saya Saat Ini (SCBD, Jakarta Selatan)';
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 1),
                                  backgroundColor: NeoColors.brand,
                                  content: Text('📡 GPS HP Terdeteksi Otomatis!'),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: NeoColors.gold,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                                boxShadow: const [
                                  BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.my_location_rounded, color: NeoColors.black, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Deteksi GPS HP 📡',
                                    style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Address Details Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      border: const Border(top: BorderSide(color: NeoColors.black, width: 2)),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(0, -3), blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentDynamicAddress,
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '📡 Terdeteksi Otomatis via Peta GPS HP',
                                    style: TextStyle(color: NeoColors.brand, fontSize: 10.5, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Additional Notes Field
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: NeoColors.bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: NeoColors.black, width: 1.5),
                          ),
                          child: TextField(
                            controller: _addressNoteController,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            decoration: const InputDecoration(
                              hintText: 'Patokan / Catatan (cth: Pagar Hitam, Pos Satpam)',
                              hintStyle: TextStyle(color: NeoColors.textMuted, fontSize: 11.5),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Confirm Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mapCenter = tempPoint;
                              _isGpsDetected = true;
                              final note = _addressNoteController.text.trim();
                              _deliveryAddress = note.isNotEmpty
                                  ? '$currentDynamicAddress ($note)'
                                  : currentDynamicAddress;
                            });
                            Navigator.pop(ctx);
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: NeoColors.brand,
                                content: Text(
                                  '📍 Alamat Diperbarui: $_deliveryAddress',
                                  style: const TextStyle(fontWeight: FontWeight.w900, color: NeoColors.white),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: NeoColors.brand,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 2),
                              boxShadow: const [
                                BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Konfirmasi Alamat Ini 📍',
                                style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // LOCATION PICKER SHEET
  void _openLocationPickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: NeoColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: NeoColors.black, width: 2.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: NeoColors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('📍 Pilih Alamat Pengantaran', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close_rounded, color: NeoColors.black, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search Bar Input for Location
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: NeoColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: TextField(
                  controller: _addressSearchController,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                  decoration: const InputDecoration(
                    hintText: 'Cari jalan, gedung, atau perumahan...',
                    hintStyle: TextStyle(color: NeoColors.textMuted, fontSize: 12),
                    prefixIcon: Icon(Icons.search_rounded, color: NeoColors.brand, size: 20),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 1. AUTO GPS HP DETECTION BUTTON
              GestureDetector(
                onTap: () {
                  setState(() {
                    _deliveryAddress = 'Lokasi HP Saya Saat Ini (SCBD, Jakarta Selatan)';
                    _mapCenter = const LatLng(-6.2088, 106.8456);
                    _isGpsDetected = true;
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: NeoColors.brand,
                      content: Text('📡 Alamat Otomatis Terdeteksi via GPS HP!'),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: NeoColors.gold,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoColors.black, width: 1.8),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.my_location_rounded, color: NeoColors.black, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gunakan Lokasi HP Saya Saat Ini 📡',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                            ),
                            Text(
                              'Deteksi otomatis via titik GPS HP bawaan',
                              style: TextStyle(fontSize: 10.5, color: NeoColors.black, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: NeoColors.black, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 2. PICK VIA MAP BUTTON
              GestureDetector(
                onTap: _openInteractiveMapPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: NeoColors.brandSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoColors.brand, width: 1.8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.map_rounded, color: NeoColors.brand, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih Titik Lewat Peta (Interactive Map)',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.brand),
                            ),
                            Text(
                              'Geser pin di peta untuk paskan alamat',
                              style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: NeoColors.brand, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              const Text('ALAMAT TERSIMPAN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.8, color: NeoColors.textMuted)),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _savedAddresses.length,
                  itemBuilder: (context, index) {
                    final item = _savedAddresses[index];
                    final bool isCurrent = _deliveryAddress.contains(item['label']!);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _deliveryAddress = '${item['label']!}, ${item['address']!}';
                          _mapCenter = LatLng(double.parse(item['lat']!), double.parse(item['lng']!));
                          _isGpsDetected = false;
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: NeoColors.brand,
                            content: Text(
                              '📍 Alamat Diubah ke: ${item['label']}',
                              style: const TextStyle(fontWeight: FontWeight.w900, color: NeoColors.white),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCurrent ? NeoColors.goldSoft : NeoColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isCurrent ? NeoColors.gold : NeoColors.black, width: 1.8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: NeoColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: NeoColors.black, width: 1.2),
                              ),
                              child: Text(item['emoji']!, style: const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item['label']!,
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                                      ),
                                      if (isCurrent) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: NeoColors.gold,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text('UTAMA', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: NeoColors.black)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['address']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle_outline_rounded, color: NeoColors.brand, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // OPEN CHECKOUT SHEET
  void _openCheckoutSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final int subtotal = _calculateCartTotal();
        final int baseMerchantPrice = (subtotal / 1.20).round();
        final int markup20Percent = subtotal - baseMerchantPrice;
        final int appFee = 1000;
        final int serviceFee = 2000;
        final int ongkir = 9000;
        final int grandTotal = subtotal + appFee + serviceFee + ongkir;
        final int driverPayout = (ongkir * 0.95).round();
        final int merchantPayout = baseMerchantPrice;

        return Container(
          padding: const EdgeInsets.all(20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: NeoColors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('🛒 Rincian Pesanan', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: NeoColors.black)),
                  Text('BISPIRA Food 🍔', style: TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 14),

              // Delivery Address Info
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  _openLocationPickerSheet();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NeoColors.brandSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoColors.brand, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Lokasi Pengantaran (Ketuk untuk ubah)', style: TextStyle(fontSize: 10, color: NeoColors.textMuted, fontWeight: FontWeight.w800)),
                            Text(_deliveryAddress, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black)),
                          ],
                        ),
                      ),
                      const Icon(Icons.edit_location_alt_rounded, color: NeoColors.brand, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cart Items List
              const Text('ITEMS DALAM KERANJANG', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.8, color: NeoColors.textMuted)),
              const SizedBox(height: 10),

              Column(
                children: _cartItems.values.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(item['emoji'] as String, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Text(
                              '${item['qty']}x  ${item['name']}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                            ),
                          ],
                        ),
                        Text(
                          'Rp ${_formatPrice((item['price'] as int) * (item['qty'] as int))}',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.brand),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const Divider(color: NeoColors.black, height: 20, thickness: 1.5),

              // EXCEL FORMULA BREAKDOWN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Harga Dasar Merchant', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                  Text('Rp ${_formatPrice(baseMerchantPrice)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Markup Platform (20%)', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                  Text('+ Rp ${_formatPrice(markup20Percent)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.brand)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Biaya Aplikasi BISPIRA', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                  Text('+ Rp ${_formatPrice(appFee)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Biaya Layanan & Penanganan', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                  Text('+ Rp ${_formatPrice(serviceFee)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ongkos Kirim BISPIRA Express ⚡', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                  Text('+ Rp ${_formatPrice(ongkir)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                ],
              ),
              const SizedBox(height: 10),

              // EXCEL TRANSPARENCY SETTLEMENT BANNER
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.analytics_rounded, color: NeoColors.brand, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Transparansi Split Settlement Excel:\n• Merchant Payout: Rp ${_formatPrice(merchantPayout)}\n• Driver Payout (95% Ongkir): Rp ${_formatPrice(driverPayout)}',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF334155), height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL PEMBAYARAN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black)),
                  Text(
                    'Rp ${_formatPrice(grandTotal)}',
                    style: const TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Pay Button
              GestureDetector(
                onTap: () {
                  if (_userBalance < grandTotal) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saldo BISPIRA tidak mencukupi. Silakan Top Up!')),
                    );
                    return;
                  }

                  Navigator.pop(ctx);
                  setState(() {
                    _userBalance -= grandTotal;
                    _cartItems.clear();
                  });

                  showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: NeoColors.black, width: 2.5),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🛵', style: TextStyle(fontSize: 54)),
                          const SizedBox(height: 10),
                          const Text('Pesanan Berhasil Dibuat!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: NeoColors.black)),
                          const SizedBox(height: 6),
                          Text(
                            'Driver BISPIRA sedang meluncur mengantar ke: $_deliveryAddress',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 18),
                          SoftNeoButton(
                            text: 'OK, Selesai 👍',
                            backgroundColor: NeoColors.brand,
                            textColor: NeoColors.white,
                            onPressed: () => Navigator.pop(c),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: NeoColors.brand,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NeoColors.black, width: 2.2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Bayar Rp ${_formatPrice(grandTotal)} (Saldo: Rp ${_formatPrice(_userBalance)})',
                      style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 14),
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

  @override
  Widget build(BuildContext context) {
    final int cartCount = _calculateCartCount();
    final int cartTotal = _calculateCartTotal();

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ============================================================
                // TOP HEADER BAR (SHOPEEFOOD LOCATION & AUTO GPS DETECTION)
                // ============================================================
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    border: const Border(bottom: BorderSide(color: NeoColors.black, width: 2)),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(0, 2), blurRadius: 0),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Top Row: Back Button + Search Input + Balance Tag
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onBackPressed,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: NeoColors.brandSoft,
                                shape: BoxShape.circle,
                                border: Border.all(color: NeoColors.black, width: 1.8),
                                boxShadow: const [
                                  BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                                ],
                              ),
                              child: const Icon(Icons.arrow_back_rounded, size: 18, color: NeoColors.black),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Search Bar Input
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: NeoColors.bg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(Icons.search_rounded, color: NeoColors.brand, size: 20),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                                      decoration: const InputDecoration(
                                        hintText: 'Cari resto, makanan, atau kopi...',
                                        hintStyle: TextStyle(color: NeoColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Balance Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: NeoColors.gold,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 1.8),
                            ),
                            child: Text(
                              'Rp ${_formatPrice(_userBalance)}',
                              style: const TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // LOCATION LINE (SHOPEEFOOD STYLE WITH GPS AUTO BADGE)
                      GestureDetector(
                        onTap: _openLocationPickerSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: NeoColors.brandSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: NeoColors.brand, width: 1.2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 18),
                              const SizedBox(width: 6),
                              const Text('Antar ke: ', style: TextStyle(color: NeoColors.textMuted, fontSize: 11.5, fontWeight: FontWeight.w800)),
                              Expanded(
                                child: Text(
                                  _deliveryAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: NeoColors.brand,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('UBAH 📍', style: TextStyle(color: NeoColors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ============================================================
                // MAIN SCROLLABLE CONTENT WITH HERO BANNER CAROUSEL & 3 SECTIONS
                // ============================================================
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. HERO PROMO & SPONSOR CAROUSEL BANNER (SHOPEEFOOD STYLE TOP BANNER)
                        const SizedBox(height: 14),
                        Column(
                          children: [
                            SizedBox(
                              height: 140,
                              child: PageView.builder(
                                controller: _bannerPageController,
                                onPageChanged: (index) => setState(() => _bannerIndex = index),
                                itemCount: _heroBanners.length,
                                itemBuilder: (context, index) {
                                  final banner = _heroBanners[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: banner['bg'] as Color,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: NeoColors.black, width: 2.2),
                                      boxShadow: const [
                                        BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: banner['badgeBg'] as Color,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                                ),
                                                child: Text(
                                                  banner['tag'] as String,
                                                  style: TextStyle(
                                                    color: banner['badgeText'] as Color,
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                banner['title'] as String,
                                                style: TextStyle(
                                                  color: banner['textColor'] as Color,
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                banner['sub'] as String,
                                                style: TextStyle(
                                                  color: (banner['textColor'] as Color).withOpacity(0.85),
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(banner['emoji'] as String, style: const TextStyle(fontSize: 40)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Carousel Dots Indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_heroBanners.length, (index) {
                                final bool isSelected = _bannerIndex == index;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: isSelected ? 20 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isSelected ? NeoColors.brand : NeoColors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // CATEGORY FILTER PILLS
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: List.generate(_categories.length, (index) {
                              final cat = _categories[index];
                              final bool isSelected = _selectedCategoryIndex == index;

                              return GestureDetector(
                                onTap: () => setState(() => _selectedCategoryIndex = index),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? NeoColors.brand : NeoColors.surface,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: NeoColors.black, width: 1.8),
                                    boxShadow: isSelected
                                        ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(cat['emoji']!, style: const TextStyle(fontSize: 14)),
                                      const SizedBox(width: 6),
                                      Text(
                                        cat['name']!,
                                        style: TextStyle(
                                          color: isSelected ? NeoColors.white : NeoColors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ============================================================
                        // SECTION 1: SERING DIREKOMENDASIKAN
                        // ============================================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Sering Direkomendasikan',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: NeoColors.black),
                              ),
                              Text(
                                'Lihat Semua ›',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.brand),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          height: 185,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _seringDirekomendasikan.length,
                            itemBuilder: (context, index) {
                              final item = _seringDirekomendasikan[index];
                              return Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: NeoColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: NeoColors.black, width: 2),
                                  boxShadow: const [
                                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 95,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: item['bgColor'] as Color,
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                        border: const Border(bottom: BorderSide(color: NeoColors.black, width: 1.8)),
                                      ),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 44)),
                                          ),
                                          Positioned(
                                            top: 6,
                                            left: 6,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: NeoColors.gold,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: NeoColors.black, width: 1),
                                              ),
                                              child: Text(
                                                item['tag'] as String,
                                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: NeoColors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded, color: NeoColors.gold, size: 14),
                                              const SizedBox(width: 2),
                                              Text(
                                                '${item['rating']}',
                                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: NeoColors.black),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '• ${item['distance']}',
                                                style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700),
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
                        ),
                        const SizedBox(height: 24),

                        // ============================================================
                        // SECTION 2: PERLU KAMU COBA
                        // ============================================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Perlu Kamu Coba',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: NeoColors.black),
                              ),
                              Text(
                                'Lihat Semua ›',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.brand),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.82,
                            ),
                            itemCount: _perluKamuCoba.length,
                            itemBuilder: (context, index) {
                              final item = _perluKamuCoba[index];
                              final String key = item['name'] as String;
                              final int qtyInCart = _cartItems[key]?['qty'] ?? 0;

                              return Container(
                                decoration: BoxDecoration(
                                  color: NeoColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: NeoColors.black, width: 2),
                                  boxShadow: const [
                                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: NeoColors.brandSoft,
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                                          border: Border(bottom: BorderSide(color: NeoColors.black, width: 1.8)),
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 48)),
                                            ),
                                            Positioned(
                                              top: 6,
                                              left: 6,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: NeoColors.gold,
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: NeoColors.black, width: 1),
                                                ),
                                                child: Text(
                                                  item['tag'] as String,
                                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: NeoColors.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Rp ${_formatPrice(item['price'] as int)}',
                                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.brand),
                                          ),
                                          const SizedBox(height: 6),

                                          qtyInCart > 0
                                              ? Container(
                                                  height: 30,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: NeoColors.gold,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: NeoColors.black, width: 1.5),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => _removeFromCart(key),
                                                        child: const Icon(Icons.remove, size: 16, color: NeoColors.black),
                                                      ),
                                                      Text(
                                                        '$qtyInCart',
                                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () => _addToCart(item),
                                                        child: const Icon(Icons.add, size: 16, color: NeoColors.black),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () => _addToCart(item),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: NeoColors.brand,
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(color: NeoColors.black, width: 1.5),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        '+ Tambah',
                                                        style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 11),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ============================================================
                        // SECTION 3: JAWARA LOKAL
                        // ============================================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Jawara Lokal',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: NeoColors.black),
                              ),
                              Text(
                                'Lihat Semua ›',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.brand),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: List.generate(_jawaraLokal.length, (index) {
                              final item = _jawaraLokal[index];
                              final String key = item['name'] as String;
                              final int qtyInCart = _cartItems[key]?['qty'] ?? 0;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: NeoColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: NeoColors.black, width: 2),
                                  boxShadow: const [
                                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        color: NeoColors.goldSoft,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: NeoColors.black, width: 1.5),
                                      ),
                                      child: Center(
                                        child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 34)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] as String,
                                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['sub'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 6),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Rp ${_formatPrice(item['price'] as int)}',
                                                style: const TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 13),
                                              ),

                                              qtyInCart > 0
                                                  ? Container(
                                                      height: 30,
                                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        color: NeoColors.gold,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: NeoColors.black, width: 1.5),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () => _removeFromCart(key),
                                                            child: const Icon(Icons.remove, size: 14, color: NeoColors.black),
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Text('$qtyInCart', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black)),
                                                          const SizedBox(width: 6),
                                                          GestureDetector(
                                                            onTap: () => _addToCart(item),
                                                            child: const Icon(Icons.add, size: 14, color: NeoColors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () => _addToCart(item),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        decoration: BoxDecoration(
                                                          color: NeoColors.brand,
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: NeoColors.black, width: 1.5),
                                                        ),
                                                        child: const Text(
                                                          '+ Tambah',
                                                          style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 11),
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
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ============================================================
            // STICKY FLOATING CART BAR
            // ============================================================
            if (cartCount > 0)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: GestureDetector(
                  onTap: _openCheckoutSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: NeoColors.brand,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NeoColors.black, width: 2.5),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(4, 4), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: NeoColors.gold,
                                shape: BoxShape.circle,
                                border: Border.all(color: NeoColors.black, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  '$cartCount',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Keranjang Saya',
                                  style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13),
                                ),
                                Text(
                                  'Rp ${_formatPrice(cartTotal)}',
                                  style: const TextStyle(color: NeoColors.gold, fontWeight: FontWeight.w900, fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: NeoColors.black, width: 1.8),
                            boxShadow: const [
                              BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Lanjut Pembayaran',
                                style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 12.5),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, color: NeoColors.black, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
