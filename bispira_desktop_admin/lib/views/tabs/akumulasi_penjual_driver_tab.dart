import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';

class AkumulasiPenjualDriverTab extends StatefulWidget {
  const AkumulasiPenjualDriverTab({Key? key}) : super(key: key);

  @override
  State<AkumulasiPenjualDriverTab> createState() => _AkumulasiPenjualDriverTabState();
}

class _AkumulasiPenjualDriverTabState extends State<AkumulasiPenjualDriverTab> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedCategoryFilter = 'SEMUA';

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String cat) {
    switch (cat.toUpperCase()) {
      case 'AMBULANCE':
        return const Color(0xFFDC2626);
      case 'FOOD':
        return const Color(0xFFEA580C);
      case 'EDUKASI':
        return const Color(0xFF9333EA);
      case 'SERVICE':
        return const Color(0xFF0284C7);
      case 'R2':
      case 'R4':
        return NeoBrutalTheme.bispiraBlue;
      case 'TOPUP':
        return const Color(0xFF16A34A);
      case 'CICILAN':
      case 'DP ATRIBUT':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF475569);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allItems = provider.akumulasiList;
    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.namaPenjualMerchantDriver.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.kategoriBisnis.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategoryFilter == 'SEMUA' ||
          item.kategoriBisnis.toUpperCase() == _selectedCategoryFilter;

      return matchesSearch && matchesCategory;
    }).toList();

    // Distinct categories for filter
    final categories = ['SEMUA', ...allItems.map((e) => e.kategoriBisnis.toUpperCase()).toSet().toList()];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1329) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER BANNER MATCHING EXCEL SHEET 2
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF065F46), Color(0xFF059669)],
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
                        style: TextStyle(color: Color(0xFFA7F3D0), fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2. Akumulasi Penjualan per Penjual, Merchant & Driver',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Rekapitulasi Hak Gross Mitra, Biaya Angkut, Potongan Komisi, dan Biaya Skema Transaksi (Rp 500/Trx).',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: NeoBrutalTheme.neoGold,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
                    ),
                    child: Text(
                      '${allItems.length} Mitra Terdaftar',
                      style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. FINANCIAL KPI CARDS (6 CARDS IN 2 ROWS OR 1 ROW)
            Row(
              children: [
                _buildKpiCard('Total Mitra', '${provider.totalAkumulasiMitra}', 'Penjual & Driver', NeoBrutalTheme.bispiraBlue, isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Total Trx', '${provider.totalAkumulasiTrx}', 'Frekuensi Order', const Color(0xFF059669), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Akumulasi Dasar', currencyFmt.format(provider.totalAkumulasiHargaDasar), 'Omzet Bersih Mitra', const Color(0xFF0284C7), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Hak Gross Mitra', currencyFmt.format(provider.totalHakPenjualGross), 'Dasar + Angkut - Komisi', const Color(0xFFEA580C), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Komisi Platform', currencyFmt.format(provider.totalAkumulasiKomisi), 'Porsi Bagi Hasil', const Color(0xFF9333EA), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Skema Trx Driver', currencyFmt.format(provider.totalBiayaSkemaTrx), 'Total Rp 500 / Trx', const Color(0xFFD97706), isDark),
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
                        hintText: 'Cari nama merchant, driver, atau kategori bisnis...',
                        hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // CATEGORY FILTER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCategoryFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      items: categories
                          .map((cat) => DropdownMenuItem(value: cat, child: Text('Kategori: $cat')))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCategoryFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Text(
                    'Menampilkan ${filtered.length} dari ${allItems.length} mitra',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. THE 9-COLUMN MASTER AKUMULASI TABLE (WITH HORIZONTAL SCROLLBAR)
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
                      columnSpacing: 20,
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
                        DataColumn(label: Text('Nama Penjual / Merchant / Driver')),
                        DataColumn(label: Text('Kategori Bisnis')),
                        DataColumn(label: Text('Total Trx')),
                        DataColumn(label: Text('Akumulasi Harga Dasar (Rp)')),
                        DataColumn(label: Text('Akumulasi Biaya Angkut (Rp)')),
                        DataColumn(label: Text('Akumulasi Komisi Marketplace (Rp)')),
                        DataColumn(label: Text('Hak Penjual / Driver Gross (Rp)')),
                        DataColumn(label: Text('Biaya Skema Trx / Bulanan (Rp)')),
                      ],
                      rows: filtered.map((item) {
                        final catColor = _getCategoryColor(item.kategoriBisnis);
                        return DataRow(
                          cells: [
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.no == 1 ? NeoBrutalTheme.neoGold : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#${item.no}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: item.no == 1 ? Colors.black : (isDark ? Colors.white : Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.namaPenjualMerchantDriver,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: catColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  item.kategoriBisnis,
                                  style: TextStyle(color: catColor, fontWeight: FontWeight.w900, fontSize: 10.5),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${item.totalTrx} Trx',
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            DataCell(Text(currencyFmt.format(item.akumulasiHargaDasar))),
                            DataCell(
                              Text(
                                item.akumulasiBiayaAngkut > 0 ? currencyFmt.format(item.akumulasiBiayaAngkut) : 'Rp 0',
                                style: TextStyle(color: item.akumulasiBiayaAngkut > 0 ? const Color(0xFF059669) : null),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.akumulasiKomisiMarketplace > 0 ? currencyFmt.format(item.akumulasiKomisiMarketplace) : 'Rp 0',
                                style: const TextStyle(color: Color(0xFF9333EA), fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyFmt.format(item.hakPenjualDriverGross),
                                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFEA580C)),
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyFmt.format(item.biayaSkemaTrxBulanan),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                ),
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

            // 5. STICKY TOTAL FOOTER ROW MATCHING EXCEL SHEET 2 ROW 73
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
                  const Row(
                    children: [
                      Icon(Icons.functions_rounded, color: NeoBrutalTheme.neoGold, size: 20),
                      SizedBox(width: 8),
                      Text('TOTAL AKUMULASI MITRA (EXCEL SHEET 2 ROW 73):', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSummaryChip('Total Trx', '125', const Color(0xFF059669)),
                      _buildSummaryChip('Harga Dasar', 'Rp 31.280.000', const Color(0xFF0284C7)),
                      _buildSummaryChip('Biaya Angkut', 'Rp 521.000', const Color(0xFF10B981)),
                      _buildSummaryChip('Komisi Platform', 'Rp 1.458.950', const Color(0xFF9333EA)),
                      _buildSummaryChip('Hak Gross Mitra', 'Rp 30.342.050', const Color(0xFFEA580C)),
                      _buildSummaryChip('Biaya Skema Trx', 'Rp 62.500', const Color(0xFFD97706)),
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
        padding: const EdgeInsets.all(16),
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
                Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A))),
            const SizedBox(height: 3),
            Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
          ],
        ),
      ),
    );
  }
}

