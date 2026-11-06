import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';

class AkumulasiDanaPencairanTab extends StatefulWidget {
  const AkumulasiDanaPencairanTab({Key? key}) : super(key: key);

  @override
  State<AkumulasiDanaPencairanTab> createState() => _AkumulasiDanaPencairanTabState();
}

class _AkumulasiDanaPencairanTabState extends State<AkumulasiDanaPencairanTab> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedBankFilter = 'SEMUA';
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
    return const Color(0xFF64748B);
  }

  void _showBatchPayoutConfirmDialog(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    final isDark = provider.isDarkMode;

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
                color: const Color(0xFF059669).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flash_on_rounded, color: Color(0xFF059669), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Eksekusi Batch Payout Massal', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text('Jadwal: Senin & Kamis (17.00 - 23.59 WIB)', style: TextStyle(fontSize: 11.5, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anda akan mentransfer dana pencairan ke seluruh 68 mitra sekaligus melalui BI-FAST host-to-host.',
              style: TextStyle(fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Hak Gross:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(currencyFmt.format(provider.totalPencairanGross), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biaya Layanan Trx (Rp 500):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('-${currencyFmt.format(provider.totalPencairanBiayaLayananTrx)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFFEA580C))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biaya Transfer Pencairan (Rp 1.000):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('-${currencyFmt.format(provider.totalPencairanBiayaTransfer)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFFEA580C))),
                    ],
                  ),
                  const Divider(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Net Ditransfer:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                      Text(currencyFmt.format(provider.totalPencairanNetDiterima), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF059669))),
                    ],
                  ),
                ],
              ),
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
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              provider.executeBatchPayoutAll();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⚡ Batch Payout Massal berhasil dieksekusi! Seluruh rekening mitra telah ditransfer.'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            child: const Text('Eksekusi Sekarang ⚡'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allItems = provider.danaPencairanList;
    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.namaPenjualDriver.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.bankTujuan.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesBank = _selectedBankFilter == 'SEMUA' ||
          item.bankTujuan.toUpperCase() == _selectedBankFilter;

      bool matchesStatus = true;
      if (_selectedStatusFilter == 'PENDING') {
        matchesStatus = !item.isDisbursed;
      } else if (_selectedStatusFilter == 'DISBURSED') {
        matchesStatus = item.isDisbursed;
      }

      return matchesSearch && matchesBank && matchesStatus;
    }).toList();

    final banks = ['SEMUA', ...allItems.map((e) => e.bankTujuan.toUpperCase()).toSet()];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1329) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER BANNER MATCHING EXCEL SHEET 5
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF047857), Color(0xFF10B981)],
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
                        '5. AKUMULASI DANA PENCAIRAN DANA PER PENJUAL, MERCHANT & DRIVER',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Jadwal Cair: Senin & Kamis (17.00 - 23.59 WIB) | Biaya Transfer Pencairan: Rp 1.000 per transaksi pencairan.',
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
                      '${allItems.length} Mitra Penerima',
                      style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. FINANCIAL KPI CARDS (6 METRIC CARDS)
            Row(
              children: [
                _buildKpiCard('Total Hak Gross', currencyFmt.format(provider.totalPencairanGross), 'Gross Sheet 2', const Color(0xFF0284C7), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Biaya Layanan Trx', currencyFmt.format(provider.totalPencairanBiayaLayananTrx), 'Rp 500 / Trx', const Color(0xFFD97706), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Biaya Transfer Pencairan', currencyFmt.format(provider.totalPencairanBiayaTransfer), 'Rp 1.000 / Transfer', const Color(0xFFEA580C), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Jumlah Net Diterima', currencyFmt.format(provider.totalPencairanNetDiterima), 'Dana Cair ke Rekening', const Color(0xFF16A34A), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Status Escrow', '${provider.totalPencairanPending} Pending', 'Ready to Disburse', const Color(0xFF059669), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Sudah Ditransfer', '${provider.totalPencairanDisbursed} Mitra', 'Transfer Sukses', NeoBrutalTheme.bispiraBlue, isDark),
              ],
            ),
            const SizedBox(height: 20),

            // 3. SEARCH, FILTER & BATCH ACTION TOOLBAR
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
                        hintText: 'Cari nama penjual, driver, atau bank tujuan...',
                        hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

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
                      items: banks
                          .map((b) => DropdownMenuItem(value: b, child: Text('Bank: $b')))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBankFilter = v ?? 'SEMUA'),
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
                        DropdownMenuItem(value: 'PENDING', child: Text('Status: Ready Escrow')),
                        DropdownMenuItem(value: 'DISBURSED', child: Text('Status: Sudah Ditransfer')),
                      ],
                      onChanged: (v) => setState(() => _selectedStatusFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // BATCH PAYOUT BUTTON
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _showBatchPayoutConfirmDialog(context),
                    icon: const Icon(Icons.flash_on_rounded, size: 16),
                    label: const Text(
                      'Eksekusi Batch Payout ⚡',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. THE 8-COLUMN MASTER DISBURSEMENT TABLE (WITH HORIZONTAL SCROLLBAR)
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
                        DataColumn(label: Text('Nama Penjual / Driver')),
                        DataColumn(label: Text('Bank Tujuan')),
                        DataColumn(label: Text('Total Hak Penjual Gross (Rp)')),
                        DataColumn(label: Text('Biaya Layanan Trx Rp 500 (Rp)')),
                        DataColumn(label: Text('Biaya Pencairan Rp 1.000 (Rp)')),
                        DataColumn(label: Text('Jumlah Net Diterima Penjual (Rp)')),
                        DataColumn(label: Text('Status Escrow & Aksi')),
                      ],
                      rows: filtered.map((item) {
                        final bankColor = _getBankColor(item.bankTujuan);
                        final isDisbursed = item.isDisbursed;

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
                                    backgroundColor: (item.isDriver ? const Color(0xFF0284C7) : const Color(0xFFEA580C)).withValues(alpha: 0.15),
                                    child: Icon(
                                      item.isDriver ? Icons.two_wheeler_rounded : Icons.storefront_rounded,
                                      size: 14,
                                      color: item.isDriver ? const Color(0xFF0284C7) : const Color(0xFFEA580C),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.namaPenjualDriver,
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: bankColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: bankColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  item.bankTujuan,
                                  style: TextStyle(color: bankColor, fontWeight: FontWeight.w900, fontSize: 10.5),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyFmt.format(item.totalHakGross),
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                            DataCell(
                              Text(
                                '-${currencyFmt.format(item.biayaLayananTrx)}',
                                style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataCell(
                              Text(
                                '-${currencyFmt.format(item.biayaPencairan)}',
                                style: const TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyFmt.format(item.jumlahNetDiterima),
                                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF16A34A), fontSize: 12),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDisbursed
                                          ? NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.15)
                                          : const Color(0xFF16A34A).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isDisbursed
                                            ? NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.4)
                                            : const Color(0xFF16A34A).withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      isDisbursed ? 'SUDAH DITRANSFER' : 'READY TO DISBURSE',
                                      style: TextStyle(
                                        color: isDisbursed ? NeoBrutalTheme.bispiraBlue : const Color(0xFF16A34A),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 9.5,
                                      ),
                                    ),
                                  ),
                                  if (!isDisbursed) ...[
                                    const SizedBox(width: 6),
                                    IconButton(
                                      icon: const Icon(Icons.send_rounded, size: 15),
                                      tooltip: 'Transfer Dana ke Rekening',
                                      color: const Color(0xFF059669),
                                      splashRadius: 16,
                                      onPressed: () {
                                        provider.disburseSingleMitra(item.no);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Dana ${currencyFmt.format(item.jumlahNetDiterima)} berhasil ditransfer ke ${item.namaPenjualDriver} (${item.bankTujuan})'),
                                            backgroundColor: const Color(0xFF059669),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
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

            // 5. STICKY TOTAL FOOTER ROW MATCHING EXCEL SHEET 5 ROW 73
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
                      Text('TOTAL PENCAIRAN (EXCEL SHEET 5 ROW 73):', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSummaryChip('Total Hak Gross', 'Rp 30.342.050', const Color(0xFF0284C7)),
                      _buildSummaryChip('Biaya Layanan Trx', 'Rp 62.500', const Color(0xFFD97706)),
                      _buildSummaryChip('Biaya Transfer', 'Rp 68.000', const Color(0xFFEA580C)),
                      _buildSummaryChip('Net Diterima Penjual', 'Rp 30.211.550', const Color(0xFF16A34A)),
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

