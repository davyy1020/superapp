import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

enum SendStep { sender, receiver, checkout }

class SendScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const SendScreen({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> with SingleTickerProviderStateMixin {
  late final MapController _mapController;

  // Controllers for Sender (Pengirim) & Receiver (Penerima)
  late final TextEditingController _senderAddressController;
  late final TextEditingController _senderNameController;
  late final TextEditingController _senderPhoneController;

  late final TextEditingController _receiverAddressController;
  late final TextEditingController _receiverNameController;
  late final TextEditingController _receiverPhoneController;

  late final TextEditingController _packageNoteController;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  SendStep _currentStep = SendStep.sender;

  // Initial Coordinates (Default Semarang User Location)
  LatLng _senderLocation = const LatLng(-6.9536, 110.4682); // Genuk, Semarang
  LatLng _receiverLocation = const LatLng(-6.9903, 110.4229); // Simpang Lima Semarang

  int _selectedPackageCategoryIndex = 0; // Dokumen, Makanan, Elektronik, Pakaian, Pecah Belah, Dus
  int _selectedCourierOptionIndex = 0; // 0 = Motor Instant, 1 = Mobil Box, 2 = Kargo Pickup, 3 = Sameday
  int _userBalance = 250000;
  bool _isInsuranceActive = true;
  bool _isLoadingSearch = false;
  Timer? _mapMoveTimer;
  Timer? _debounceTimer;

  final List<Map<String, dynamic>> _packageCategories = [
    {'name': 'Dokumen', 'emoji': '📄'},
    {'name': 'Makanan', 'emoji': '🍰'},
    {'name': 'Elektronik', 'emoji': '📱'},
    {'name': 'Pakaian', 'emoji': '👕'},
    {'name': 'Pecah Belah', 'emoji': '🍷'},
    {'name': 'Dus Besar', 'emoji': '📦'},
  ];

  final List<Map<String, dynamic>> _courierOptions = [
    {
      'id': 'motor_instant',
      'name': 'BISPIRA Send Motor',
      'sub': 'Instant 1-2 Jam • s.d 20kg',
      'emoji': '🛵',
      'basePrice': 14000,
    },
    {
      'id': 'car_box',
      'name': 'BISPIRA Send Car',
      'sub': 'Mobil Box • s.d 100kg',
      'emoji': '📦',
      'basePrice': 35000,
    },
    {
      'id': 'kargo_pickup',
      'name': 'BISPIRA Kargo Pickup',
      'sub': 'Muatan Besar • s.d 1 Ton',
      'emoji': '🚚',
      'basePrice': 85000,
    },
    {
      'id': 'sameday',
      'name': 'BISPIRA Sameday',
      'sub': 'Ekonomis • Tiba Hari Ini',
      'emoji': '⚡',
      'basePrice': 10000,
    },
  ];

  final List<Map<String, dynamic>> _realDatabase = [
    {
      'name': 'Jl. Karang Tengah II, Genuk',
      'address': 'Genuksari, Kec. Genuk, Kota Semarang, Jawa Tengah',
      'lat': -6.9536,
      'lng': 110.4682,
      'icon': '🏠',
      'tag': 'Semarang',
    },
    {
      'name': 'Simpang Lima Semarang',
      'address': 'Pleburan, Semarang Selatan, Kota Semarang',
      'lat': -6.9903,
      'lng': 110.4229,
      'icon': '🏛️',
      'tag': 'Semarang',
    },
    {
      'name': 'Tlogosari Kulon (Pedurungan)',
      'address': 'Kec. Pedurungan, Kota Semarang, Jawa Tengah',
      'lat': -6.9806,
      'lng': 110.4614,
      'icon': '🏘️',
      'tag': 'Semarang',
    },
    {
      'name': 'Stasiun Semarang Tawang',
      'address': 'Jl. Tawang No. 1, Tanjung Mas, Semarang',
      'lat': -6.9644,
      'lng': 110.4279,
      'icon': '🚆',
      'tag': 'Semarang',
    },
  ];

  late List<Map<String, dynamic>> _filteredLocations;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _senderAddressController = TextEditingController(text: 'Jl. Karang Tengah II, No. 6B, Genuk, Semarang');
    _senderNameController = TextEditingController(text: 'Davy (Pengirim)');
    _senderPhoneController = TextEditingController(text: '0812-3456-7890');

    _receiverAddressController = TextEditingController(text: 'Simpang Lima Semarang');
    _receiverNameController = TextEditingController(text: 'Budi (Penerima)');
    _receiverPhoneController = TextEditingController(text: '0857-9988-7766');

    _packageNoteController = TextEditingController();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _filteredLocations = List.from(_realDatabase);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_senderLocation, 16.5);
    });
  }

  @override
  void dispose() {
    _mapMoveTimer?.cancel();
    _debounceTimer?.cancel();
    _senderAddressController.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _receiverAddressController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _packageNoteController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  double _calculateDistanceInKm() {
    const double earthRadius = 6371;
    final double dLat = _deg2rad(_receiverLocation.latitude - _senderLocation.latitude);
    final double dLon = _deg2rad(_receiverLocation.longitude - _senderLocation.longitude);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(_senderLocation.latitude)) *
            math.cos(_deg2rad(_receiverLocation.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return math.max(2.0, earthRadius * c);
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);

  int _calculateBaseDeliveryFee() {
    final double dist = _calculateDistanceInKm();
    final int base = _courierOptions[_selectedCourierOptionIndex]['basePrice'] as int;
    return base + (dist * 2200).round();
  }

  int _calculateInsuranceFee() => _isInsuranceActive ? 2000 : 0;

  int _calculateGrandTotal() {
    return _calculateBaseDeliveryFee() + _calculateInsuranceFee() + 3000; // 3000 app fee
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // TOP HEADER BAR (BISPIRA SEND DEDICATED)
            // ============================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                border: const Border(bottom: BorderSide(color: NeoColors.black, width: 2)),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(0, 2), blurRadius: 0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_currentStep == SendStep.checkout) {
                            setState(() => _currentStep = SendStep.receiver);
                          } else if (_currentStep == SendStep.receiver) {
                            setState(() => _currentStep = SendStep.sender);
                          } else {
                            widget.onBackPressed();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: NeoColors.goldSoft,
                            shape: BoxShape.circle,
                            border: Border.all(color: NeoColors.black, width: 1.5),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, size: 18, color: NeoColors.black),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('📦', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 6),
                      Text(
                        _currentStep == SendStep.sender
                            ? 'Lokasi Pengambilan'
                            : _currentStep == SendStep.receiver
                                ? 'Lokasi Penerima'
                                : 'Konfirmasi Kurir',
                        style: const TextStyle(
                          color: NeoColors.brand,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  // Balance Pill Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.brand, width: 1.8),
                    ),
                    child: Text(
                      'Rp ${_formatPrice(_userBalance)}',
                      style: const TextStyle(
                        color: NeoColors.brand,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BODY SWITCHER BASED ON STEP
            Expanded(
              child: IndexedStack(
                index: _currentStep.index,
                children: [
                  _buildStep1SenderView(),
                  _buildStep2ReceiverView(),
                  _buildStep3CourierCheckoutView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STEP 1: LOKASI PENGAMBILAN PAKET (PENGIRIM)
  // ============================================================
  Widget _buildStep1SenderView() {
    return Column(
      children: [
        // Interactive Map
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _senderLocation,
                  initialZoom: 16.5,
                  onPositionChanged: (pos, hasGesture) {
                    if (hasGesture && pos.center != null) {
                      setState(() => _senderLocation = pos.center!);
                      _mapMoveTimer?.cancel();
                      _mapMoveTimer = Timer(const Duration(milliseconds: 350), () async {
                        try {
                          final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=${pos.center!.latitude}&lon=${pos.center!.longitude}&format=json');
                          final res = await http.get(url, headers: {'User-Agent': 'BispiraApp/1.0'}).timeout(const Duration(seconds: 3));
                          if (res.statusCode == 200) {
                            final data = json.decode(res.body);
                            final String displayName = data['display_name'] ?? '';
                            final String shortName = displayName.split(',').take(3).join(',');
                            if (mounted && shortName.isNotEmpty) {
                              setState(() => _senderAddressController.text = shortName);
                            }
                          }
                        } catch (_) {}
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

              // Center Marker
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: NeoColors.black,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.gold, width: 1.5),
                        ),
                        child: const Text(
                          'Geser peta untuk atur lokasi pengambilan paket 📦',
                          style: TextStyle(color: NeoColors.gold, fontSize: 11, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.location_on_rounded, size: 48, color: NeoColors.brand),
                    ],
                  ),
                ),
              ),

              // GPS My Location
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () {
                    final LatLng myGps = const LatLng(-6.9536, 110.4682);
                    setState(() {
                      _senderLocation = myGps;
                      _senderAddressController.text = 'Jl. Karang Tengah II, Genuksari, Genuk, Semarang';
                    });
                    _mapController.move(myGps, 16.8);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: NeoColors.gold,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NeoColors.black, width: 1.8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.my_location_rounded, color: NeoColors.black, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Lokasi Saya 🎯',
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

        // Bottom Sender Details Form
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: NeoColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
            boxShadow: const [
              BoxShadow(color: NeoColors.black, offset: Offset(0, -3), blurRadius: 8),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Detail Pengirim Paket 📦', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: NeoColors.black)),
                  Text('Langkah 1/3', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: NeoColors.brand)),
                ],
              ),
              const SizedBox(height: 10),

              // Address text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: NeoColors.brandSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NeoColors.brand, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _senderAddressController.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Inputs for Sender Name & Phone
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: NeoColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: TextField(
                        controller: _senderNameController,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                        decoration: const InputDecoration(
                          hintText: 'Nama Pengirim',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: NeoColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: TextField(
                        controller: _senderPhoneController,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                        decoration: const InputDecoration(
                          hintText: 'No. HP Pengirim',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Next Button
              GestureDetector(
                onTap: () {
                  setState(() => _currentStep = SendStep.receiver);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: NeoColors.brand,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Lanjut ke Lokasi Penerima ➔',
                      style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STEP 2: LOKASI PENERIMA PAKET & DETAIL BARANG
  // ============================================================
  Widget _buildStep2ReceiverView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NeoColors.gold,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: NeoColors.black, width: 2.2),
              boxShadow: const [
                BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
              ],
            ),
            child: Row(
              children: const [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kirim Paket ke Mana? 📦',
                        style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Isi alamat & rincian penerima barang.',
                        style: TextStyle(color: NeoColors.black, fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Text('🚚', style: TextStyle(fontSize: 36)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Receiver Address Input Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: NeoColors.black, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alamat & Kontak Penerima 🎯', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: NeoColors.black)),
                const SizedBox(height: 10),

                // Receiver address
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: NeoColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: NeoColors.black, width: 1.5),
                  ),
                  child: TextField(
                    controller: _receiverAddressController,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    decoration: const InputDecoration(
                      hintText: 'Alamat lengkap penerima...',
                      prefixIcon: Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: NeoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeoColors.black, width: 1.5),
                        ),
                        child: TextField(
                          controller: _receiverNameController,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                          decoration: const InputDecoration(
                            hintText: 'Nama Penerima',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: NeoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeoColors.black, width: 1.5),
                        ),
                        child: TextField(
                          controller: _receiverPhoneController,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                          decoration: const InputDecoration(
                            hintText: 'No. HP Penerima',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // KATEGORI BARANG / PAKET
          const Text('KATEGORI BARANG 📦', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.8, color: NeoColors.textMuted)),
          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.2,
            ),
            itemCount: _packageCategories.length,
            itemBuilder: (context, index) {
              final cat = _packageCategories[index];
              final bool isSelected = _selectedPackageCategoryIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedPackageCategoryIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? NeoColors.brandSoft : NeoColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? NeoColors.brand : NeoColors.black,
                      width: isSelected ? 2 : 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat['emoji'] as String, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          cat['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            color: isSelected ? NeoColors.brand : NeoColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Catatan Tambahan Paket
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: NeoColors.black, width: 1.8),
            ),
            child: TextField(
              controller: _packageNoteController,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                hintText: '📝 Catatan Kurir (Cth: Titipkan ke pos satpam)...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Next Button
          GestureDetector(
            onTap: () {
              setState(() => _currentStep = SendStep.checkout);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: NeoColors.brand,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NeoColors.black, width: 2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: const Center(
                child: Text(
                  'Lanjut ke Pilih Kurir & Kargo ➔',
                  style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP 3: PILIH KURIR/KARGO & CHECKOUT
  // ============================================================
  Widget _buildStep3CourierCheckoutView() {
    final double distKm = _calculateDistanceInKm();
    final selectedCourier = _courierOptions[_selectedCourierOptionIndex];
    final selectedCategory = _packageCategories[_selectedPackageCategoryIndex];

    return Column(
      children: [
        // Map Preview
        SizedBox(
          height: 180,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (_senderLocation.latitude + _receiverLocation.latitude) / 2,
                (_senderLocation.longitude + _receiverLocation.longitude) / 2,
              ),
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.bispira.userapp',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [_senderLocation, _receiverLocation],
                    strokeWidth: 4.5,
                    color: NeoColors.brand,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content Scrollable
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Addresses Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NeoColors.black, width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pengirim: ${_senderNameController.text} (${_senderAddressController.text})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: NeoColors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Divider(color: NeoColors.black, height: 1, thickness: 1),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Penerima: ${_receiverNameController.text} (${_receiverAddressController.text})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: NeoColors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // PILIH ARMADA KURIR / KARGO
                const Text('PILIH ARMADA KURIR & KARGO 🚚', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.8, color: NeoColors.textMuted)),
                const SizedBox(height: 10),

                Column(
                  children: List.generate(_courierOptions.length, (index) {
                    final courier = _courierOptions[index];
                    final bool isSelected = _selectedCourierOptionIndex == index;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedCourierOptionIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? NeoColors.brandSoft : NeoColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? NeoColors.brand : NeoColors.black,
                            width: isSelected ? 2.2 : 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(courier['emoji'] as String, style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courier['name'] as String,
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: isSelected ? NeoColors.brand : NeoColors.black),
                                  ),
                                  Text(
                                    courier['sub'] as String,
                                    style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${_formatPrice((courier['basePrice'] as int) + (distKm * 2200).round())}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.brand),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),

                // Insurance Toggle Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: NeoColors.goldSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoColors.gold, width: 1.8),
                  ),
                  child: Row(
                    children: [
                      const Text('🛡️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Asuransi Barang BISPIRA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black)),
                            Text('Perlindungan barang s.d Rp 10.000.000', style: TextStyle(fontSize: 10, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isInsuranceActive,
                        activeColor: NeoColors.brand,
                        onChanged: (val) => setState(() => _isInsuranceActive = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Total Summary Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: NeoColors.black, width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Jenis Barang: ${selectedCategory['name']} ${selectedCategory['emoji']}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: NeoColors.black)),
                          Text('Jarak: ${distKm.toStringAsFixed(1)} km', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                          Text(
                            'Rp ${_formatPrice(_calculateGrandTotal())}',
                            style: const TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Order Button
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: NeoColors.black, width: 2.5),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('📦', style: TextStyle(fontSize: 48)),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Pemesanan Kurir ${selectedCourier['name']} Berhasil!',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NeoColors.black),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Kurir BISPIRA akan menjemput barang di: ${_senderAddressController.text}\nTotal Tarif: Rp ${_formatPrice(_calculateGrandTotal())}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 16),
                                  SoftNeoButton(
                                    text: 'Selesai 👍',
                                    backgroundColor: NeoColors.brand,
                                    textColor: NeoColors.white,
                                    onPressed: () => Navigator.pop(ctx),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: NeoColors.brand,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: NeoColors.black, width: 2),
                            boxShadow: const [
                              BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pesan Kurir Sekarang',
                                style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, color: NeoColors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
