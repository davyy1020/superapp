import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class ManualReconciliationTab extends StatefulWidget {
  const ManualReconciliationTab({Key? key}) : super(key: key);

  @override
  State<ManualReconciliationTab> createState() => _ManualReconciliationTabState();
}

class _ManualReconciliationTabState extends State<ManualReconciliationTab> {
  String _searchQuery = '';

  void _showAddTxDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final nameCtrl = TextEditingController();
    final serviceCtrl = TextEditingController(text: 'Go-Food (Ayam Geprek)');
    final bankCtrl = TextEditingController(text: 'BCA 778009988 (a/n BISPIRA)');
    final priceCtrl = TextEditingController(text: '25000');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Tambah Transaksi Manual Rekonsiliasi',
        subtitle: 'Input data pembayaran baru untuk verifikasi mutasi bank BISPIRA.',
        icon: Icons.add_card_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Pelanggan / Konsumen',
                  controller: nameCtrl,
                  isDark: isDark,
                  icon: Icons.person_outline_rounded,
                  hint: 'Contoh: Davy Wahyu',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Layanan BISPIRA',
                  controller: serviceCtrl,
                  isDark: isDark,
                  icon: Icons.restaurant_rounded,
                  hint: 'Go-Food, Ride-Hailing, Go-Health, etc.',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Rekening Target BISPIRA',
                  controller: bankCtrl,
                  isDark: isDark,
                  icon: Icons.account_balance_rounded,
                  hint: 'BCA / BNI / Mandiri / BRI',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Harga Dasar Layanan',
                  controller: priceCtrl,
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
            label: 'Simpan Transaksi',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                final basePrice = double.tryParse(priceCtrl.text) ?? 25000;
                final uniqueCode = 100 + Random().nextInt(899);
                final newTx = ManualTransaction(
                  txId: 'TX-99${provider.pendingTransactions.length + 10}',
                  customerName: nameCtrl.text,
                  serviceName: serviceCtrl.text,
                  bankTarget: bankCtrl.text,
                  basePrice: basePrice,
                  markup: basePrice * 0.1,
                  appFee: provider.currentConfig.appFee,
                  serviceFee: provider.currentConfig.serviceFee,
                  uniqueCode: uniqueCode,
                  totalNominal: basePrice + (basePrice * 0.1) + provider.currentConfig.appFee + provider.currentConfig.serviceFee + uniqueCode,
                  createdAt: DateTime.now(),
                  expiresAt: DateTime.now().add(Duration(minutes: provider.currentConfig.uniqueCodeDurationMinutes)),
                  status: 'MENUNGGU_MUTASI_BANK',
                );
                provider.addManualTx(newTx);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transaksi #${newTx.txId} (${nameCtrl.text}) berhasil dibuat!'), backgroundColor: NeoBrutalTheme.neoGreen),
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

