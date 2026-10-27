import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';
import '../services/api_service.dart';

enum RideStep { pickup, destination, checkout }

class RideScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const RideScreen({
    Key? key,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _driverAnimController;

  late final TextEditingController _pickupController;
  late final TextEditingController _dropoffController;
  late final TextEditingController _searchController;
  late final TextEditingController _driverNoteController;
  late final FocusNode _searchFocusNode;

  RideStep _currentStep = RideStep.pickup;

  // Default Location: User's real location in Semarang (Genuk / Karangtengah / Simpang Lima)
  LatLng _pickupLocation = const LatLng(-6.9536, 110.4682); // Genuk, Semarang
  LatLng _dropoffLocation = const LatLng(-6.9903, 110.4229); // Simpang Lima Semarang

  int _selectedServiceIndex = 0; // 0 = Motor, 1 = Kurir, 2 = Kargo, 3 = Ambulance
  String _paymentMethod = 'BISPIRA Pay';
  int _userBalance = 250000;
  bool _isLoadingSearch = false;

  // OSRM GIS Routing State
  List<LatLng> _osrmPolylinePoints = [];
  bool _isLoadingRoute = false;
  double _osrmDistanceKm = 0.0;
  int _osrmDurationMin = 0;
  Map<String, dynamic>? _osrmFareData;

  Future<void> _fetchOsrmRouteAndFare() async {
    setState(() => _isLoadingRoute = true);
    try {
      final serviceType = _serviceOptions[_selectedServiceIndex]['id'] as String;
      final result = await ApiService.getOsrmRoute(
        originLat: _pickupLocation.latitude,
        originLng: _pickupLocation.longitude,
        destLat: _dropoffLocation.latitude,
        destLng: _dropoffLocation.longitude,
        serviceType: serviceType,
      );

      final route = result['route'] as Map<String, dynamic>?;
      final fare = result['fare'] as Map<String, dynamic>?;

      if (route != null && mounted) {
        final List rawPolyline = route['polylinePoints'] ?? [];
        final List<LatLng> points = rawPolyline.map((pt) {
          if (pt is List && pt.length >= 2) {
            return LatLng((pt[0] as num).toDouble(), (pt[1] as num).toDouble());
          }
          return _pickupLocation;
        }).toList();

        setState(() {
          _osrmPolylinePoints = points;
          _osrmDistanceKm = (route['distanceKm'] as num?)?.toDouble() ?? _calculateDistanceInKm();
          _osrmDurationMin = (route['durationMinutes'] as num?)?.toInt() ?? 15;
          _osrmFareData = fare;
          _isLoadingRoute = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingRoute = false);
    }
  }

  Map<String, dynamic>? _selectedVoucher = {
    'code': 'BISPIRASUPER',
    'title': 'Diskon Rp 7.000 SuperApp',
    'discountAmount': 7000,
  };

  Timer? _debounceTimer;
  Timer? _mapMoveTimer;

  // 4 ARMADA TERSEDIA (WITH RESPONSIVE FIT TO PREVENT ANY BOTTOM OVERFLOW!)
  final List<Map<String, dynamic>> _serviceOptions = [
    {
      'id': 'motor',
      'name': 'Motor',
      'sub': '3-5 Menit',
      'emoji': '🛵',
      'basePrice': 15000,
    },
    {
      'id': 'kurir',
      'name': 'Kurir',
      'sub': 'Logistik Instan',
      'emoji': '📦',
      'basePrice': 20000,
    },
    {
      'id': 'kargo',
      'name': 'Kargo',
      'sub': 'Muatan Besar',
      'emoji': '🚚',
      'basePrice': 65000,
    },
    {
      'id': 'ambulance',
      'name': 'Ambulance',
      'sub': 'Darurat 24/7',
      'emoji': '🚑',
      'basePrice': 120000,
    },
  ];

  // RECENT & POPULAR LOCATIONS DATABASE (SEMARANG & SURROUNDINGS)
  final List<Map<String, dynamic>> _realDatabase = [
    {
      'name': 'Jl. Karang Tengah II, Genuk',
      'address': 'Genuksari, Kec. Genuk, Kota Semarang, Jawa Tengah',
      'lat': -6.9536,
      'lng': 110.4682,
      'icon': '🏠',
      'tag': 'Semarang',
      'subTag': '📍 Lokasi HP Saya Saat Ini',
    },
    {
      'name': 'Simpang Lima Semarang',
      'address': 'Pleburan, Semarang Selatan, Kota Semarang',
      'lat': -6.9903,
      'lng': 110.4229,
      'icon': '🏛️',
      'tag': 'Semarang',
      'subTag': '📍 Pusat Kota Semarang',
    },
    {
      'name': 'Tlogosari Kulon (Pedurungan)',
      'address': 'Kec. Pedurungan, Kota Semarang, Jawa Tengah',
      'lat': -6.9806,
      'lng': 110.4614,
      'icon': '🏘️',
      'tag': 'Semarang',
      'subTag': '📍 Area Perumahan Tlogosari',
    },
    {
      'name': 'Stasiun Semarang Tawang',
      'address': 'Jl. Tawang No. 1, Tanjung Mas, Semarang',
      'lat': -6.9644,
      'lng': 110.4279,
      'icon': '🚆',
      'tag': 'Semarang',
      'subTag': '🚆 Stasiun Kereta Utama',
    },
    {
      'name': 'Bandara Internasional Ahmad Yani',
      'address': 'Tambakharjo, Semarang Barat, Kota Semarang',
      'lat': -6.9723,
      'lng': 110.3742,
      'icon': '✈️',
      'tag': 'Semarang',
      'subTag': '✈️ Bandara Udara Semarang',
    },
    {
      'name': 'Jalan Jenderal Sudirman SCBD',
      'address': 'SCBD, Kebayoran Baru, Jakarta Selatan',
      'lat': -6.2250,
      'lng': 106.8080,
      'icon': '🏢',
      'tag': 'Jakarta',
      'subTag': '📍 Area Perkantoran SCBD',
    },
  ];

  late List<Map<String, dynamic>> _filteredLocations;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pickupController = TextEditingController(text: 'Jalan Karang Tengah II, No. 6B, Genuk, Semarang');
    _dropoffController = TextEditingController(text: 'Simpang Lima Semarang');
    _searchController = TextEditingController();
    _driverNoteController = TextEditingController();
    _searchFocusNode = FocusNode();
    _filteredLocations = List.from(_realDatabase);

    _driverAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_pickupLocation, 16.8);
    });
  }

  @override
  void dispose() {
    _driverAnimController.dispose();
    _debounceTimer?.cancel();
    _pickupController.dispose();
    _dropoffController.dispose();
    _searchController.dispose();
    _driverNoteController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchQueryChanged(String query) {
    _debounceTimer?.cancel();
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _isLoadingSearch = false;
        _filteredLocations = List.from(_realDatabase);
      });
      return;
    }

    final localMatches = _realDatabase.where((loc) {
      final queryLower = q.toLowerCase();
      final nameMatch = (loc['name'] as String).toLowerCase().contains(queryLower);
      final addrMatch = (loc['address'] as String).toLowerCase().contains(queryLower);
      return nameMatch || addrMatch;
    }).toList();

    setState(() {
      _isLoadingSearch = true;
      _filteredLocations = List.from(localMatches);
    });

    _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
      try {
        final nominatimUrl = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(q)}&format=json&addressdetails=1&limit=5&countrycodes=id',
        );

        final res = await http.get(nominatimUrl, headers: {'User-Agent': 'BispiraApp/1.0'}).timeout(const Duration(seconds: 3));

        if (res.statusCode == 200) {
          final List nData = json.decode(res.body);
          final List<Map<String, dynamic>> apiResults = [];

          for (var item in nData) {
            final String displayName = item['display_name'] ?? '';
            final String latStr = item['lat'] ?? '0';
            final String lonStr = item['lon'] ?? '0';
            final Map address = item['address'] ?? {};

            final String mainTitle = address['building'] ??
                address['amenity'] ??
                address['shop'] ??
                address['tourism'] ??
                address['suburb'] ??
                address['road'] ??
                displayName.split(',').first;

            final String city = address['city'] ?? address['regency'] ?? address['county'] ?? 'Indonesia';

            apiResults.add({
              'name': mainTitle,
              'address': '$city, Indonesia',
              'lat': double.tryParse(latStr) ?? 0.0,
              'lng': double.tryParse(lonStr) ?? 0.0,
              'icon': '📍',
              'tag': city,
              'subTag': '📍 OpenStreetMap Data',
            });
          }

          if (mounted) {
            setState(() {
              _isLoadingSearch = false;
              _filteredLocations = [...localMatches, ...apiResults];
            });
          }
        }
      } catch (_) {
        if (mounted) setState(() => _isLoadingSearch = false);
      }
    });
  }

  double _calculateDistanceInKm() {
    const double earthRadius = 6371;
    final double dLat = _deg2rad(_dropoffLocation.latitude - _pickupLocation.latitude);
    final double dLon = _deg2rad(_dropoffLocation.longitude - _pickupLocation.longitude);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(_pickupLocation.latitude)) *
            math.cos(_deg2rad(_dropoffLocation.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return math.max(2.0, earthRadius * c);
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);

  int _calculateBasePrice() {
    final double dist = _calculateDistanceInKm();
    final int base = _serviceOptions[_selectedServiceIndex]['basePrice'] as int;
    return base + (dist * 2000).round();
  }

  int _calculateServiceFee() => 3000;

  int _calculateGrandTotal() {
    return _calculateBasePrice() + _calculateServiceFee();
  }

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _selectLocationForCurrentStep(Map<String, dynamic> loc) {
    setState(() {
      if (_currentStep == RideStep.pickup) {
        _pickupLocation = LatLng(loc['lat'] as double, loc['lng'] as double);
        _pickupController.text = loc['name'] as String;
        _currentStep = RideStep.destination;
        _mapController.move(_dropoffLocation, 14.0);
      } else if (_currentStep == RideStep.destination) {
        _dropoffLocation = LatLng(loc['lat'] as double, loc['lng'] as double);
        _dropoffController.text = loc['name'] as String;
        _currentStep = RideStep.checkout;

        // Fetch real OSRM routing and fare breakdown
        _fetchOsrmRouteAndFare();

        // Fit both markers on screen
        _mapController.move(
          LatLng(
            (_pickupLocation.latitude + _dropoffLocation.latitude) / 2,
            (_pickupLocation.longitude + _dropoffLocation.longitude) / 2,
          ),
          12.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // TOP HEADER BAR
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
                          if (_currentStep == RideStep.checkout) {
                            setState(() => _currentStep = RideStep.destination);
                          } else if (_currentStep == RideStep.destination) {
                            setState(() => _currentStep = RideStep.pickup);
                          } else {
                            widget.onBackPressed();
                          }
                        },
                        child: SoftNeoBackButton(
                          onBackPressed: () {
                            if (_currentStep == RideStep.checkout) {
                              setState(() => _currentStep = RideStep.destination);
                            } else if (_currentStep == RideStep.destination) {
                              setState(() => _currentStep = RideStep.pickup);
                            } else {
                              widget.onBackPressed();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        _currentStep == RideStep.pickup
                            ? 'BISPIRA Ride'
                            : _currentStep == RideStep.destination
                                ? 'Pilih Tujuan'
                                : 'Konfirmasi Pesanan',
                        style: const TextStyle(
                          color: NeoColors.brand,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          letterSpacing: 0.5,
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
                  _buildStep1PickupView(),
                  _buildStep2DestinationView(),
                  _buildStep3CheckoutView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STEP 1: SET PICKUP LOCATION FIRST (GOJEK MAP PICKER UX)
  // ============================================================
  Widget _buildStep1PickupView() {
    return Column(
      children: [
        // Interactive Map with Center Pin Marker
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _pickupLocation,
                  initialZoom: 16.5,
                  onPositionChanged: (pos, hasGesture) {
                    if (hasGesture && pos.center != null) {
                      setState(() {
                        _pickupLocation = pos.center!;
                      });
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
                              setState(() {
                                _pickupController.text = shortName;
                              });
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

              // CENTER PICKUP PIN MARKER (GOJEK STYLE)
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
                          boxShadow: const [
                            BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                          ],
                        ),
                        child: const Text(
                          'Geser peta untuk atur titik penjemputan 🎯',
                          style: TextStyle(color: NeoColors.gold, fontSize: 11, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.location_on_rounded, size: 48, color: NeoColors.brand),
                    ],
                  ),
                ),
              ),

              // GPS MY LOCATION BUTTON
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () {
                    final LatLng myGps = const LatLng(-6.9536, 110.4682); // Real user GPS in Semarang
                    setState(() {
                      _pickupLocation = myGps;
                      _pickupController.text = 'Jl. Karang Tengah II, Genuksari, Genuk, Semarang';
                    });
                    _mapController.move(myGps, 16.8);
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

        // Bottom Pickup Confirmation Sheet (Gojek Style)
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
              const Text(
                'Cek lagi titik jemput di peta 📍',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NeoColors.black),
              ),
              const SizedBox(height: 10),

              // Address card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.brandSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.brand, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: NeoColors.brand,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Tersimpan', style: TextStyle(color: NeoColors.white, fontSize: 9.5, fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _pickupController.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Big Confirmation Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentStep = RideStep.destination;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
                      'Konfirmasi Titik Jemput 📍',
                      style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 14),
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
  // STEP 2: SET DESTINATION LOCATION (GOJEK DESTINATION SEARCH UX)
  // ============================================================
  Widget _buildStep2DestinationView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NeoColors.brand,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: NeoColors.black, width: 2.2),
              boxShadow: const [
                BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mau ke mana hari ini, davy? 🛵',
                        style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Pilih lokasi tujuan pengantaran Anda.',
                        style: TextStyle(color: NeoColors.gold, fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text('🛵', style: TextStyle(fontSize: 38)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NeoColors.black, width: 2),
              boxShadow: const [
                BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchQueryChanged,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
              decoration: const InputDecoration(
                hintText: 'Cari lokasi tujuan (Mall, Stasiun, Rumah)...',
                hintStyle: TextStyle(color: NeoColors.textMuted, fontSize: 12.5),
                prefixIcon: Icon(Icons.search_rounded, color: NeoColors.brand, size: 22),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirmed Pickup Info Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: NeoColors.brandSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NeoColors.brand, width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 18),
                const SizedBox(width: 8),
                const Text('Jemput dari: ', style: TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                Expanded(
                  child: Text(
                    _pickupController.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: NeoColors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _currentStep = RideStep.pickup),
                  child: const Text('Ubah ✏️', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          const Text('RIWAYAT & REKOMENDASI LOKASI', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.8, color: NeoColors.textMuted)),
          const SizedBox(height: 10),

          // Location Suggestions List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredLocations.length,
            itemBuilder: (context, index) {
              final loc = _filteredLocations[index];
              return GestureDetector(
                onTap: () => _selectLocationForCurrentStep(loc),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoColors.black, width: 1.8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NeoColors.goldSoft,
                          shape: BoxShape.circle,
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: Text(loc['icon'] as String, style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              loc['address'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: NeoColors.brand, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP 3: BOTH LOCATIONS CONFIRMED -> SHOW 4 ARMADA & CHECKOUT (NO OVERFLOW!)
  // ============================================================
  Widget _buildStep3CheckoutView() {
    final double distKm = _calculateDistanceInKm();
    final double effectiveDistKm = _osrmDistanceKm > 0 ? _osrmDistanceKm : distKm;
    final int estimatedMinutes = (distKm * 1.5).round();
    final int effectiveMinutes = _osrmDurationMin > 0 ? _osrmDurationMin : estimatedMinutes;
    final selectedService = _serviceOptions[_selectedServiceIndex];

    return Column(
      children: [
        // Live Interactive Map with OSRM Routing (Top Half)
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    (_pickupLocation.latitude + _dropoffLocation.latitude) / 2,
                    (_pickupLocation.longitude + _dropoffLocation.longitude) / 2,
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
                        points: _osrmPolylinePoints.isNotEmpty ? _osrmPolylinePoints : [_pickupLocation, _dropoffLocation],
                        strokeWidth: 5.0,
                        color: NeoColors.brand,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _pickupLocation,
                        width: 32,
                        height: 32,
                        child: const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 26),
                      ),
                      Marker(
                        point: _dropoffLocation,
                        width: 32,
                        height: 32,
                        child: const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: NeoColors.black, width: 1.8),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isLoadingRoute ? Colors.orange : const Color(0xFF00C853),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isLoadingRoute
                            ? 'Menghitung rute OSRM...'
                            : 'OSRM: ${effectiveDistKm.toStringAsFixed(1)} km (~$effectiveMinutes mnt)',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10.5, color: NeoColors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Options & Checkout Panel (NO OVERFLOW GUARANTEED!)
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Floating Dual Location Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded, color: NeoColors.brand, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _pickupController.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Divider(color: NeoColors.black, height: 1, thickness: 1),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _dropoffController.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // PILIH LAYANAN (4 ARMADA GRID - RESPONSIVE & NO OVERFLOW!)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: NeoColors.black, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Pilih Layanan',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: NeoColors.black),
                          ),
                          Text(
                            '4 Armada Tersedia',
                            style: TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 2x2 Grid with Fitted Content (Zero Overflow!)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.4, // Adjusted ratio to eliminate overflow!
                        ),
                        itemCount: _serviceOptions.length,
                        itemBuilder: (context, index) {
                          final item = _serviceOptions[index];
                          final bool isSelected = _selectedServiceIndex == index;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedServiceIndex = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? NeoColors.brandSoft : NeoColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? NeoColors.brand : NeoColors.black,
                                  width: isSelected ? 2.2 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item['emoji'] as String, style: const TextStyle(fontSize: 22)),
                                  const SizedBox(height: 4),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      item['name'] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12.5,
                                        color: isSelected ? NeoColors.brand : NeoColors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      item['sub'] as String,
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        color: isSelected ? NeoColors.brand : NeoColors.textMuted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Payment & Promo Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: NeoColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.black, width: 1.8),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.account_balance_wallet_rounded, color: NeoColors.brand, size: 18),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'BISPIRA Pay',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: NeoColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: NeoColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.black, width: 1.8),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.confirmation_number_rounded, color: NeoColors.gold, size: 18),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Gunakan Voucher',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: NeoColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // RINCIAN PERJALANAN (TRIP DETAILS)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Perjalanan',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Jarak Tempuh (OSRM)', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                          Text('${effectiveDistKm.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimasi Tiba', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                          Text('$effectiveMinutes min', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: NeoColors.black, height: 1, thickness: 1),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tarif Dasar (${selectedService['name']})', style: const TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                          Text('Rp ${_formatPrice(_calculateBasePrice())}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Biaya Aplikasi BISPIRA', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                          Text('Rp 1.000', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Biaya Layanan & Penanganan', style: TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                          Text('Rp 2.000', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // EXCEL DRIVER SPLIT BANNER
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.two_wheeler_rounded, color: NeoColors.brand, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Transparansi Excel: Driver Menerima 95% Tarif (Rp ${_formatPrice((_calculateBasePrice() * 0.95).round())})',
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Bayar', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: NeoColors.black)),
                          Text(
                            'Rp ${_formatPrice(_calculateBasePrice() + 3000)}',
                            style: const TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // PESAN SEKARANG BUTTON
                      GestureDetector(
                        onTap: () {
                          final grandTotal = _calculateGrandTotal();
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
                                  Text(selectedService['emoji'] as String, style: const TextStyle(fontSize: 48)),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Pemesanan ${selectedService['name']} Berhasil!',
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Driver BISPIRA sedang dalam perjalanan ke: ${_pickupController.text}\nTotal: Rp ${_formatPrice(grandTotal)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
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
                                'Pesan Sekarang',
                                style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 14),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, color: NeoColors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Harga sudah termasuk asuransi Jasa Raharja',
                          style: TextStyle(color: NeoColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600),
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
