import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';

class DetailTransaksiTab extends StatefulWidget {
  const DetailTransaksiTab({Key? key}) : super(key: key);

  @override
  State<DetailTransaksiTab> createState() => _DetailTransaksiTabState();
}

class _DetailTransaksiTabState extends State<DetailTransaksiTab> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedBankFilter = 'SEMUA';
  String _selectedPaymentFilter = 'SEMUA';

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showAddTransactionDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final buyerCtrl = TextEditingController(text: 'Davy Wahyu');
    final productCtrl = TextEditingController(text: 'Ride Hailing R2 Orang');
    final sellerCtrl = TextEditingController(text: 'Driver Budi Santoso');
    final cityCtrl = TextEditingController(text: 'Jakarta Selatan');
    final provCtrl = TextEditingController(text: 'DKI Jakarta');
    final bankCtrl = TextEditingController(text: 'BCA');
    final methodCtrl = TextEditingController(text: 'Transfer Bank');
    final basePriceCtrl = TextEditingController(text: '25000');
    final angkutCtrl = TextEditingController(text: '0');
    final komisiCtrl = TextEditingController(text: '1250');

    showDialog(
      context: context,
      builder: (dCtx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFF0F172A), width: 2),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NeoBrutalTheme.neoBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.receipt_long_rounded, color: NeoBrutalTheme.neoBlue, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                'Tambah Transaksi Ledger Real-Time',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formula otomatis mengikuti Sheet 1 Excel (Mark Up 10%, Layanan Rp 500, Aplikasi Rp 500, Kode Unik 3 Digit).',
                    style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),

                  _buildFormRow('Nama Pembeli', buyerCtrl, isDark),
                  _buildFormRow('Layanan / Produk', productCtrl, isDark),
                  _buildFormRow('Penjual / Driver', sellerCtrl, isDark),
                  _buildFormRow('Kabupaten / Kota', cityCtrl, isDark),
                  _buildFormRow('Provinsi', provCtrl, isDark),
                  _buildFormRow('Bank Target', bankCtrl, isDark),
                  _buildFormRow('Metode Bayar (Transfer Bank/QRIS/Cash)', methodCtrl, isDark),
                  _buildFormRow('Harga Dasar Layanan (Rp)', basePriceCtrl, isDark, isNumber: true),
                  _buildFormRow('Biaya Angkut / Porter (Rp)', angkutCtrl, isDark, isNumber: true),
                  _buildFormRow('Komisi Marketplace (Rp)', komisiCtrl, isDark, isNumber: true),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dCtx),
              child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w700)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoBrutalTheme.neoBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              onPressed: () {
                final double basePrice = double.tryParse(basePriceCtrl.text) ?? 20000;
                final double angkut = double.tryParse(angkutCtrl.text) ?? 0;
                final double komisi = double.tryParse(komisiCtrl.text) ?? 1000;
                final String method = methodCtrl.text.trim();

                // Compute exact sheet 1 formulas
                final double markup = (productCtrl.text.toLowerCase().contains('top up')) ? 0.0 : (basePrice * 0.10);
                final double hargaResmi = basePrice + markup;
                const double layanan = 500.0;
                const double aplikasi = 500.0;
                final int kodeUnik = (method.toLowerCase().contains('cash')) ? 0 : (100 + Random().nextInt(899));
                final double totalBayar = hargaResmi + layanan + aplikasi + angkut + kodeUnik;
                final double hakPenjual = basePrice + angkut - komisi;
                final double pusatNet = markup + layanan + aplikasi + komisi + kodeUnik;

                final now = DateTime.now();
                final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

                final newTx = DetailTransaksiModel(
                  no: provider.ledgerTransactions.length + 1,
                  tanggal: dateStr,
                  jamWib: timeStr,
                  namaPembeli: buyerCtrl.text.trim(),
                  layananProduk: productCtrl.text.trim(),
                  penjualMerchantDriver: sellerCtrl.text.trim(),
                  wilayahKabKota: cityCtrl.text.trim(),
                  provinsi: provCtrl.text.trim(),
                  bank: bankCtrl.text.trim(),
                  metodeBayar: method,
                  hargaDasar: basePrice,
                  markup10: markup,
                  hargaResmi: hargaResmi,
                  biayaLayanan: layanan,
                  biayaAplikasi: aplikasi,
                  biayaAngkut: angkut,
                  kodeUnikBank: kodeUnik,
                  totalBayarPembeli: totalBayar,
                  komisiMarketplace: komisi,
                  hakPenjualDriverNet: hakPenjual,
                  pusatNetProfit: pusatNet,
                );

                provider.addLedgerTransaction(newTx);
                Navigator.pop(dCtx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: NeoBrutalTheme.neoGreen,
                    content: Text('✅ Transaksi #${newTx.no} berhasil ditambahkan ke Ledger Real-Time!'),
                  ),
                );
              },
              child: const Text('Simpan Transaksi ⚡', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormRow(String label, TextEditingController ctrl, bool isDark, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155))),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allTxs = provider.ledgerTransactions;
    final filtered = allTxs.where((tx) {
      final matchesSearch = _searchQuery.isEmpty ||
          tx.namaPembeli.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.layananProduk.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.penjualMerchantDriver.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.wilayahKabKota.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesBank = _selectedBankFilter == 'SEMUA' || tx.bank.toUpperCase() == _selectedBankFilter;
      final matchesPayment = _selectedPaymentFilter == 'SEMUA' || tx.metodeBayar.toUpperCase().contains(_selectedPaymentFilter);

      return matchesSearch && matchesBank && matchesPayment;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1329) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER BANNER MATCHING EXCEL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0052CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0F172A), width: 2),
                boxShadow: const [BoxShadow(color: Color(0xFF0F172A), offset: Offset(4, 4), blurRadius: 0)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM',
                        style: TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '1. Detail Transaksi Real-Time & Ledger Multiguna 2026',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Format 21 Kolom Finansial Terpadu: Harga Dasar, Mark Up, Layanan, Angkut, Kode Unik, Komisi, Net Penjual, & Net Pusat.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddTransactionDialog(context, provider, isDark),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Input Transaksi Real-Time', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeoBrutalTheme.neoGold,
                      foregroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. FINANCIAL KPI CARDS
            Row(
              children: [
                _buildKpiCard('Total Transaksi', '${provider.ledgerTransactions.length}', 'Record Aktif Ledger', NeoBrutalTheme.neoBlue, isDark),
                const SizedBox(width: 14),
                _buildKpiCard('Total Bayar Pembeli', currencyFmt.format(provider.totalLedgerBayarPembeli), 'Gross Masuk Platform', NeoBrutalTheme.neoGreen, isDark),
                const SizedBox(width: 14),
                _buildKpiCard('Hak Penjual / Driver Net', currencyFmt.format(provider.totalLedgerHakPenjual), 'Disbursement Merchant/Driver', const Color(0xFFEA580C), isDark),
                const SizedBox(width: 14),
                _buildKpiCard('Pusat Net Profit', currencyFmt.format(provider.totalLedgerPusatNet), 'Fee + Mark Up + Komisi', const Color(0xFF9333EA), isDark),
              ],
            ),
            const SizedBox(height: 20),

            // 3. SEARCH & FILTER TOOLBAR
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Cari nama pembeli, layanan, merchant, atau kota...',
                        hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // BANK FILTER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedBankFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      items: ['SEMUA', 'BRI', 'BCA', 'BNI', 'BANK MANDIRI', 'BSI', 'BANK JATENG', 'BANK JATIM', 'CASH']
                          .map((b) => DropdownMenuItem(value: b, child: Text('Bank: $b')))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBankFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // PAYMENT METHOD FILTER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedPaymentFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      items: ['SEMUA', 'TRANSFER BANK', 'QRIS', 'CASH']
                          .map((m) => DropdownMenuItem(value: m, child: Text('Metode: $m')))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedPaymentFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Text(
                    'Menampilkan ${filtered.length} dari ${provider.ledgerTransactions.length} transaksi',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. THE 21-COLUMN MASTER LEDGER TABLE (WITH HORIZONTAL SCROLLBAR)
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Scrollbar(
                  controller: _horizontalScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      ),
                      dataRowColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.hovered)) {
                          return isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFE2E8F0);
                        }
                        return isDark ? const Color(0xFF1E293B) : Colors.white;
                      }),
                      columnSpacing: 16,
                      horizontalMargin: 16,
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: 0.5,
                      ),
                      dataTextStyle: TextStyle(
                        fontSize: 11,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                        fontWeight: FontWeight.w600,
                      ),
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Jam WIB')),
                        DataColumn(label: Text('Nama Pembeli')),
                        DataColumn(label: Text('Layanan / Produk')),
                        DataColumn(label: Text('Penjual / Merchant / Driver')),
                        DataColumn(label: Text('Wilayah Kab/Kota')),
                        DataColumn(label: Text('Provinsi')),
                        DataColumn(label: Text('Bank')),
                        DataColumn(label: Text('Metode Bayar')),
                        DataColumn(label: Text('Harga Dasar (Rp)')),
                        DataColumn(label: Text('Mark Up 10% (Rp)')),
                        DataColumn(label: Text('Harga Resmi (Rp)')),
                        DataColumn(label: Text('Biaya Layanan')),
                        DataColumn(label: Text('Biaya Aplikasi')),
                        DataColumn(label: Text('Biaya Angkut')),
                        DataColumn(label: Text('Kode Unik')),
                        DataColumn(label: Text('Total Bayar Pembeli')),
                        DataColumn(label: Text('Komisi Marketplace')),
                        DataColumn(label: Text('Hak Penjual / Driver')),
                        DataColumn(label: Text('Pusat Net Profit')),
                      ],
                      rows: filtered.map((tx) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: tx.no == 1 ? NeoBrutalTheme.neoGold : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#${tx.no}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: tx.no == 1 ? Colors.black : (isDark ? Colors.white : Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(tx.tanggal)),
                            DataCell(Text(tx.jamWib)),
                            DataCell(Text(tx.namaPembeli, style: const TextStyle(fontWeight: FontWeight.w700))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: NeoBrutalTheme.neoBlue.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(tx.layananProduk, style: TextStyle(color: NeoBrutalTheme.neoBlue, fontWeight: FontWeight.w800)),
                              ),
                            ),
                            DataCell(Text(tx.penjualMerchantDriver)),
                            DataCell(Text(tx.wilayahKabKota)),
                            DataCell(Text(tx.provinsi)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(tx.bank, style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w800)),
                              ),
                            ),
                            DataCell(Text(tx.metodeBayar)),
                            DataCell(Text(currencyFmt.format(tx.hargaDasar))),
                            DataCell(Text(currencyFmt.format(tx.markup10))),
                            DataCell(Text(currencyFmt.format(tx.hargaResmi), style: const TextStyle(fontWeight: FontWeight.w700))),
                            DataCell(Text(currencyFmt.format(tx.biayaLayanan))),
                            DataCell(Text(currencyFmt.format(tx.biayaAplikasi))),
                            DataCell(Text(currencyFmt.format(tx.biayaAngkut))),
                            DataCell(
                              Text(
                                tx.kodeUnikBank > 0 ? '+${tx.kodeUnikBank}' : '-',
                                style: TextStyle(fontWeight: FontWeight.w800, color: NeoBrutalTheme.neoBlue),
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyFmt.format(tx.totalBayarPembeli),
                                style: TextStyle(fontWeight: FontWeight.w900, color: NeoBrutalTheme.neoBlue),
                              ),
                            ),
                            DataCell(Text(currencyFmt.format(tx.komisiMarketplace))),
                            DataCell(
                              Text(
                                currencyFmt.format(tx.hakPenjualDriverNet),
                                style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFEA580C)),
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyFmt.format(tx.pusatNetProfit),
                                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF16A34A)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. STICKY TOTAL FOOTER ROW (FROM EXCEL SUMMARY)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.functions_rounded, color: NeoBrutalTheme.neoGold, size: 20),
                      const SizedBox(width: 8),
                      const Text('TOTAL SUMMARY REKAPITULASI (EXCEL SHEET 1):', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSummaryChip('Total Bayar', 'Rp 34.697.422', NeoBrutalTheme.neoBlue),
                      const SizedBox(width: 10),
                      _buildSummaryChip('Hak Penjual/Driver', 'Rp 30.342.050', const Color(0xFFEA580C)),
                      const SizedBox(width: 10),
                      _buildSummaryChip('Pusat Net Profit', 'Rp 4.355.372', const Color(0xFF16A34A)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          Text(value, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A))),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 10.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
          ],
        ),
      ),
    );
  }
}
