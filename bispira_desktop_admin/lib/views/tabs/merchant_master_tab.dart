import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class MerchantMasterTab extends StatefulWidget {
  const MerchantMasterTab({Key? key}) : super(key: key);

  @override
  State<MerchantMasterTab> createState() => _MerchantMasterTabState();
}

class _MerchantMasterTabState extends State<MerchantMasterTab> {
  String _searchQuery = '';
  String _selectedCategoryFilter = 'SEMUA';
  String _selectedSubFilter = 'SEMUA';

  void _showAddMerchantDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final storeCtrl = TextEditingController();
    final ownerCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Food & Fresh Sembako');
    final kabCtrl = TextEditingController(text: 'Jakarta Selatan');
    final basePriceCtrl = TextEditingController(text: '20000');
    final markupCtrl = TextEditingController(text: '10');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Daftarkan Merchant / Mitra Toko Baru',
        subtitle: 'Input data toko, kategori layanan & komisi markup platform.',
        icon: Icons.storefront_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Toko / Resto / Apotek',
                  controller: storeCtrl,
                  isDark: isDark,
                  icon: Icons.store_rounded,
                  hint: 'Contoh: Resto Bebek Goreng Slamet',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nama Pemilik / Penjual',
                  controller: ownerCtrl,
                  isDark: isDark,
                  icon: Icons.person_rounded,
                  hint: 'Contoh: Slamet Rahardjo',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kategori Layanan',
                  controller: categoryCtrl,
                  isDark: isDark,
                  icon: Icons.category_rounded,
                  hint: 'Food & Fresh / Go-Health / Sembako',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kabupaten / Kota',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_on_rounded,
                  hint: 'Contoh: Jakarta Selatan',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Rata-rata Harga Dasar Produk',
                  controller: basePriceCtrl,
                  isDark: isDark,
                  icon: Icons.monetization_on_outlined,
                  prefix: 'Rp',
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Markup Platform BISPIRA',
                  controller: markupCtrl,
                  isDark: isDark,
                  icon: Icons.percent_rounded,
                  hint: '10',
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
            label: 'Simpan Merchant',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (storeCtrl.text.isNotEmpty && ownerCtrl.text.isNotEmpty) {
                final newId = 'MCH-00${provider.merchants.length + 1}';
                provider.addMerchant(
                  MerchantModel(
                    merchantId: newId,
                    storeName: storeCtrl.text,
                    ownerName: ownerCtrl.text,
                    category: categoryCtrl.text,
                    kabupaten: kabCtrl.text,
                    basePriceAvg: double.tryParse(basePriceCtrl.text) ?? 20000,
                    markupPercent: double.tryParse(markupCtrl.text) ?? 10,
                    subscriptionStatus: 'LUNAS BULANAN',
                    accumulatedSales: 0,
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Merchant #$newId (${storeCtrl.text}) berhasil didaftarkan!'), backgroundColor: NeoBrutalTheme.neoGreen),
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

  void _showEditMerchantDialog(BuildContext context, AdminProvider provider, MerchantModel merchant, bool isDark) {
    final storeCtrl = TextEditingController(text: merchant.storeName);
    final ownerCtrl = TextEditingController(text: merchant.ownerName);
    final categoryCtrl = TextEditingController(text: merchant.category);
    final kabCtrl = TextEditingController(text: merchant.kabupaten);
    final basePriceCtrl = TextEditingController(text: merchant.basePriceAvg.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Edit Data Merchant #${merchant.merchantId}',
        subtitle: 'Perbarui rincian toko & rata-rata harga dasar produk.',
        icon: Icons.edit_rounded,
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
                  icon: Icons.store_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nama Pemilik',
                  controller: ownerCtrl,
                  isDark: isDark,
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kategori Layanan',
                  controller: categoryCtrl,
                  isDark: isDark,
                  icon: Icons.category_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kabupaten / Kota',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_on_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Rata-rata Harga Dasar (Rp)',
                  controller: basePriceCtrl,
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
              provider.editMerchant(
                merchant.merchantId,
                storeName: storeCtrl.text,
                ownerName: ownerCtrl.text,
                category: categoryCtrl.text,
                kabupaten: kabCtrl.text,
                basePriceAvg: double.tryParse(basePriceCtrl.text) ?? merchant.basePriceAvg,
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

  void _showEditMarkupDialog(BuildContext context, AdminProvider provider, MerchantModel merchant, bool isDark) {
    final markupCtrl = TextEditingController(text: merchant.markupPercent.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Ubah Markup Platform',
        subtitle: 'Atur persentase komisi platform untuk ${merchant.storeName} (#${merchant.merchantId}).',
        icon: Icons.percent_rounded,
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BispiraFormField(
                label: 'Persentase Markup Baru (%)',
                controller: markupCtrl,
                isDark: isDark,
                icon: Icons.percent_rounded,
                isNumber: true,
                hint: '10',
              ),
            ],
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
            label: 'Simpan Markup',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              final newMarkup = double.tryParse(markupCtrl.text) ?? 10;
              provider.updateMerchantMarkup(merchant.merchantId, newMarkup);
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

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final filteredMerchants = provider.merchants.where((m) {
      final matchSearch = m.storeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.merchantId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.ownerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.kabupaten.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchCategory = _selectedCategoryFilter == 'SEMUA' || m.category.contains(_selectedCategoryFilter);
      final matchSub = _selectedSubFilter == 'SEMUA' || m.subscriptionStatus == _selectedSubFilter;

      return matchSearch && matchCategory && matchSub;
    }).toList();

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
                        'Pusat Merchant Makanan, Fresh Sembako & Health',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Data Mitra Penjual, Harga Produk Dasar, Skema Markup %, Status Subscribe Bulanan, & Akumulasi Penjualan Batch 17:00.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    NeoBrutalBadge(text: '${filteredMerchants.length} Merchant Tampil', bgColor: NeoBrutalTheme.bispiraBlue),
                    const SizedBox(width: 12),
                    NeoBrutalButton(
                      label: '+ Tambah Merchant Baru',
                      onPressed: () => _showAddMerchantDialog(context, provider, isDark),
                      bgColor: NeoBrutalTheme.neoGreen,
                      fontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Search & Filter Toolbar
          NeoBrutalCard(
              bgColor: cardBg,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: TextStyle(color: textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari Toko, ID Merchant, Pemilik, atau Kabupaten...',
                        hintStyle: TextStyle(color: textSecondary, fontSize: 13),
                        prefixIcon: Icon(Icons.search_rounded, color: textSecondary, size: 20),
                        isDense: true,
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderSubtle)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderSubtle)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Category Filter Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategoryFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('Kategori: Semua')),
                          DropdownMenuItem(value: 'Food', child: Text('Food & Sembako')),
                          DropdownMenuItem(value: 'Sehat', child: Text('Mitra Sehat & Apotek')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCategoryFilter = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Subscription Status Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSubFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('Subscribe: Semua')),
                          DropdownMenuItem(value: 'LUNAS BULANAN', child: Text('Lunas Bulanan')),
                          DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedSubFilter = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Master Table
          NeoBrutalCard(
              bgColor: cardBg,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: borderSubtle),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                    border: TableBorder.all(color: borderSubtle, width: 1.0),
                    columns: [
                      DataColumn(label: Text('ID Merchant', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Nama Toko / Warung', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Pemilik / Penjual', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Kategori Layanan', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Kabupaten', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Rata2 Harga Dasar', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Markup (%)', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Subscribe Bulanan', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Akumulasi Penjualan', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Aksi Kelola', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                    ],
                    rows: filteredMerchants.map((m) {
                      return DataRow(
                        color: WidgetStateProperty.all(cardBg),
                        cells: [
                          DataCell(Text(m.merchantId, style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text(m.storeName, style: TextStyle(fontWeight: FontWeight.w600, color: textPrimary))),
                          DataCell(Text(m.ownerName, style: TextStyle(color: textSecondary))),
                          DataCell(NeoBrutalBadge(text: m.category, bgColor: NeoBrutalTheme.bispiraBlue)),
                          DataCell(Text(m.kabupaten, style: TextStyle(color: textSecondary))),
                          DataCell(Text('Rp ${m.basePriceAvg.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text('${m.markupPercent.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w700, color: NeoBrutalTheme.bispiraBlue))),
                          DataCell(NeoBrutalBadge(text: m.subscriptionStatus, bgColor: NeoBrutalTheme.neoGreen)),
                          DataCell(Text('Rp ${m.accumulatedSales.toInt()}', style: const TextStyle(fontWeight: FontWeight.w700, color: NeoBrutalTheme.neoGreen))),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: NeoBrutalTheme.bispiraBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () {
                                    _showEditMarkupDialog(context, provider, m, isDark);
                                  },
                                  child: const Text('Markup', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 16, color: NeoBrutalTheme.bispiraBlue),
                                  onPressed: () => _showEditMerchantDialog(context, provider, m, isDark),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: NeoBrutalTheme.neoRed),
                                  onPressed: () => provider.deleteMerchant(m.merchantId),
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
          const SizedBox(height: 28),

          // Visual Analytics Charts Section
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(20),
                    child: BispiraBarChart(
                      isDark: isDark,
                      values: provider.merchants.map((m) => m.accumulatedSales / 10000).toList(),
                      labels: provider.merchants.map((m) => m.merchantId).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(20),
                    child: BispiraDonutChart(isDark: isDark),
                  ),
                ),
              ],
            ),
          ],
      ),
    );
  }
}
