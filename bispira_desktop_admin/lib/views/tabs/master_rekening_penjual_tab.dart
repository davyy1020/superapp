import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';

class MasterRekeningPenjualTab extends StatefulWidget {
  const MasterRekeningPenjualTab({Key? key}) : super(key: key);

  @override
  State<MasterRekeningPenjualTab> createState() => _MasterRekeningPenjualTabState();
}

class _MasterRekeningPenjualTabState extends State<MasterRekeningPenjualTab> {
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedBankFilter = 'SEMUA';
  String _selectedKategoriFilter = 'SEMUA';

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

  Color _getKategoriColor(String kat) {
    final k = kat.toUpperCase();
    if (k.contains('AMBULANCE')) return const Color(0xFFDC2626);
    if (k.contains('FOOD')) return const Color(0xFFEA580C);
    if (k.contains('EDUKASI')) return const Color(0xFF9333EA);
    if (k.contains('SERVICE')) return const Color(0xFF0284C7);
    if (k.contains('R2') || k.contains('R4')) return NeoBrutalTheme.bispiraBlue;
    if (k.contains('TOPUP')) return const Color(0xFF16A34A);
    if (k.contains('CICILAN')) return const Color(0xFFD97706);
    if (k.contains('DP ATRIBUT')) return const Color(0xFF8B5CF6);
    if (k.contains('DONASI')) return const Color(0xFFE11D48);
    return const Color(0xFF475569);
  }

  void _showEditRekeningDialog(BuildContext context, MasterRekeningPenjualModel item) {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    final isDark = provider.isDarkMode;

    final bankCtrl = TextEditingController(text: item.namaBank);
    final rekCtrl = TextEditingController(text: item.nomorRekening);
    final pemilikCtrl = TextEditingController(text: item.namaPemilik);
    final cabangCtrl = TextEditingController(text: item.cabangKota);

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
                color: NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit_note_rounded, color: NeoBrutalTheme.bispiraBlue, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Perbarui Rekening Mitra', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text(item.namaTokoWarungDriver, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Bank:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              TextField(
                controller: bankCtrl,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Nomor Rekening:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              TextField(
                controller: rekCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Nama Pemilik Rekening:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              TextField(
                controller: pemilikCtrl,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Cabang / Kota:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              TextField(
                controller: cabangCtrl,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: NeoBrutalTheme.bispiraBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              provider.updateMasterRekening(
                item.no,
                namaBank: bankCtrl.text.trim(),
                nomorRekening: rekCtrl.text.trim(),
                namaPemilik: pemilikCtrl.text.trim(),
                cabangKota: cabangCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rekening #${item.no} (${item.namaTokoWarungDriver}) berhasil diperbarui.'),
                  backgroundColor: const Color(0xFF16A34A),
                ),
              );
            },
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label ($text) berhasil disalin ke clipboard 📋'),
        backgroundColor: const Color(0xFF16A34A),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allItems = provider.masterRekeningList;
    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.namaTokoWarungDriver.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.namaPemilik.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.nomorRekening.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.namaBank.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesBank = _selectedBankFilter == 'SEMUA' ||
          item.namaBank.toUpperCase() == _selectedBankFilter;

      final matchesKategori = _selectedKategoriFilter == 'SEMUA' ||
          item.kategoriEntitas.toUpperCase() == _selectedKategoriFilter;

      return matchesSearch && matchesBank && matchesKategori;
    }).toList();

