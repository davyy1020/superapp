import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class BatchSettlementTab extends StatefulWidget {
  const BatchSettlementTab({Key? key}) : super(key: key);

  @override
  State<BatchSettlementTab> createState() => _BatchSettlementTabState();
}

class _BatchSettlementTabState extends State<BatchSettlementTab> {
  String _searchQuery = '';
  String _filterStatus = 'ALL';

  void _showAddPayoutDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final storeCtrl = TextEditingController();
    final ownerCtrl = TextEditingController();
    final bankCtrl = TextEditingController(text: 'BCA');
    final accNumCtrl = TextEditingController();
    final accHolderCtrl = TextEditingController();
    final salesCtrl = TextEditingController(text: '350000');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Tambah Batch Payout Toko Baru',
        subtitle: 'Input data toko & rekening bank untuk registrasi pencairan 17:00 WIB.',
        icon: Icons.account_balance_wallet_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Toko / Resto',
                  controller: storeCtrl,
                  isDark: isDark,
                  icon: Icons.storefront_rounded,
                  hint: 'Contoh: Resto Ayam Geprek Pak Eko',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nama Pemilik Toko',
                  controller: ownerCtrl,
                  isDark: isDark,
                  icon: Icons.person_outline_rounded,
                  hint: 'Contoh: Eko Prasetyo',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Bank Tujuan (BCA/BNI/Mandiri/BRI)',
                  controller: bankCtrl,
                  isDark: isDark,
                  icon: Icons.account_balance_rounded,
                  hint: 'BCA / BNI / Mandiri / BRI',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor Rekening Bank',
                  controller: accNumCtrl,
                  isDark: isDark,
                  icon: Icons.credit_card_rounded,
                  hint: 'Contoh: 7780019922',
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Atas Nama Rekening',
                  controller: accHolderCtrl,
                  isDark: isDark,
                  icon: Icons.badge_outlined,
                  hint: 'Contoh: Eko Prasetyo',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Akumulasi Sales 2 Hari',
                  controller: salesCtrl,
                  isDark: isDark,
                  icon: Icons.monetization_on_outlined,
                  prefix: 'Rp',
                  isNumber: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          NeoBrutalButton(
            label: 'Simpan Payout',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (storeCtrl.text.isNotEmpty && accNumCtrl.text.isNotEmpty) {
                final sales = double.tryParse(salesCtrl.text) ?? 350000;
                final newPayout = StorePayoutModel(
                  payoutId: 'PAY-880${provider.storePayouts.length + 1}',
                  merchantId: 'MCH-00${provider.storePayouts.length + 1}',
                  storeName: storeCtrl.text,
                  ownerName: ownerCtrl.text,
                  category: 'Food & Fresh Sembako',
                  kabupaten: 'Jakarta Selatan',
                  bankName: bankCtrl.text,
                  accountNumber: accNumCtrl.text,
                  accountHolder: accHolderCtrl.text.isEmpty ? 'a/n ${storeCtrl.text}' : accHolderCtrl.text,
                  accumulatedSales2Days: sales,
                  disbursementFee: provider.currentConfig.disbursementFee,
                  status: 'PENDING_1700',
                );
                provider.addStorePayout(newPayout);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payout #${newPayout.payoutId} (${storeCtrl.text}) berhasil ditambahkan!'), backgroundColor: NeoBrutalTheme.neoGreen),
                );
              }
            },
            bgColor: NeoBrutalTheme.neoGreen,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  void _showEditPayoutDialog(BuildContext context, AdminProvider provider, StorePayoutModel payout, bool isDark) {
    final bankCtrl = TextEditingController(text: payout.bankName);
    final accNumCtrl = TextEditingController(text: payout.accountNumber);
    final accHolderCtrl = TextEditingController(text: payout.accountHolder);
    final salesCtrl = TextEditingController(text: payout.accumulatedSales2Days.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Edit Payout #${payout.payoutId}',
        subtitle: 'Perbarui rincian bank & akumulasi penjualan ${payout.storeName}.',
        icon: Icons.edit_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Bank Tujuan',
                  controller: bankCtrl,
                  isDark: isDark,
                  icon: Icons.account_balance_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor Rekening',
                  controller: accNumCtrl,
                  isDark: isDark,
                  icon: Icons.credit_card_rounded,
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Atas Nama Rekening',
                  controller: accHolderCtrl,
                  isDark: isDark,
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Akumulasi Sales (Rp)',
                  controller: salesCtrl,
                  isDark: isDark,
                  icon: Icons.monetization_on_outlined,
                  prefix: 'Rp',
                  isNumber: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          NeoBrutalButton(
            label: 'Simpan Perubahan',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              final newSales = double.tryParse(salesCtrl.text) ?? payout.accumulatedSales2Days;
              provider.editStorePayout(
                payout.payoutId,
                bankName: bankCtrl.text,
                accountNumber: accNumCtrl.text,
                accountHolder: accHolderCtrl.text,
                grossSales: newSales,
              );
              Navigator.pop(ctx);
            },
            bgColor: NeoBrutalTheme.bispiraBlue,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final cardBg = NeoBrutalTheme.getBgCard(isDark);
    final textPrimary = NeoBrutalTheme.getTextPrimary(isDark);
    final textSecondary = NeoBrutalTheme.getTextSecondary(isDark);
    final textMuted = NeoBrutalTheme.getTextMuted(isDark);
    final borderColor = NeoBrutalTheme.getBorderSubtle(isDark);
    final inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    final payouts = provider.storePayouts.where((p) {
      final matchesQuery = p.storeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.ownerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.bankName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.accountNumber.contains(_searchQuery);
      final matchesStatus = _filterStatus == 'ALL' || p.status == _filterStatus;
      return matchesQuery && matchesStatus;
    }).toList();

    double totalGross = 0;
    double totalNet = 0;
    double totalFee = 0;
    int pendingCount = 0;

    for (var p in provider.storePayouts) {
      if (p.status == 'PENDING_1700') {
        totalGross += p.accumulatedSales2Days;
        totalNet += p.netPayable;
        totalFee += p.disbursementFee;
        pendingCount++;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Batch Action
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pencairan Dana Penjual / Mitra (Batch 17:00 WIB)',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hasil penjualan diakumulasi maksimal 2 hari dan dicairkan per toko atau secara massal setiap pukul 17:00 WIB dipotong Biaya Pencairan.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    NeoBrutalButton(
                      label: '+ Tambah Payout',
                      onPressed: () => _showAddPayoutDialog(context, provider, isDark),
                      bgColor: NeoBrutalTheme.neoGreen,
                      fontSize: 13,
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: pendingCount == 0
                          ? null
                          : () {
                              final result = provider.triggerBatchPayout1700();
                              if (result != null) {
                                _showBatchSuccessDialog(context, result, isDark);
                              }
                            },
                      icon: const Icon(Icons.flash_on_rounded, size: 18),
                      label: Text('⚡ Transfer Massal Semua Toko ($pendingCount)', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      style: ElevatedButton.styleFrom(backgroundColor: provider.accentColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 24),

          // KPI Cards
          Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'Akumulasi Penjualan (2 Hari)',
                    value: 'Rp ${totalGross.toInt()}',
                    subtitle: '$pendingCount Toko Menunggu Transfer',
                    icon: Icons.storefront_rounded,
                    iconColor: provider.accentColor,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Netto Yang Harus Dibayar',
                    value: 'Rp ${totalNet.toInt()}',
                    subtitle: 'Sudah dipotong Disbursement Fee',
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: const Color(0xFF10B981),
                    valueColor: const Color(0xFF10B981),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Potongan Biaya Pencairan',
                    value: 'Rp ${provider.currentConfig.disbursementFee.toInt()} / toko',
                    subtitle: 'Total Estimasi Fee: Rp ${totalFee.toInt()}',
                    icon: Icons.confirmation_number_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKpiCard(
                    title: 'Jadwal Batch Transfer',
                    value: '17:00 WIB',
                    subtitle: 'Otomatisasi Server BISPIRA',
                    icon: Icons.schedule_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 28),

          // Table Container
          Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt_long_rounded, color: provider.accentColor, size: 22),
                          const SizedBox(width: 10),
                          Text('Daftar Akumulasi & Konfirmasi Transfer Per Toko', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary)),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 240,
                            height: 40,
                            decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
                            child: TextField(
                              onChanged: (val) => setState(() => _searchQuery = val),
                              style: TextStyle(fontSize: 13, color: textPrimary, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(hintText: 'Cari toko, pemilik, bank...', hintStyle: TextStyle(fontSize: 12, color: textMuted), prefixIcon: Icon(Icons.search_rounded, size: 18, color: textMuted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 10)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildFilterChip('ALL', 'Semua', isDark, provider.accentColor),
                          const SizedBox(width: 6),
                          _buildFilterChip('PENDING_1700', 'Menunggu', isDark, provider.accentColor),
                          const SizedBox(width: 6),
                          _buildFilterChip('SUDAH_DITRANSFER', 'Ditransfer', isDark, provider.accentColor),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Data Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                      horizontalMargin: 16,
                      columnSpacing: 20,
                      dataRowMinHeight: 64,
                      dataRowMaxHeight: 64,
                      columns: [
                        DataColumn(label: Text('DETAIL TOKO & PEMILIK', style: _headerStyle(textSecondary))),
                        DataColumn(label: Text('KATEGORI & LOKASI', style: _headerStyle(textSecondary))),
                        DataColumn(label: Text('AKUMULASI (2 HARI)', style: _headerStyle(textSecondary))),
                        DataColumn(label: Text('BIAYA PENCAIRAN', style: _headerStyle(textSecondary))),
                        DataColumn(label: Text('NETTO DIBAYAR', style: _headerStyle(textSecondary))),
                        DataColumn(label: Text('REKENING BANK TUJUAN', style: _headerStyle(textSecondary))),
                        DataColumn(label: Text('STATUS BATCH', style: _headerStyle(textSecondary))),
                        DataColumn(label: Text('AKSI KONFIRMASI', style: _headerStyle(textSecondary))),
                      ],
                      rows: payouts.map((payout) {
                        final isPending = payout.status == 'PENDING_1700';

                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor: (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                    child: Text(payout.storeName.isNotEmpty ? payout.storeName[0].toUpperCase() : 'S', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textPrimary)),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(payout.storeName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                                      Text('ID: ${payout.merchantId} • ${payout.ownerName}', style: TextStyle(fontSize: 11, color: textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(payout.category, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textPrimary)),
                                  Text(payout.kabupaten, style: TextStyle(fontSize: 11, color: textSecondary)),
                                ],
                              ),
                            ),
                            DataCell(Text('Rp ${payout.accumulatedSales2Days.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary))),
                            DataCell(Text('- Rp ${payout.disbursementFee.toInt()}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFFEF4444)))),
                            DataCell(
                              Text(
                                'Rp ${payout.netPayable.toInt()}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: Color(0xFF10B981)),
                              ),
                            ),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFF0066FF).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                    child: Text(payout.bankName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10.5, color: Color(0xFF0066FF))),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${payout.accountNumber} a/n ${payout.accountHolder}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textSecondary)),
                                ],
                              ),
                            ),
                            DataCell(
                              isPending
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4))),
                                      child: const Text('Menunggu 17:00', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 11.5, fontWeight: FontWeight.w700)),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4))),
                                      child: const Text('Sudah Ditransfer', style: TextStyle(color: Color(0xFF10B981), fontSize: 11.5, fontWeight: FontWeight.w700)),
                                    ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  if (isPending)
                                    ElevatedButton.icon(
                                      onPressed: () => _showSinglePayoutConfirmDialog(context, payout, provider, isDark),
                                      icon: const Icon(Icons.send_rounded, size: 13),
                                      label: const Text('KIRIM DANA', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0066FF), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                                    ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, size: 16, color: NeoBrutalTheme.bispiraBlue),
                                    onPressed: () => _showEditPayoutDialog(context, provider, payout, isDark),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: NeoBrutalTheme.neoRed),
                                    onPressed: () => provider.deleteStorePayout(payout.payoutId),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),

          // Visual Charts Section
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
                    child: BispiraBarChart(
                      isDark: isDark,
                      values: provider.storePayouts.map((p) => p.netPayable / 10000).toList(),
                      labels: provider.storePayouts.map((p) => p.storeName.split(' ')[0]).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
                    child: BispiraDonutChart(isDark: isDark),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  TextStyle _headerStyle(Color color) {
    return TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.8);
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 18)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: valueColor ?? textPrimary, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: textSecondary)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String code, String label, bool isDark, Color accentColor) {
    final isSelected = _filterStatus == code;
    return InkWell(
      onTap: () => setState(() => _filterStatus = code),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? accentColor : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
        ),
        child: Text(label, style: TextStyle(fontSize: 11.5, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? Colors.white : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)))),
      ),
    );
  }

  void _showSinglePayoutConfirmDialog(BuildContext context, StorePayoutModel payout, AdminProvider provider, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF131C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
        title: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF0066FF).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.send_rounded, color: Color(0xFF0066FF), size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Text('Konfirmasi Transfer Dana', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mentransfer dana akumulasi penjualan ke toko:', style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
              child: Column(
                children: [
                  _dialogRow('Nama Toko', payout.storeName, isDark),
                  const SizedBox(height: 8),
                  _dialogRow('Pemilik Toko', payout.ownerName, isDark),
                  const SizedBox(height: 8),
                  _dialogRow('Bank Tujuan', '${payout.bankName} (${payout.accountNumber})', isDark),
                  const SizedBox(height: 8),
                  _dialogRow('Atas Nama', payout.accountHolder, isDark),
                  const Divider(height: 20),
                  _dialogRow('TOTAL NETTO DITRANSFER', 'Rp ${payout.netPayable.toInt()}', isDark, isHighlight: true),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w700))),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              provider.confirmStorePayout(payout.payoutId);
            },
            icon: const Icon(Icons.check_circle_rounded, size: 16),
            label: const Text('KONFIRMASI KIRIM DANA', style: TextStyle(fontWeight: FontWeight.w800)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
    );
  }

  void _showBatchSuccessDialog(BuildContext context, Map<String, double> result, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF131C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
        title: const Row(children: [Icon(Icons.stars_rounded, color: Color(0xFF10B981), size: 26), SizedBox(width: 10), Text('Batch Payout 17:00 WIB Sukses!')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Akumulasi Gross: Rp ${result['gross']!.toInt()}', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 6),
            Text('Potongan Fee: -Rp ${result['fee']!.toInt()}', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFF59E0B))),
            const Divider(height: 20),
            Text('Total Netto Ditransfer: Rp ${result['net']!.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF10B981), fontSize: 16)),
          ],
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0066FF)), child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))],
      ),
    );
  }

  Widget _dialogRow(String label, String value, bool isDark, {bool isWarning = false, bool isHighlight = false}) {
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600, color: textSecondary)),
        Text(value, style: TextStyle(fontSize: isHighlight ? 15 : 13, fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w700, color: isHighlight ? const Color(0xFF10B981) : (isWarning ? const Color(0xFFF59E0B) : textPrimary))),
      ],
    );
  }
}
