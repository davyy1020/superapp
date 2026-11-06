import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';

class SaldoWalletDriverTab extends StatefulWidget {
  const SaldoWalletDriverTab({Key? key}) : super(key: key);

  @override
  State<SaldoWalletDriverTab> createState() => _SaldoWalletDriverTabState();
}

class _SaldoWalletDriverTabState extends State<SaldoWalletDriverTab> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedModaFilter = 'SEMUA';
  String _selectedStatusFilter = 'SEMUA';

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _getModaColor(String moda) {
    switch (moda.toUpperCase()) {
      case 'AMBULANCE':
        return const Color(0xFFDC2626);
      case 'FOOD':
        return const Color(0xFFEA580C);
      case 'R2':
      case 'R4':
      case 'R2 LOGISTIK':
        return NeoBrutalTheme.bispiraBlue;
      case 'TOPUP':
        return const Color(0xFF16A34A);
      case 'CICILAN':
        return const Color(0xFFD97706);
      case 'DP ATRIBUT':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF64748B);
    }
  }

  void _showTopUpDialog(BuildContext context, SaldoWalletDriverModel driver) {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    final isDark = provider.isDarkMode;
    final nominalCtrl = TextEditingController(text: '50000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_card_rounded, color: Color(0xFF16A34A), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Top-Up Saldo Driver', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text(driver.namaDriver, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Saat Ini: ${currencyFmt.format(driver.saldoAkhirWallet)}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: driver.isMinus ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Masukkan Nominal Top-Up (Min. Rp 50.000):',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nominalCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ketentuan: Biaya Layanan Rp 500, Biaya Aplikasi Rp 500, + 3 Digit Kode Unik Bank.',
              style: TextStyle(fontSize: 10.5, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final val = double.tryParse(nominalCtrl.text.trim()) ?? 0;
              if (val >= 50000) {
                provider.topUpDriverWallet(driver.namaDriver, val);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berhasil Top-Up ${currencyFmt.format(val)} ke ${driver.namaDriver}'),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Minimal Top-Up adalah Rp 50.000'),
                    backgroundColor: Color(0xFFDC2626),
                  ),
                );
              }
            },
            child: const Text('Konfirmasi Top-Up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allItems = provider.saldoWalletDriverList;
    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.namaDriver.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.modaTransportasi.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesModa = _selectedModaFilter == 'SEMUA' ||
          item.modaTransportasi.toUpperCase() == _selectedModaFilter;

      bool matchesStatus = true;
      if (_selectedStatusFilter == 'MINUS') {
        matchesStatus = item.isMinus;
      } else if (_selectedStatusFilter == 'BELOW_LIMIT') {
        matchesStatus = item.isBelowMinOrderCash && !item.isMinus;
      } else if (_selectedStatusFilter == 'READY') {
        matchesStatus = item.isReadyCash;
      }

      return matchesSearch && matchesModa && matchesStatus;
    }).toList();

    // Distinct moda
    final modas = ['SEMUA', ...allItems.map((e) => e.modaTransportasi.toUpperCase()).toSet().toList()];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1329) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER BANNER MATCHING EXCEL SHEET 3
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF2563EB)],
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
                        '3. CLUSTER AKUMULASI SALDO WALLET DRIVER BISPIRA',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Mekanisme Wallet Driver: Top-Up Saldo, Potongan Cicilan Atribut (Rp 5.000/Hari), dan Potongan Order Cash Pembeli.',
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
                      '${allItems.length} Driver Terdaftar',
                      style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. FINANCIAL KPI CARDS (6 CARDS + 1 ALERT CARD)
            Row(
              children: [
                _buildKpiCard('Total Top-Up', currencyFmt.format(provider.totalDriverTopUp), 'Inflow Saldo Driver', const Color(0xFF16A34A), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Potongan Cicilan', currencyFmt.format(provider.totalDriverPotonganCicilan), 'Atribut Rp 5.000/hari', const Color(0xFFD97706), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Potongan Order Cash', currencyFmt.format(provider.totalDriverPotonganCash), 'Tunai di Tangan Driver', const Color(0xFFEA580C), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Komisi Non-Cash', currencyFmt.format(provider.totalDriverKomisiPenghasilan), 'Penghasilan Masuk Wallet', const Color(0xFF0284C7), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Saldo Akhir Wallet', currencyFmt.format(provider.totalDriverSaldoAkhir), 'Likuiditas Tersedia', NeoBrutalTheme.bispiraBlue, isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Driver Saldo Minus', '${provider.totalDriverMinus} Driver', 'Perlu Top-Up Segera', const Color(0xFFDC2626), isDark),
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
                        hintText: 'Cari nama driver atau moda transportasi...',
                        hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // MODA FILTER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedModaFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      items: modas
                          .map((m) => DropdownMenuItem(value: m, child: Text('Moda: $m')))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedModaFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // STATUS FILTER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedStatusFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      items: const [
                        DropdownMenuItem(value: 'SEMUA', child: Text('Status: Semua')),
                        DropdownMenuItem(value: 'READY', child: Text('Status: Siap Cash (>= 10rb)')),
                        DropdownMenuItem(value: 'BELOW_LIMIT', child: Text('Status: < Rp 10.000')),
                        DropdownMenuItem(value: 'MINUS', child: Text('Status: Minus (< Rp 0)')),
                      ],
                      onChanged: (v) => setState(() => _selectedStatusFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Text(
                    'Menampilkan ${filtered.length} dari ${allItems.length} driver',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. THE 8-COLUMN MASTER WALLET TABLE (WITH HORIZONTAL SCROLLBAR)
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
                      columnSpacing: 22,
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
                        DataColumn(label: Text('Nama Driver')),
                        DataColumn(label: Text('Moda Transportasi / Logistik')),
                        DataColumn(label: Text('Total Top Up Saldo (Rp)')),
                        DataColumn(label: Text('Potongan Cicilan Atribut (Rp)')),
                        DataColumn(label: Text('Potongan Order Cash Pembeli (Rp)')),
                        DataColumn(label: Text('Komisi Non-Cash / Penghasilan (Rp)')),
                        DataColumn(label: Text('Saldo Akhir Wallet (Rp)')),
                        DataColumn(label: Text('Status & Aksi')),
                      ],
                      rows: filtered.map((item) {
                        final modaColor = _getModaColor(item.modaTransportasi);
                        final isMinus = item.isMinus;
                        final isBelowLimit = item.isBelowMinOrderCash;

                        return DataRow(
                          color: isMinus
                              ? WidgetStateProperty.all(
                                  const Color(0xFFDC2626).withValues(alpha: isDark ? 0.12 : 0.05),
                                )
                              : null,
                          cells: [
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.no <= 3 ? NeoBrutalTheme.neoGold : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#${item.no}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: item.no <= 3 ? Colors.black : (isDark ? Colors.white : Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: modaColor.withValues(alpha: 0.15),
                                    child: Icon(Icons.person_rounded, size: 14, color: modaColor),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.namaDriver,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: isMinus ? const Color(0xFFDC2626) : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: modaColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: modaColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  item.modaTransportasi,
                                  style: TextStyle(color: modaColor, fontWeight: FontWeight.w900, fontSize: 10.5),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.totalTopUp > 0 ? currencyFmt.format(item.totalTopUp) : 'Rp 0',
                                style: TextStyle(
                                  color: item.totalTopUp > 0 ? const Color(0xFF16A34A) : null,
                                  fontWeight: item.totalTopUp > 0 ? FontWeight.w800 : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.potonganCicilan > 0 ? '-${currencyFmt.format(item.potonganCicilan)}' : 'Rp 0',
                                style: TextStyle(
                                  color: item.potonganCicilan > 0 ? const Color(0xFFD97706) : null,
                                  fontWeight: item.potonganCicilan > 0 ? FontWeight.w700 : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.potonganOrderCash > 0 ? '-${currencyFmt.format(item.potonganOrderCash)}' : 'Rp 0',
                                style: TextStyle(
                                  color: item.potonganOrderCash > 0 ? const Color(0xFFEA580C) : null,
                                  fontWeight: item.potonganOrderCash > 0 ? FontWeight.w700 : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.komisiPenghasilan > 0 ? '+${currencyFmt.format(item.komisiPenghasilan)}' : 'Rp 0',
                                style: TextStyle(
                                  color: item.komisiPenghasilan > 0 ? const Color(0xFF0284C7) : null,
                                  fontWeight: item.komisiPenghasilan > 0 ? FontWeight.w800 : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyFmt.format(item.saldoAkhirWallet),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: isMinus
                                      ? const Color(0xFFDC2626)
                                      : (isBelowLimit ? const Color(0xFFD97706) : const Color(0xFF16A34A)),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isMinus
                                          ? const Color(0xFFDC2626).withValues(alpha: 0.15)
                                          : (isBelowLimit
                                              ? const Color(0xFFD97706).withValues(alpha: 0.15)
                                              : const Color(0xFF16A34A).withValues(alpha: 0.15)),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isMinus
                                            ? const Color(0xFFDC2626).withValues(alpha: 0.4)
                                            : (isBelowLimit
                                                ? const Color(0xFFD97706).withValues(alpha: 0.4)
                                                : const Color(0xFF16A34A).withValues(alpha: 0.4)),
                                      ),
                                    ),
                                    child: Text(
                                      isMinus
                                          ? 'MINUS'
                                          : (isBelowLimit ? '< Rp 10K' : 'SIAP CASH'),
                                      style: TextStyle(
                                        color: isMinus
                                            ? const Color(0xFFDC2626)
                                            : (isBelowLimit ? const Color(0xFFD97706) : const Color(0xFF16A34A)),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 9.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                                    tooltip: 'Top-Up Saldo Driver',
                                    color: NeoBrutalTheme.bispiraBlue,
                                    splashRadius: 16,
                                    onPressed: () => _showTopUpDialog(context, item),
                                  ),
                                ],
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

            // 5. STICKY TOTAL FOOTER ROW MATCHING EXCEL SHEET 3 ROW 55
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
                      Text('TOTAL WALLET DRIVER (EXCEL SHEET 3 ROW 55):', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSummaryChip('Total Top Up', 'Rp 1.750.000', const Color(0xFF16A34A)),
                      _buildSummaryChip('Potongan Cicilan', 'Rp 45.000', const Color(0xFFD97706)),
                      _buildSummaryChip('Potongan Order Cash', 'Rp 873.075', const Color(0xFFEA580C)),
                      _buildSummaryChip('Komisi Non-Cash', 'Rp 4.491.050', const Color(0xFF0284C7)),
                      _buildSummaryChip('Saldo Akhir Wallet', 'Rp 5.322.975', NeoBrutalTheme.bispiraBlue),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9.5,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

