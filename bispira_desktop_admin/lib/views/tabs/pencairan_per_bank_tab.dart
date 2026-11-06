import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';

class PencairanPerBankTab extends StatefulWidget {
  const PencairanPerBankTab({Key? key}) : super(key: key);

  @override
  State<PencairanPerBankTab> createState() => _PencairanPerBankTabState();
}

class _PencairanPerBankTabState extends State<PencairanPerBankTab> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedStatusFilter = 'SEMUA';

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _getBankColor(String bank) {
    final b = bank.toUpperCase();
    if (b.contains('BCA')) return const Color(0xFF0066CC);
    if (b.contains('MANDIRI')) return const Color(0xFF003366);
    if (b.contains('BRI')) return const Color(0xFF00529C);
    if (b.contains('BNI')) return const Color(0xFFF15A24);
    if (b.contains('BSI')) return const Color(0xFF00A39D);
    if (b.contains('JATENG')) return const Color(0xFFDC2626);
    if (b.contains('JATIM')) return const Color(0xFF16A34A);
    if (b.contains('DKI')) return const Color(0xFFEA580C);
    if (b.contains('BJB')) return const Color(0xFF2563EB);
    if (b.contains('BTN')) return const Color(0xFF0284C7);
    if (b.contains('DIY')) return const Color(0xFF4F46E5);
    if (b.contains('BANTEN')) return const Color(0xFF9333EA);
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allItems = provider.pencairanPerBankList;
    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.namaBank.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesStatus = true;
      if (_selectedStatusFilter == 'AKTIF') {
        matchesStatus = item.isActive;
      } else if (_selectedStatusFilter == 'STANDBY') {
        matchesStatus = !item.isActive;
      }

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1329) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER BANNER MATCHING EXCEL SHEET 6
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
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
                        style: TextStyle(color: Color(0xFFBFDBFE), fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '6. REKAPITULASI AKUMULASI PENCAIRAN DANA PER BANK OPERASIONAL SUPERADMIN',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Konsolidasi Arus Kas Keluar per Bank Operasional (9 Bank Aktif, 3 Bank Cadangan) untuk Rekonsiliasi Rekening Giro Superadmin.',
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
                      '${allItems.length} Bank Operasional',
                      style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. FINANCIAL KPI CARDS (5 METRIC CARDS)
            Row(
              children: [
                _buildKpiCard('Net Disbursement', currencyFmt.format(provider.totalBankNetDisbursement), 'Kas Keluar Bersih', const Color(0xFF16A34A), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Total Gross', currencyFmt.format(provider.totalBankGrossDisbursement), 'Total Omzet Mitra', const Color(0xFF0284C7), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Biaya Trx Rp 500', currencyFmt.format(provider.totalBankBiayaTrx), 'Total Biaya Sistem', const Color(0xFFD97706), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Biaya Transfer Rp 1.000', currencyFmt.format(provider.totalBankBiayaTransfer), 'Admin Gateway Bank', const Color(0xFFEA580C), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Bank Terbesar', 'Bank BJB', 'Rp 9.549.475 (7 Mitra)', const Color(0xFF2563EB), isDark),
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
                        hintText: 'Cari nama bank operasional...',
                        hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
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
                        DropdownMenuItem(value: 'SEMUA', child: Text('Status: Semua (12 Bank)')),
                        DropdownMenuItem(value: 'AKTIF', child: Text('Status: Bank Aktif (> 0 Mitra)')),
                        DropdownMenuItem(value: 'STANDBY', child: Text('Status: Cadangan (0 Mitra)')),
                      ],
                      onChanged: (v) => setState(() => _selectedStatusFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Text(
                    'Menampilkan ${filtered.length} dari ${allItems.length} bank',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. THE 7-COLUMN MASTER BANK TABLE (WITH HORIZONTAL SCROLLBAR)
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
                        DataColumn(label: Text('Nama Bank Superadmin')),
                        DataColumn(label: Text('Jumlah Mitra / Penjual')),
                        DataColumn(label: Text('Total Pencairan Gross (Rp)')),
                        DataColumn(label: Text('Total Biaya Layanan Trx (Rp)')),
                        DataColumn(label: Text('Total Biaya Pencairan Rp 1.000 (Rp)')),
                        DataColumn(label: Text('Net Inflow / Disbursement (Rp)')),
                        DataColumn(label: Text('Status Bank Operasional')),
                      ],
                      rows: filtered.map((item) {
                        final bankColor = _getBankColor(item.namaBank);
                        final isActive = item.isActive;

                        return DataRow(
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
                                    backgroundColor: bankColor.withValues(alpha: 0.15),
                                    child: Icon(Icons.account_balance_rounded, size: 14, color: bankColor),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.namaBank,
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? bankColor.withValues(alpha: 0.12)
                                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${item.jumlahMitra} Mitra',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: isActive ? bankColor : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.totalPencairanGross > 0 ? currencyFmt.format(item.totalPencairanGross) : 'Rp 0',
                                style: TextStyle(
                                  fontWeight: item.totalPencairanGross > 0 ? FontWeight.w800 : null,
                                  color: item.totalPencairanGross > 0 ? null : Colors.grey,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.totalBiayaLayananTrx > 0 ? '-${currencyFmt.format(item.totalBiayaLayananTrx)}' : 'Rp 0',
                                style: TextStyle(
                                  color: item.totalBiayaLayananTrx > 0 ? const Color(0xFFD97706) : Colors.grey,
                                  fontWeight: item.totalBiayaLayananTrx > 0 ? FontWeight.w700 : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.totalBiayaPencairan > 0 ? '-${currencyFmt.format(item.totalBiayaPencairan)}' : 'Rp 0',
                                style: TextStyle(
                                  color: item.totalBiayaPencairan > 0 ? const Color(0xFFEA580C) : Colors.grey,
                                  fontWeight: item.totalBiayaPencairan > 0 ? FontWeight.w700 : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                item.netDisbursement > 0 ? currencyFmt.format(item.netDisbursement) : 'Rp 0',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: item.netDisbursement > 0 ? const Color(0xFF16A34A) : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF16A34A).withValues(alpha: 0.15)
                                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isActive
                                        ? const Color(0xFF16A34A).withValues(alpha: 0.4)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  isActive ? 'BANK AKTIF' : 'CADANGAN / STANDBY',
                                  style: TextStyle(
                                    color: isActive ? const Color(0xFF16A34A) : Colors.grey,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9.5,
                                  ),
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

            // 5. STICKY TOTAL FOOTER ROW MATCHING EXCEL SHEET 6 ROW 17
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
                      Text('TOTAL PER BANK (EXCEL SHEET 6 ROW 17):', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSummaryChip('Total Mitra', '${provider.totalBankMitra} Mitra', const Color(0xFF059669)),
                      _buildSummaryChip('Total Gross', 'Rp 30.342.050', const Color(0xFF0284C7)),
                      _buildSummaryChip('Biaya Layanan Trx', 'Rp 62.500', const Color(0xFFD97706)),
                      _buildSummaryChip('Biaya Pencairan', 'Rp 68.000', const Color(0xFFEA580C)),
                      _buildSummaryChip('Net Disbursement', 'Rp 30.211.550', const Color(0xFF16A34A)),
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