  void _showEditTxDialog(BuildContext context, AdminProvider provider, ManualTransaction tx, bool isDark) {
    final nameCtrl = TextEditingController(text: tx.customerName);
    final serviceCtrl = TextEditingController(text: tx.serviceName);
    final bankCtrl = TextEditingController(text: tx.bankTarget);
    final priceCtrl = TextEditingController(text: tx.basePrice.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Edit Transaksi #${tx.txId}',
        subtitle: 'Perbarui rincian transaksi sebelum verifikasi mutasi bank.',
        icon: Icons.edit_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Pelanggan',
                  controller: nameCtrl,
                  isDark: isDark,
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Layanan BISPIRA',
                  controller: serviceCtrl,
                  isDark: isDark,
                  icon: Icons.shopping_bag_outlined,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Rekening Target BISPIRA',
                  controller: bankCtrl,
                  isDark: isDark,
                  icon: Icons.account_balance_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Harga Dasar Layanan',
                  controller: priceCtrl,
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
            icon: Icons.save_rounded,
            onPressed: () {
              final newPrice = double.tryParse(priceCtrl.text) ?? tx.basePrice;
              provider.editManualTx(
                tx.txId,
                customerName: nameCtrl.text,
                serviceName: serviceCtrl.text,
                basePrice: newPrice,
                bankTarget: bankCtrl.text,
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

    final pendingList = provider.pendingTransactions.where((tx) {
      final q = _searchQuery.toLowerCase();
      return tx.txId.toLowerCase().contains(q) ||
          tx.customerName.toLowerCase().contains(q) ||
          tx.serviceName.toLowerCase().contains(q) ||
          tx.bankTarget.toLowerCase().contains(q);
    }).toList();

    final pendingCount = provider.pendingTransactions.where((tx) => tx.status == 'MENUNGGU_MUTASI_BANK').length;
    final totalPendingNominal = provider.pendingTransactions
        .where((tx) => tx.status == 'MENUNGGU_MUTASI_BANK')
        .fold(0.0, (sum, item) => sum + item.totalNominal);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi Manual Mutasi Bank (Tanpa Upload Bukti Bayar)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.3),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pencocokan manual oleh Tim BISPIRA berdasarkan nominal & Kode Unik 3-Digit langsung di mutasi rekening bank BISPIRA.',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              NeoBrutalButton(
                label: '+ Tambah Transaksi',
                onPressed: () => _showAddTxDialog(context, provider, isDark),
                bgColor: NeoBrutalTheme.neoGreen,
                fontSize: 13,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // KPI Cards
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: 'Menunggu Mutasi Bank',
                  value: '$pendingCount Transaksi',
                  subtitle: 'Kode Unik Aktif',
                  icon: Icons.hourglass_top_rounded,
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
                  title: 'Total Nominal Pending',
                  value: 'Rp ${totalPendingNominal.toInt()}',
                  subtitle: 'Termasuk 3-Digit Kode Unik',
                  icon: Icons.monetization_on_rounded,
                  iconColor: const Color(0xFF0066FF),
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  title: 'Akurasi Auto-Matching Engine',
                  value: '99.98%',
                  subtitle: 'Verifikasi Tanpa Struk/Nota',
                  icon: Icons.verified_user_rounded,
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
                  title: 'Masa Berlaku Kode Unik',
                  value: '${provider.currentConfig.uniqueCodeDurationMinutes} Menit',
                  subtitle: 'Otomatis Reset / Expire',
                  icon: Icons.timer_rounded,
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
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0066FF), size: 22),
                        const SizedBox(width: 10),
                        Text(
                          'Daftar Transaksi Rekonsiliasi Mutasi Bank',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                      ],
                    ),
                    Container(
                      width: 280,
                      height: 40,
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: TextStyle(fontSize: 13, color: textPrimary, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Cari ID, pelanggan, bank...',
                          hintStyle: TextStyle(fontSize: 12, color: textMuted),
                          prefixIcon: Icon(Icons.search_rounded, size: 18, color: textMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
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
                      DataColumn(label: Text('ID TRANSAKSI', style: _headerStyle(textSecondary))),
                      DataColumn(label: Text('PELANGGAN', style: _headerStyle(textSecondary))),
                      DataColumn(label: Text('LAYANAN BISPIRA', style: _headerStyle(textSecondary))),
                      DataColumn(label: Text('REKENING BISPIRA TARGET', style: _headerStyle(textSecondary))),
                      DataColumn(label: Text('TOTAL NOMINAL (+KODE UNIK)', style: _headerStyle(textSecondary))),
                      DataColumn(label: Text('STATUS / SISA WAKTU', style: _headerStyle(textSecondary))),
                      DataColumn(label: Text('AKSI VERIFIKASI ADMIN', style: _headerStyle(textSecondary))),
                    ],
                    rows: pendingList.map((tx) {
                      final isPaid = tx.status == 'LUNAS';

                      return DataRow(
                        color: WidgetStateProperty.all(
                          isPaid
                              ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFECFDF5))
                              : (isDark ? const Color(0xFF131C2E) : Colors.white),
                        ),
                        cells: [
                          DataCell(Text('#${tx.txId}', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(tx.customerName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: textPrimary)),
                                Text('e-KYC Verified', style: TextStyle(fontSize: 11, color: textMuted)),
                              ],
                            ),
                          ),
                          DataCell(Text(tx.serviceName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textSecondary))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isPaid ? const Color(0xFF10B981).withValues(alpha: 0.12) : const Color(0xFF0066FF).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isPaid ? const Color(0xFF10B981).withValues(alpha: 0.3) : const Color(0xFF0066FF).withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                tx.bankTarget,
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: isPaid ? const Color(0xFF10B981) : const Color(0xFF0066FF)),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                Text('Rp ${tx.totalNominal.toInt()}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: textPrimary)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                                  ),
                                  child: Text('+${tx.uniqueCode}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFFF59E0B))),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            isPaid
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                                    child: const Text('✓ LUNAS', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                                  )
                                : Row(
                                    children: [
                                      const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFF59E0B)),
                                      const SizedBox(width: 4),
                                      Text('29:45 mnt', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondary)),
                                    ],
                                  ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                if (!isPaid)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      provider.confirmManualPayment(tx.txId);
                                    },
                                    icon: const Icon(Icons.check_circle_rounded, size: 15),
                                    label: const Text('Konfirmasi Bayar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                                  ),
                                const SizedBox(width: 6),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 16, color: NeoBrutalTheme.bispiraBlue),
                                  onPressed: () => _showEditTxDialog(context, provider, tx, isDark),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: NeoBrutalTheme.neoRed),
                                  onPressed: () => provider.deleteManualTx(tx.txId),
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
          const SizedBox(height: 28),

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
                    values: provider.pendingTransactions.map((tx) => tx.totalNominal / 1000).toList(),
                    labels: provider.pendingTransactions.map((tx) => tx.bankTarget.split(' ')[0]).toList(),
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
}
