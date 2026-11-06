import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/bispira_charts.dart';

class FeeCustomizationTab extends StatefulWidget {
  const FeeCustomizationTab({Key? key}) : super(key: key);

  @override
  State<FeeCustomizationTab> createState() => _FeeCustomizationTabState();
}

class _FeeCustomizationTabState extends State<FeeCustomizationTab> {
  // 1. Roda 2 Ride Hailing (Motor)
  late TextEditingController _tariffController;
  late TextEditingController _minFareController;

  // 2. Roda 4 Ride Hailing (Mobil)
  late TextEditingController _tariffR4Controller;
  late TextEditingController _minFareR4Controller;
  late TextEditingController _commissionR4Controller;

  // 3. Food & Logistik Barang Kecil Roda 2
  late TextEditingController _tariffFoodR2Controller;
  late TextEditingController _minFareFoodR2Controller;

  // 4. Biaya Platform & Layanan
  late TextEditingController _appFeeController;
  late TextEditingController _serviceFeeController;
  late TextEditingController _markupController;
  late TextEditingController _disbursementFeeController;
  late TextEditingController _driverChargeController;
  late TextEditingController _driverMinWalletController;

  // 5. Layanan Darurat Khusus Ambulance (0-100KM)
  late TextEditingController _ambAntarController;
  late TextEditingController _ambMinFareController;
  late TextEditingController _ambAngkutController;

  // 6. Layanan Logistik Barang Besar (Mobil Box, Bak, Truk L300)
  late TextEditingController _logistikTariffController;
  late TextEditingController _logistikMinFareController;
  late TextEditingController _logistikAngkutController;
  late TextEditingController _trukL300Controller;

  // 7. Bagi Hasil & Skema Wilayah Dinamis
  late TextEditingController _profitCabangController;
  late TextEditingController _skemaKerjasamaPusatController;
  late TextEditingController _skemaKerjasamaDaerahController;
  late TextEditingController _skemaTanpaKerjasamaPusatController;
  late TextEditingController _skemaTanpaKerjasamaDaerahController;
  late TextEditingController _skemaEventMandiriPusatController;
  late TextEditingController _skemaEventMandiriDaerahController;
  late TextEditingController _uniqueTimerController;

  // Simulator mode & distance
  String _selectedSimulatorMode = 'R2_RIDE'; // 'R2_RIDE', 'R4_CAR', 'R2_FOOD', 'AMBULANCE', 'LOGISTIK_BOX'
  double _simulatedKm = 5.0;
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    final config = Provider.of<AdminProvider>(context, listen: false).currentConfig;
    _tariffController = TextEditingController(text: config.tariffR2PerKm.toInt().toString());
    _minFareController = TextEditingController(text: config.minFareR2.toInt().toString());
    _tariffR4Controller = TextEditingController(text: config.tariffR4PerKm.toInt().toString());
    _minFareR4Controller = TextEditingController(text: config.minFareR4.toInt().toString());
    _commissionR4Controller = TextEditingController(text: config.commissionR4Percent.toString());
    _tariffFoodR2Controller = TextEditingController(text: config.tariffFoodR2PerKm.toInt().toString());
    _minFareFoodR2Controller = TextEditingController(text: config.minFareFoodR2.toInt().toString());

    _appFeeController = TextEditingController(text: config.appFee.toInt().toString());
    _serviceFeeController = TextEditingController(text: config.serviceFee.toInt().toString());
    _markupController = TextEditingController(text: config.markupPercent.toInt().toString());
    _disbursementFeeController = TextEditingController(text: config.disbursementFee.toInt().toString());
    _driverChargeController = TextEditingController(text: config.driverChargeFee.toInt().toString());
    _driverMinWalletController = TextEditingController(text: config.driverMinWalletBalance.toInt().toString());

    _ambAntarController = TextEditingController(text: config.ambulanceTariffPerKm.toInt().toString());
    _ambMinFareController = TextEditingController(text: config.ambulanceMinFare.toInt().toString());
    _ambAngkutController = TextEditingController(text: config.ambulanceAngkutFee.toInt().toString());