    final banks = ['SEMUA', ...allItems.map((e) => e.namaBank.toUpperCase()).toSet()];
    final kategoris = ['SEMUA', ...allItems.map((e) => e.kategoriEntitas.toUpperCase()).toSet()];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1329) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER BANNER MATCHING EXCEL SHEET 4
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
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
                        style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '4. CLUSTER MASTER REKENING TOKO / WARUNG / MERCHANT / DRIVER',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Direktori Master Rekening Bank Operasional Mitra untuk Rekonsiliasi, Validasi Mutasi, dan Batch Payout Harian.',
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
                      '${allItems.length} Master Rekening',
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
                _buildKpiCard('Total Rekening', '${provider.totalMasterRekening}', 'Mitra Aktif Terdaftar', NeoBrutalTheme.bispiraBlue, isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Bank Operasional', '${provider.distinctMasterBanks.length} Bank', 'Nasional & Daerah', const Color(0xFF059669), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Rekening Merchant', '${provider.totalRekeningMerchant}', 'Toko, Jasa, & Layanan', const Color(0xFFEA580C), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Rekening Driver', '${provider.totalRekeningDriver}', 'Armada R2, R4, Amb', const Color(0xFF0284C7), isDark),
                const SizedBox(width: 12),
                _buildKpiCard('Status Verifikasi', '100% VALID', 'Siap Pencairan BI-FAST', const Color(0xFF16A34A), isDark),
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
                        hintText: 'Cari nama toko, driver, pemilik, atau no. rekening...',
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

                  // KATEGORI FILTER
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedKategoriFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      items: kategoris
                          .map((k) => DropdownMenuItem(value: k, child: Text('Kategori: $k')))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedKategoriFilter = v ?? 'SEMUA'),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Text(
                    'Menampilkan ${filtered.length} dari ${allItems.length} rekening',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. THE 7-COLUMN MASTER REKENING TABLE (WITH HORIZONTAL SCROLLBAR)
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
                        DataColumn(label: Text('Nama Toko / Warung / Driver')),
                        DataColumn(label: Text('Nama Pemilik')),
                        DataColumn(label: Text('Kategori Entitas')),
                        DataColumn(label: Text('Nama Bank Operasional')),
                        DataColumn(label: Text('Nomor Rekening')),
                        DataColumn(label: Text('Cabang / Kota')),
                        DataColumn(label: Text('Aksi & Salin')),
                      ],
                      rows: filtered.map((item) {
                        final bankColor = _getBankColor(item.namaBank);
                        final katColor = _getKategoriColor(item.kategoriEntitas);

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
                                    backgroundColor: katColor.withValues(alpha: 0.15),
                                    child: Icon(
                                      item.isDriver ? Icons.two_wheeler_rounded : Icons.storefront_rounded,
                                      size: 14,
                                      color: katColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.namaTokoWarungDriver,
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                item.namaPemilik,
                                style: TextStyle(
                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: katColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: katColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  item.kategoriEntitas,
                                  style: TextStyle(color: katColor, fontWeight: FontWeight.w900, fontSize: 10.5),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: bankColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: bankColor.withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.account_balance_rounded, size: 12, color: bankColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      item.namaBank,
                                      style: TextStyle(color: bankColor, fontWeight: FontWeight.w900, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () => _copyToClipboard(item.nomorRekening, 'Nomor Rekening'),
                                borderRadius: BorderRadius.circular(6),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.nomorRekening,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.copy_rounded, size: 13, color: Color(0xFF64748B)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.cabangKota,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy_rounded, size: 16),
                                    tooltip: 'Salin No. Rekening',
                                    color: const Color(0xFF16A34A),
                                    splashRadius: 16,
                                    onPressed: () => _copyToClipboard(item.nomorRekening, 'No. Rekening ${item.namaTokoWarungDriver}'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, size: 16),
                                    tooltip: 'Edit Rekening Mitra',
                                    color: NeoBrutalTheme.bispiraBlue,
                                    splashRadius: 16,
                                    onPressed: () => _showEditRekeningDialog(context, item),
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

            // 5. STICKY TOTAL FOOTER ROW MATCHING EXCEL SHEET 4
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
                      Icon(Icons.account_balance_wallet_rounded, color: NeoBrutalTheme.neoGold, size: 20),
                      SizedBox(width: 8),
                      Text('TOTAL DIREKTORI MASTER REKENING (EXCEL SHEET 4):', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSummaryChip('Total Rekening', '${allItems.length} Mitra', const Color(0xFF059669)),
                      _buildSummaryChip('Bank Operasional', '${banks.length - 1} Bank', const Color(0xFF0284C7)),
                      _buildSummaryChip('Kategori Entitas', '${kategoris.length - 1} Kategori', const Color(0xFF9333EA)),
                      _buildSummaryChip('Pencairan BI-FAST', '24 Jam Otomatis ⚡', const Color(0xFFEA580C)),
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

