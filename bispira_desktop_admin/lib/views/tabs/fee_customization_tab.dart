import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class FeeCustomizationTab extends StatefulWidget {
  const FeeCustomizationTab({Key? key}) : super(key: key);

  @override
  State<FeeCustomizationTab> createState() => _FeeCustomizationTabState();
}

class _FeeCustomizationTabState extends State<FeeCustomizationTab> {
  late TextEditingController _tariffController;
  late TextEditingController _minFareController;
  late TextEditingController _appFeeController;
  late TextEditingController _serviceFeeController;
  late TextEditingController _markupController;
  late TextEditingController _disbursementFeeController;
  late TextEditingController _driverChargeController;
  late TextEditingController _ambAntarController;
  late TextEditingController _ambAngkutController;
  late TextEditingController _profitCabangController;
  late TextEditingController _uniqueTimerController;

  // Simulator distance
  double _simulatedKm = 5.0;
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    final config = Provider.of<AdminProvider>(context, listen: false).currentConfig;
    _tariffController = TextEditingController(text: config.tariffPerKm.toInt().toString());
    _minFareController = TextEditingController(text: config.minFare.toInt().toString());
    _appFeeController = TextEditingController(text: config.appFee.toInt().toString());
    _serviceFeeController = TextEditingController(text: config.serviceFee.toInt().toString());
    _markupController = TextEditingController(text: config.markupPercent.toInt().toString());
    _disbursementFeeController = TextEditingController(text: config.disbursementFee.toInt().toString());
    _driverChargeController = TextEditingController(text: config.driverChargeFee.toInt().toString());
    _ambAntarController = TextEditingController(text: config.ambulanceAntarFee.toInt().toString());
    _ambAngkutController = TextEditingController(text: config.ambulanceAngkutFee.toInt().toString());
    _profitCabangController = TextEditingController(text: config.profitShareCabang.toInt().toString());
    _uniqueTimerController = TextEditingController(text: config.uniqueCodeDurationMinutes.toString());
  }

  @override
  void dispose() {
    _tariffController.dispose();
    _minFareController.dispose();
    _appFeeController.dispose();
    _serviceFeeController.dispose();
    _markupController.dispose();
    _disbursementFeeController.dispose();
    _driverChargeController.dispose();
    _ambAntarController.dispose();
    _ambAngkutController.dispose();
    _profitCabangController.dispose();
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
    final double tariffPerKm = double.tryParse(_tariffController.text) ?? 2500;
    final double minFare = double.tryParse(_minFareController.text) ?? 8000;
    final double appFee = double.tryParse(_appFeeController.text) ?? 1000;
    final double serviceFee = double.tryParse(_serviceFeeController.text) ?? 2000;
    final double markupPct = double.tryParse(_markupController.text) ?? 10;
    final double profitCabangPct = double.tryParse(_profitCabangController.text) ?? 30;

    final double rawDistanceFare = _simulatedKm * tariffPerKm;
    final double baseTripFare = rawDistanceFare < minFare ? minFare : rawDistanceFare;
    final double markupAmount = baseTripFare * (markupPct / 100);
    final double totalConsumerPay = baseTripFare + markupAmount + appFee + serviceFee;

    final double driverGross = baseTripFare * 0.95; // 95% Driver sesuai regulasi Excel
    final double platformGross = (baseTripFare * 0.05) + markupAmount + appFee + serviceFee;
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
                          // SECTION 1: TARIF TRIP & RIDE-HAILING
                          _buildSectionCard(
                            title: '1. Parameter Perjalanan & Ride-Hailing',
                            icon: Icons.motorcycle_rounded,
                            iconColor: const Color(0xFF0066FF),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Tarif per KM (Ride Hailing)',
                                      helper: 'Tarif dasar pengantaran per kilometer',
                                      controller: _tariffController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Minimum Perjalanan',
                                      helper: 'Tarif flat perjalanan jarak dekat (< 3 KM)',
                                      controller: _minFareController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildModernInputField(
                                label: 'Persentase Markup Harga (%)',
                                helper: 'Markup margin platform pada katalog menu & produk',
                                controller: _markupController,
                                suffix: '%',
                                isDark: isDark,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // SECTION 2: BIAYA PLATFORM & OPERASIONAL
                          _buildSectionCard(
                            title: '2. Biaya Layanan Konsumen & Ekosistem',
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
                                      helper: 'Dibebankan ke user per order selesai',
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
                                      helper: 'Maintenance & infrastructure fee',
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
                                      label: 'Biaya Pencairan Penjual (Payout Fee)',
                                      helper: 'Potongan per batch disbursement 17:00 WIB',
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
                                      helper: 'Iuran bantuan driver/asuransi sesuai Excel',
                                      controller: _driverChargeController,
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

                          // SECTION 3: REVENUE SHARING CABANG & KODE UNIK
                          _buildSectionCard(
                            title: '3. Bagi Hasil Cabang & Validasi Keuangan',
                            icon: Icons.account_balance_rounded,
                            iconColor: const Color(0xFF6366F1),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Profit Share Cabang Wilayah (%)',
                                      helper: 'Bagi hasil netto untuk pemegang lisensi cabang',
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
                                      helper: 'Timer auto-cancel rekonsiliasi transfer bank',
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
                          const SizedBox(height: 18),

                          // SECTION 4: AMBULANCE SPECIAL FLEET
                          _buildSectionCard(
                            title: '4. Layanan Darurat Khusus Ambulance',
                            icon: Icons.emergency_rounded,
                            iconColor: const Color(0xFFEF4444),
                            cardBg: cardBg,
                            borderSubtle: borderSubtle,
                            textPrimary: textPrimary,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Antar Dasar Ambulance',
                                      helper: 'Tarif flat penjemputan unit ambulance',
                                      controller: _ambAntarController,
                                      prefix: 'Rp',
                                      isDark: isDark,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildModernInputField(
                                      label: 'Biaya Angkut Medis Pasien',
                                      helper: 'Biaya pendampingan nakes & peralatan',
                                      controller: _ambAngkutController,
                                      prefix: 'Rp',
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
                                      appFee: double.tryParse(_appFeeController.text) ?? 1000,
                                      serviceFee: double.tryParse(_serviceFeeController.text) ?? 2000,
                                      markupPercent: double.tryParse(_markupController.text) ?? 10,
                                      disbursementFee: double.tryParse(_disbursementFeeController.text) ?? 1000,
                                      driverChargeFee: double.tryParse(_driverChargeController.text) ?? 500,
                                      ambulanceAntarFee: double.tryParse(_ambAntarController.text) ?? 150000,
                                      ambulanceAngkutFee: double.tryParse(_ambAngkutController.text) ?? 50000,
                                      profitShareCabang: double.tryParse(_profitCabangController.text) ?? 30,
                                      uniqueCodeDurationMinutes: int.tryParse(_uniqueTimerController.text) ?? 30,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Row(
                                          children: [
                                            Icon(Icons.check_circle_rounded, color: Colors.white),
                                            SizedBox(width: 12),
                                            Text(
                                              'Konfigurasi Biaya Live Berhasil Diperbarui!',
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
                                    _appFeeController.text = '1000';
                                    _serviceFeeController.text = '2000';
                                    _markupController.text = '10';
                                    _disbursementFeeController.text = '1000';
                                    _driverChargeController.text = '500';
                                    _ambAntarController.text = '150000';
                                    _ambAngkutController.text = '50000';
                                    _profitCabangController.text = '30';
                                    _uniqueTimerController.text = '30';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Form direset ke standar default.')),
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

                  // RIGHT COLUMN: LIVE REVENUE SHARING & TRIP SIMULATOR
                  const SizedBox(width: 24),
                  Expanded(
                    flex: isWide ? 4 : 1,
                    child: Column(
                        children: [
                          // INTERACTIVE SIMULATOR CARD
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
                                            'Live Trip Calculator',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Simulasi perhitungan tarif & bagi hasil',
                                            style: TextStyle(fontSize: 11, color: textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Slider Jarak
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
                                    max: 30.0,
                                    divisions: 58,
                                    onChanged: (val) => setState(() => _simulatedKm = val),
                                  ),
                                ),
                                const Divider(height: 24),

                                // Breakdown Rincian Biaya
                                _buildSimRow('Tarif Jarak Dasar (${_simulatedKm.toStringAsFixed(1)} KM)', currencyFmt.format(baseTripFare), textPrimary, textSecondary),
                                const SizedBox(height: 8),
                                _buildSimRow('Markup Platform (${markupPct.toStringAsFixed(0)}%)', currencyFmt.format(markupAmount), textPrimary, textSecondary),
                                const SizedBox(height: 8),
                                _buildSimRow('Biaya Aplikasi', currencyFmt.format(appFee), textPrimary, textSecondary),
                                const SizedBox(height: 8),
                                _buildSimRow('Biaya Layanan', currencyFmt.format(serviceFee), textPrimary, textSecondary),
                                const SizedBox(height: 12),

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
                                const SizedBox(height: 16),

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
                                const SizedBox(height: 10),
                                _buildSplitPill(
                                  label: 'Driver (95% Ongkir Dasar)',
                                  amount: currencyFmt.format(driverGross),
                                  color: const Color(0xFF10B981),
                                  icon: Icons.two_wheeler_rounded,
                                ),
                                const SizedBox(height: 8),
                                _buildSplitPill(
                                  label: 'Pusat HQ Netto',
                                  amount: currencyFmt.format(hqNet),
                                  color: const Color(0xFF0066FF),
                                  icon: Icons.domain_rounded,
                                ),
                                const SizedBox(height: 8),
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