    _logistikTariffController = TextEditingController(text: config.logistikTariffPerKm.toInt().toString());
    _logistikMinFareController = TextEditingController(text: config.logistikMinFare.toInt().toString());
    _logistikAngkutController = TextEditingController(text: config.logistikAngkutFee.toInt().toString());
    _trukL300Controller = TextEditingController(text: config.trukL300BaseFee.toInt().toString());

    _profitCabangController = TextEditingController(text: config.profitShareCabang.toInt().toString());
    _skemaKerjasamaPusatController = TextEditingController(text: config.skemaKerjasamaPusatPct.toInt().toString());
    _skemaKerjasamaDaerahController = TextEditingController(text: config.skemaKerjasamaDaerahPct.toInt().toString());
    _skemaTanpaKerjasamaPusatController = TextEditingController(text: config.skemaTanpaKerjasamaPusatPct.toInt().toString());
    _skemaTanpaKerjasamaDaerahController = TextEditingController(text: config.skemaTanpaKerjasamaDaerahPct.toInt().toString());
    _skemaEventMandiriPusatController = TextEditingController(text: config.skemaEventMandiriPusatPct.toInt().toString());
    _skemaEventMandiriDaerahController = TextEditingController(text: config.skemaEventMandiriDaerahPct.toInt().toString());
    _uniqueTimerController = TextEditingController(text: config.uniqueCodeDurationMinutes.toString());
  }

  @override
  void dispose() {
    _tariffController.dispose();
    _minFareController.dispose();
    _tariffR4Controller.dispose();
    _minFareR4Controller.dispose();
    _commissionR4Controller.dispose();
    _tariffFoodR2Controller.dispose();
    _minFareFoodR2Controller.dispose();
    _appFeeController.dispose();
    _serviceFeeController.dispose();
    _markupController.dispose();
    _disbursementFeeController.dispose();
    _driverChargeController.dispose();
    _driverMinWalletController.dispose();
    _ambAntarController.dispose();
    _ambMinFareController.dispose();
    _ambAngkutController.dispose();
    _logistikTariffController.dispose();
    _logistikMinFareController.dispose();
    _logistikAngkutController.dispose();
    _trukL300Controller.dispose();
    _profitCabangController.dispose();
    _skemaKerjasamaPusatController.dispose();
    _skemaKerjasamaDaerahController.dispose();
    _skemaTanpaKerjasamaPusatController.dispose();
    _skemaTanpaKerjasamaDaerahController.dispose();
    _skemaEventMandiriPusatController.dispose();
    _skemaEventMandiriDaerahController.dispose();
    _uniqueTimerController.dispose();
    super.dispose();
  }

  void _applyPreset({
    required double tariff,
    required double minFare,
    required double appFee,
    required double serviceFee,
    required double markup,
    required double profitCabang,
    required String name,
  }) {
    setState(() {
      _tariffController.text = tariff.toInt().toString();
      _minFareController.text = minFare.toInt().toString();
      _appFeeController.text = appFee.toInt().toString();
      _serviceFeeController.text = serviceFee.toInt().toString();
      _markupController.text = markup.toInt().toString();
      _profitCabangController.text = profitCabang.toInt().toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Preset Regulasi "$name" berhasil diterapkan ke form.'),
          ],
        ),
        backgroundColor: const Color(0xFF0066FF),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    // Live calculation for preview simulator
    final double appFee = double.tryParse(_appFeeController.text) ?? 500;
    final double serviceFee = double.tryParse(_serviceFeeController.text) ?? 500;
    final double markupPct = double.tryParse(_markupController.text) ?? 10;
    final double profitCabangPct = double.tryParse(_profitCabangController.text) ?? 25;

    // Parameter dinamis sesuai moda yang dipilih
    double simTariffPerKm = 2500;
    double simMinFare = 8000;
    double simDriverCutPct = 95.0; // Driver share %
    double simExtraJasaAngkut = 0.0;
    String modeLabel = 'Motor R2';

    if (_selectedSimulatorMode == 'R2_RIDE') {
      simTariffPerKm = double.tryParse(_tariffController.text) ?? 2500;
      simMinFare = double.tryParse(_minFareController.text) ?? 8000;
      simDriverCutPct = 95.0;
      modeLabel = 'Motor (Ride Hailing R2)';
    } else if (_selectedSimulatorMode == 'R4_CAR') {
      simTariffPerKm = double.tryParse(_tariffR4Controller.text) ?? 4000;
      simMinFare = double.tryParse(_minFareR4Controller.text) ?? 15000;
      final double commR4 = double.tryParse(_commissionR4Controller.text) ?? 7.5;
      simDriverCutPct = 100.0 - commR4; // 92.5%
      modeLabel = 'Mobil Penumpang (R4)';
    } else if (_selectedSimulatorMode == 'R2_FOOD') {
      simTariffPerKm = double.tryParse(_tariffFoodR2Controller.text) ?? 3000;
      simMinFare = double.tryParse(_minFareFoodR2Controller.text) ?? 10000;
      simDriverCutPct = 95.0;
      modeLabel = 'Food & Logistik Kecil R2';
    } else if (_selectedSimulatorMode == 'AMBULANCE') {
      simTariffPerKm = double.tryParse(_ambAntarController.text) ?? 5000;
      simMinFare = double.tryParse(_ambMinFareController.text) ?? 50000;
      simExtraJasaAngkut = double.tryParse(_ambAngkutController.text) ?? 50000;
      simDriverCutPct = 92.5; // Komisi 7.5%
      modeLabel = 'Ambulance Medis';
    } else if (_selectedSimulatorMode == 'LOGISTIK_BOX') {
      simTariffPerKm = double.tryParse(_logistikTariffController.text) ?? 4000;
      simMinFare = double.tryParse(_logistikMinFareController.text) ?? 50000;
      simExtraJasaAngkut = double.tryParse(_logistikAngkutController.text) ?? 50000;
      simDriverCutPct = 92.5; // Komisi 7.5%
      modeLabel = 'Logistik Box / Bak / L300';
    }

    final double rawDistanceFare = _simulatedKm * simTariffPerKm;
    final double baseTripFare = rawDistanceFare < simMinFare ? simMinFare : rawDistanceFare;
    final double markupAmount = baseTripFare * (markupPct / 100);
    final double totalConsumerPay = baseTripFare + simExtraJasaAngkut + markupAmount + appFee + serviceFee;

    // Driver share: tarif dasar * share% + 99% jasa angkut
    final double driverGross = (baseTripFare * (simDriverCutPct / 100)) + (simExtraJasaAngkut * 0.99);
    // Platform share: tarif dasar komisi% + 1% komisi jasa angkut + markup + app fee + service fee
    final double platformGross = (baseTripFare * ((100 - simDriverCutPct) / 100)) + (simExtraJasaAngkut * 0.01) + markupAmount + appFee + serviceFee;
    final double branchShare = platformGross * (profitCabangPct / 100);
    final double hqNet = platformGross - branchShare;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP HEADER (Fully Expanded, No Overflow)
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0066FF), Color(0xFF0099FF)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0066FF).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'Pengaturan Biaya & Financial Customization',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pusat kendali variabel tarif (Tarif/KM, Markup, Biaya Aplikasi, Payout, Driver Charge Rp500, Ambulance, & Profit Share Cabang).',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Skema Fee Aktif',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066FF).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF0066FF).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_clock_rounded, color: Color(0xFF0066FF), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Kode Unik: ${_uniqueTimerController.text} Menit',
                            style: const TextStyle(
                              color: Color(0xFF0066FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 20),

          // 2. QUICK PRESET REGIONAL BAR (Excel Regulated Zones)
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.public_rounded, color: Color(0xFF0066FF), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Preset Regulasi Wilayah Sesuai Dokumen Lampiran Excel',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Klik tombol untuk autofill skema tarif zona:',
                        style: TextStyle(fontSize: 11, color: textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildPresetChip(
                        title: 'Zona 1 (Sumatera/Kalimantan)',
                        subtitle: 'Tarif Rp2.500 • Min Rp8.000',
                        color: const Color(0xFF0066FF),
                        onTap: () => _applyPreset(
                          tariff: 2500,
                          minFare: 8000,
                          appFee: 1000,
                          serviceFee: 2000,
                          markup: 10,
                          profitCabang: 30,
                          name: 'Zona 1 Sumatera & Kalimantan',
                        ),
                      ),
                      _buildPresetChip(
                        title: 'Zona 2 (Jabodetabek)',
                        subtitle: 'Tarif Rp3.000 • Min Rp10.000',
                        color: const Color(0xFF10B981),
                        onTap: () => _applyPreset(
                          tariff: 3000,
                          minFare: 10000,
                          appFee: 1500,
                          serviceFee: 2500,
                          markup: 10,
                          profitCabang: 30,
                          name: 'Zona 2 Jabodetabek (Kemenhub)',
                        ),
                      ),
                      _buildPresetChip(
                        title: 'Zona 2.2 (Non-Jabodetabek Jawa)',
                        subtitle: 'Tarif Rp2.250 • Min Rp8.000',
                        color: const Color(0xFF6366F1),
                        onTap: () => _applyPreset(
                          tariff: 2250,
                          minFare: 8000,
                          appFee: 1000,
                          serviceFee: 2000,
                          markup: 10,
                          profitCabang: 30,
                          name: 'Zona 2.2 Jawa Non-Jabodetabek',
                        ),
                      ),
                      _buildPresetChip(
                        title: 'Zona 3 (Bali & Timur)',
                        subtitle: 'Tarif Rp2.750 • Min Rp9.000',
                        color: const Color(0xFFEC4899),
                        onTap: () => _applyPreset(
                          tariff: 2750,
                          minFare: 9000,
                          appFee: 1500,
                          serviceFee: 2000,
                          markup: 12,
                          profitCabang: 30,
                          name: 'Zona 3 Bali, Sulawesi & Papua',
                        ),
                      ),
                      _buildPresetChip(
                        title: 'Surge Hujan / Jam Sibuk',
                        subtitle: 'Tarif Rp4.000 • Min Rp20.000',
                        color: const Color(0xFFEF4444),
                        onTap: () => _applyPreset(
                          tariff: 4000,
                          minFare: 20000,
                          appFee: 2000,
                          serviceFee: 3500,
                          markup: 15,
                          profitCabang: 30,
                          name: 'Surge Hujan / Jam Sibuk Ekstrem',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // 3. MAIN FORM & LIVE SIMULATOR SIDE-BY-SIDE
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1050;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT / MAIN COLUMN: FORM PARAMETERS
                  Expanded(
                    flex: isWide ? 6 : 1,
                    child: Column(
                        children: [
                          // SECTION 1: TARIF TRIP & RIDE-HAILING R2 & R4
                          _buildSectionCard(
                            title: '1. Parameter Perjalanan Roda 2 (Motor) & Roda 4 (Mobil)',
                            icon: Icons.directions_car_rounded,
                            iconColor: const Color(0xFF0066FF),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Text(
                                '• KENDARAAN RODA 2 (MOTOR RIDE HAILING)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Tarif per KM (Motor R2)',
                                      helper: 'Tarif dasar pengantaran motor per KM',
                                      controller: _tariffController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Minimum (< 3 KM)',
                                      helper: 'Tarif flat perjalanan jarak dekat motor',
                                      controller: _minFareController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '• KENDARAAN RODA 4 (MOBIL PENUMPANG)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Tarif per KM (Mobil R4)',
                                      helper: 'Tarif dasar pengantaran mobil per KM',
                                      controller: _tariffR4Controller,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Minimum Mobil (< 3 KM)',
                                      helper: 'Tarif flat perjalanan jarak dekat mobil',
                                      controller: _minFareR4Controller,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Komisi Mobil (%)',
                                      helper: 'Potongan komisi R4 (Standar: 7.5%)',
                                      controller: _commissionR4Controller,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildModernInputField(
                                label: 'Persentase Markup Harga Dasar (%)',
                                helper: 'Markup margin platform pada katalog menu & produk',
                                controller: _markupController,
                                suffix: '%',
                                isDark: isDark,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // SECTION 2: RIDE-HAILING FOOD & LOGISTIK KECIL R2
                          _buildSectionCard(
                            title: '2. Parameter Food & Logistik Barang Kecil Roda 2',
                            icon: Icons.fastfood_rounded,
                            iconColor: const Color(0xFFF59E0B),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Tarif per KM (Food & Logistik R2)',
                                      helper: 'Tarif antar makanan & logistik kecil',
                                      controller: _tariffFoodR2Controller,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Minimum (< 3 KM)',
                                      helper: 'Tarif flat dekat Food/Logistik',
                                      controller: _minFareFoodR2Controller,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // SECTION 3: BIAYA LAYANAN KONSUMEN & EKOSISTEM
                          _buildSectionCard(
                            title: '3. Biaya Layanan Konsumen & Ekosistem Driver',
                            icon: Icons.receipt_long_rounded,
                            iconColor: const Color(0xFF10B981),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Aplikasi (Ke Konsumen)',
                                      helper: 'Sesuai Excel: Rp500 per order',
                                      controller: _appFeeController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Layanan Platform',
                                      helper: 'Sesuai Excel: Rp500 per order',
                                      controller: _serviceFeeController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Pencairan (Payout Fee)',
                                      helper: 'Potongan transfer batch 17:00-00:00 WIB',
                                      controller: _disbursementFeeController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Charge Driver per Transaksi',
                                      helper: 'Reguler Rp500 per transaksi',
                                      controller: _driverChargeController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Min. Saldo Driver (Order Cash)',
                                      helper: 'Batas saldo minimal terima cash',
                                      controller: _driverMinWalletController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // SECTION 4: LAYANAN ARMADA KHUSUS (AMBULANCE & LOGISTIK BOX)
                          _buildSectionCard(
                            title: '4. Layanan Armada Khusus (Ambulance & Logistik Box)',
                            icon: Icons.local_hospital_rounded,
                            iconColor: const Color(0xFFEF4444),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Text(
                                '• LAYANAN KHUSUS AMBULANCE MEDIS (0-100KM)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Antar / KM',
                                      helper: 'Tarif Ambulance per KM',
                                      controller: _ambAntarController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Minimum (< 4 KM)',
                                      helper: 'Flat penjemputan dasar ambulance',
                                      controller: _ambMinFareController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Angkut Medis Pasien',
                                      helper: 'Nakes & pendampingan (Komisi 1%)',
                                      controller: _ambAngkutController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '• LAYANAN LOGISTIK BESAR (MOBIL BOX, BAK, TRUK L300)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Antar Box/Bak / KM',
                                      helper: 'Tarif logistik besar per KM',
                                      controller: _logistikTariffController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Minimum (< 4 KM)',
                                      helper: 'Flat penjemputan dasar box/bak',
                                      controller: _logistikMinFareController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Angkut Barang / Porter',
                                      helper: 'Jasa angkut barang (Komisi 1%)',
                                      controller: _logistikAngkutController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildModernInputField(
                                label: 'Tarif Truk L300 Flat Penjemputan',
                                helper: 'Biaya dasar angkutan armada Truk L300',
                                controller: _trukL300Controller,
                                prefix: 'Rp',
                                isDark: isDark,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // SECTION 5: SKEMA BAGI HASIL WILAYAH DINAMIS (EXCEL SHEET 7)
                          _buildSectionCard(
                            title: '5. Skema Bagi Hasil Wilayah Dinamis (Pusat & Daerah)',
                            icon: Icons.hub_rounded,
                            iconColor: const Color(0xFF6366F1),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Text(
                                '• SKEMA 1: KERJASAMA PUSAT & DAERAH (STANDAR 75% : 25%)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Porsi Pusat (%)',
                                      helper: 'Bagi hasil Superadmin Pusat',
                                      controller: _skemaKerjasamaPusatController,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Porsi Admin Daerah (%)',
                                      helper: 'Bagi hasil Pemegang Lisensi Cabang',
                                      controller: _skemaKerjasamaDaerahController,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '• SKEMA 2: TANPA KERJASAMA (STANDAR 100% : 0%)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Porsi Pusat (%)',
                                      helper: 'Seluruh profit ke Pusat HQ',
                                      controller: _skemaTanpaKerjasamaPusatController,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Porsi Daerah (%)',
                                      helper: 'Tanpa lisensi cabang',
                                      controller: _skemaTanpaKerjasamaDaerahController,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '• SKEMA 3: EVENT MANDIRI DAERAH (STANDAR 20% : 80% - KOLOM 9)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Porsi Pusat (%)',
                                      helper: 'Royalti Superadmin Pusat',
                                      controller: _skemaEventMandiriPusatController,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Porsi Panitia Daerah (%)',
                                      helper: 'Porsi Bispira Event Daerah',
                                      controller: _skemaEventMandiriDaerahController,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Profit Share Cabang Default (%)',
                                      helper: 'Persentase acuan kalkulator live',
                                      controller: _profitCabangController,
                                      suffix: '%',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Masa Berlaku Kode Unik (Menit)',
                                      helper: 'Timer auto-cancel rekonsiliasi transfer',
                                      controller: _uniqueTimerController,
                                      suffix: 'Mnt',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ACTION BUTTONS (Save & Reset)
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    provider.updateConfig(
                                      tariffPerKm: double.tryParse(_tariffController.text) ?? 2500,
                                      minFare: double.tryParse(_minFareController.text) ?? 8000,
                                      appFee: double.tryParse(_appFeeController.text) ?? 500,
                                      serviceFee: double.tryParse(_serviceFeeController.text) ?? 500,
                                      markupPercent: double.tryParse(_markupController.text) ?? 10,
                                      disbursementFee: double.tryParse(_disbursementFeeController.text) ?? 1000,
                                      driverChargeFee: double.tryParse(_driverChargeController.text) ?? 500,
                                      ambulanceAntarFee: double.tryParse(_ambAntarController.text) ?? 5000,
                                      ambulanceAngkutFee: double.tryParse(_ambAngkutController.text) ?? 50000,
                                      profitShareCabang: double.tryParse(_profitCabangController.text) ?? 25,
                                      uniqueCodeDurationMinutes: int.tryParse(_uniqueTimerController.text) ?? 30,
                                      tariffR4PerKm: double.tryParse(_tariffR4Controller.text) ?? 4000,
                                      minFareR4: double.tryParse(_minFareR4Controller.text) ?? 15000,
                                      commissionR4Percent: double.tryParse(_commissionR4Controller.text) ?? 7.5,
                                      tariffFoodR2PerKm: double.tryParse(_tariffFoodR2Controller.text) ?? 3000,
                                      minFareFoodR2: double.tryParse(_minFareFoodR2Controller.text) ?? 10000,
                                      logistikTariffPerKm: double.tryParse(_logistikTariffController.text) ?? 4000,
                                      logistikMinFare: double.tryParse(_logistikMinFareController.text) ?? 50000,
                                      logistikAngkutFee: double.tryParse(_logistikAngkutController.text) ?? 50000,
                                      trukL300BaseFee: double.tryParse(_trukL300Controller.text) ?? 100000,
                                      driverMinWalletBalance: double.tryParse(_driverMinWalletController.text) ?? 10000,
                                      skemaKerjasamaPusatPct: double.tryParse(_skemaKerjasamaPusatController.text) ?? 75,
                                      skemaKerjasamaDaerahPct: double.tryParse(_skemaKerjasamaDaerahController.text) ?? 25,
                                      skemaTanpaKerjasamaPusatPct: double.tryParse(_skemaTanpaKerjasamaPusatController.text) ?? 100,
                                      skemaTanpaKerjasamaDaerahPct: double.tryParse(_skemaTanpaKerjasamaDaerahController.text) ?? 0,
                                      skemaEventMandiriPusatPct: double.tryParse(_skemaEventMandiriPusatController.text) ?? 20,
                                      skemaEventMandiriDaerahPct: double.tryParse(_skemaEventMandiriDaerahController.text) ?? 80,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Row(
                                          children: [
                                            Icon(Icons.check_circle_rounded, color: Colors.white),
                                            SizedBox(width: 12),
                                            Text(
                                              'Konfigurasi Biaya Sesuai Excel Baru Berhasil Disimpan!',
                                              style: TextStyle(fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: const Color(0xFF10B981),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF0066FF).withValues(alpha: 0.35),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.save_rounded, color: Colors.white, size: 20),
                                          SizedBox(width: 10),
                                          Text(
                                            'SIMPAN KONFIGURASI BIAYA LIVE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFEF4444),
                                  side: const BorderSide(color: Color(0xFFEF4444), width: 1.4),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _tariffController.text = '2500';
                                    _minFareController.text = '8000';
                                    _tariffR4Controller.text = '4000';
                                    _minFareR4Controller.text = '15000';
                                    _commissionR4Controller.text = '7.5';
                                    _tariffFoodR2Controller.text = '3000';
                                    _minFareFoodR2Controller.text = '10000';
                                    _appFeeController.text = '500';
                                    _serviceFeeController.text = '500';
                                    _markupController.text = '10';
                                    _disbursementFeeController.text = '1000';
                                    _driverChargeController.text = '500';
                                    _driverMinWalletController.text = '10000';
                                    _ambAntarController.text = '5000';
                                    _ambMinFareController.text = '50000';
                                    _ambAngkutController.text = '50000';
                                    _logistikTariffController.text = '4000';
                                    _logistikMinFareController.text = '50000';
                                    _logistikAngkutController.text = '50000';
                                    _trukL300Controller.text = '100000';
                                    _profitCabangController.text = '25';
                                    _skemaKerjasamaPusatController.text = '75';
                                    _skemaKerjasamaDaerahController.text = '25';
                                    _skemaTanpaKerjasamaPusatController.text = '100';
                                    _skemaTanpaKerjasamaDaerahController.text = '0';
                                    _skemaEventMandiriPusatController.text = '20';
                                    _skemaEventMandiriDaerahController.text = '80';
                                    _uniqueTimerController.text = '30';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Form direset ke standar Excel Baru November 2026.')),
                                  );
                                },
                                icon: const Icon(Icons.restart_alt_rounded, size: 20),
                                label: const Text(
                                  'Reset Default',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // RIGHT COLUMN: LIVE REVENUE SHARING & TRIP SIMULATOR (0 - 100 KM)
                  const SizedBox(width: 24),
                  Expanded(
                    flex: isWide ? 4 : 1,
                    child: Column(
                        children: [
                          // INTERACTIVE SIMULATOR CARD (0 - 100 KM)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF0066FF).withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0066FF).withValues(alpha: isDark ? 0.2 : 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
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
                                        color: const Color(0xFF0066FF).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.calculate_rounded, color: Color(0xFF0066FF), size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Live Trip Calculator (0 - 100 KM)',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Simulasi tarif & split settlement multi-armada',
                                            style: TextStyle(fontSize: 11, color: textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                // MODA VEHICLE SELECTOR BUTTONS
                                Text(
                                  'PILIH MODA TRANSPORTASI:',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _buildModePill('R2_RIDE', 'Motor R2', Icons.two_wheeler_rounded),
                                    _buildModePill('R4_CAR', 'Mobil R4', Icons.directions_car_rounded),
                                    _buildModePill('R2_FOOD', 'Food R2', Icons.fastfood_rounded),
                                    _buildModePill('AMBULANCE', 'Ambulance', Icons.local_hospital_rounded),
                                    _buildModePill('LOGISTIK_BOX', 'Box / Bak', Icons.local_shipping_rounded),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Slider Jarak (1.0 - 100.0 KM)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Simulasi Jarak Perjalanan:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0066FF),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${_simulatedKm.toStringAsFixed(1)} KM',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: const Color(0xFF0066FF),
                                    inactiveTrackColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                    thumbColor: const Color(0xFF0066FF),
                                    overlayColor: const Color(0xFF0066FF).withValues(alpha: 0.2),
                                  ),
                                  child: Slider(
                                    value: _simulatedKm,
                                    min: 1.0,
                                    max: 100.0,
                                    divisions: 99,
                                    onChanged: (val) => setState(() => _simulatedKm = val),
                                  ),
                                ),
                                const Divider(height: 20),

                                // Breakdown Rincian Biaya
                                _buildSimRow('Tarif Dasar ($modeLabel)', currencyFmt.format(baseTripFare), textPrimary, textSecondary),
                                if (simExtraJasaAngkut > 0) ...[
                                  const SizedBox(height: 6),
                                  _buildSimRow('Biaya Angkut Pasien/Barang', currencyFmt.format(simExtraJasaAngkut), textPrimary, textSecondary),
                                ],
                                const SizedBox(height: 6),
                                _buildSimRow('Markup Platform (${markupPct.toStringAsFixed(0)}%)', currencyFmt.format(markupAmount), textPrimary, textSecondary),
                                const SizedBox(height: 6),
                                _buildSimRow('Biaya Aplikasi', currencyFmt.format(appFee), textPrimary, textSecondary),
                                const SizedBox(height: 6),
                                _buildSimRow('Biaya Layanan', currencyFmt.format(serviceFee), textPrimary, textSecondary),
                                const SizedBox(height: 10),

                                // Total Konsumen Bayar
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: borderSubtle),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'TOTAL BAYAR KONSUMEN:',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textPrimary),
                                      ),
                                      Text(
                                        currencyFmt.format(totalConsumerPay),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF0066FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Split Settlement Details (Sesuai Excel)
                                Text(
                                  'DISTRIBUSI BAGI HASIL (SPLIT SETTLEMENT):',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildSplitPill(
                                  label: 'Driver (${simDriverCutPct.toStringAsFixed(1)}% Dasar)',
                                  amount: currencyFmt.format(driverGross),
                                  color: const Color(0xFF10B981),
                                  icon: _selectedSimulatorMode == 'R4_CAR' || _selectedSimulatorMode == 'AMBULANCE' || _selectedSimulatorMode == 'LOGISTIK_BOX'
                                      ? Icons.directions_car_rounded
                                      : Icons.two_wheeler_rounded,
                                ),
                                const SizedBox(height: 6),
                                _buildSplitPill(
                                  label: 'Pusat HQ Netto',
                                  amount: currencyFmt.format(hqNet),
                                  color: const Color(0xFF0066FF),
                                  icon: Icons.domain_rounded,
                                ),
                                const SizedBox(height: 6),
                                _buildSplitPill(
                                  label: 'Cabang Wilayah (${profitCabangPct.toStringAsFixed(0)}%)',
                                  amount: currencyFmt.format(branchShare),
                                  color: const Color(0xFFF59E0B),
                                  icon: Icons.store_mall_directory_rounded,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // MINI AUDIT CHART
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: borderSubtle),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Komposisi Alokasi Revenue',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Proyeksi pembagian pendapatan bulanan',
                                  style: TextStyle(fontSize: 11, color: textSecondary),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 210,
                                  child: BispiraDonutChart(isDark: isDark),
                                ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                 ],
               );
            },
          ),
          const SizedBox(height: 24),

          // 4. BOTTOM HISTORICAL TREND CHART
          Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tren Pendapatan & Efektivitas Skema Tarif (7 Hari Terakhir)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Korelasi antara kenaikan volume order dan kepatuhan batas tarif Kemenhub.',
                            style: TextStyle(fontSize: 12, color: textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Pertumbuhan +18.4%',
                          style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w800, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 230,
                    child: BispiraLineChart(isDark: isDark),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color cardBg,
    required Color borderSubtle,
    required Color textPrimary,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernInputField({
    required String label,
    required String helper,
    required TextEditingController controller,
    required bool isDark,
    String? prefix,
    String? suffix,
    Function(String)? onChanged,
  }) {
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final boxBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          helper,
          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w400, color: textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: boxBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderSubtle, width: 1.2),
          ),
          child: Row(
            children: [
              if (prefix != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      bottomLeft: Radius.circular(11),
                    ),
                  ),
                  child: Text(
                    prefix,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0066FF), fontSize: 13),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (suffix != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                    ),
                  ),
                  child: Text(
                    suffix,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0066FF), fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimRow(String label, String value, Color textPrimary, Color textSecondary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: textPrimary)),
      ],
    );
  }

  Widget _buildModePill(String modeKey, String label, IconData icon) {
    final isSelected = _selectedSimulatorMode == modeKey;
    return InkWell(
      onTap: () => setState(() => _selectedSimulatorMode = modeKey),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0066FF) : const Color(0xFF0066FF).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066FF) : const Color(0xFF0066FF).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : const Color(0xFF0066FF)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF0066FF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitPill({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: color),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }
}
