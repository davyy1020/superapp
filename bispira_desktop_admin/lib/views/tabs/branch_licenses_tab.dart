import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class BranchLicensesTab extends StatefulWidget {
  const BranchLicensesTab({Key? key}) : super(key: key);

  @override
  State<BranchLicensesTab> createState() => _BranchLicensesTabState();
}

class _BranchLicensesTabState extends State<BranchLicensesTab> {
  String _searchQuery = '';
  String _selectedStatusFilter = 'SEMUA';

  void _showAddBranchDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final kabCtrl = TextEditingController();
    final provCtrl = TextEditingController(text: 'Jawa Barat');
    final ownerCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final saranaCtrl = TextEditingController(text: 'Lengkap (Kantor, Komputer, Gudang)');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Buka Cabang Franchise Baru',
        subtitle: 'Input data wilayah & owner lisensi lisensi cabang BISPIRA.',
        icon: Icons.business_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Kabupaten / Kota Wilayah Cabang',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_city_rounded,
                  hint: 'Contoh: Kab. Bogor',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Provinsi',
                  controller: provCtrl,
                  isDark: isDark,
                  icon: Icons.map_rounded,
                  hint: 'Contoh: Jawa Barat',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nama Pemilik / Owner Franchise',
                  controller: ownerCtrl,
                  isDark: isDark,
                  icon: Icons.person_rounded,
                  hint: 'Contoh: Hendra Wijaya',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor Kontak WhatsApp Owner',
                  controller: contactCtrl,
                  isDark: isDark,
                  icon: Icons.phone_rounded,
                  hint: 'Contoh: 081234567890',
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kesiapan Sarana & Prasarana SOP',
                  controller: saranaCtrl,
                  isDark: isDark,
                  icon: Icons.verified_rounded,
                  hint: 'Lengkap (Kantor, Komputer, Gudang)',
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
            label: 'Simpan Cabang',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (kabCtrl.text.isNotEmpty && ownerCtrl.text.isNotEmpty) {
                final newNo = 'CBG-00${provider.branches.length + 1}';
                final now = DateTime.now();
                final exp = DateTime(now.year + 2, now.month, now.day);
                provider.addBranch(
                  BranchModel(
                    branchNo: newNo,
                    kabupaten: kabCtrl.text,
                    provinsi: provCtrl.text,
                    ownerName: ownerCtrl.text,
                    contact: contactCtrl.text,
                    joinDate: now,
                    expireDate: exp,
                    daysLeftAlarm: exp.difference(now).inDays,
                    saranaStatus: saranaCtrl.text,
                    licenseStatus: 'AKTIF',
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cabang #$newNo (${kabCtrl.text}) berhasil dibuka!'), backgroundColor: NeoBrutalTheme.neoGreen),
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

  void _showEditBranchDialog(BuildContext context, AdminProvider provider, BranchModel branch, bool isDark) {
    final kabCtrl = TextEditingController(text: branch.kabupaten);
    final provCtrl = TextEditingController(text: branch.provinsi);
    final ownerCtrl = TextEditingController(text: branch.ownerName);
    final contactCtrl = TextEditingController(text: branch.contact);
    final saranaCtrl = TextEditingController(text: branch.saranaStatus);

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Edit Data Cabang #${branch.branchNo}',
        subtitle: 'Perbarui rincian wilayah & owner lisensi cabang.',
        icon: Icons.edit_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Kabupaten / Kota',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_city_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Provinsi',
                  controller: provCtrl,
                  isDark: isDark,
                  icon: Icons.map_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nama Owner',
                  controller: ownerCtrl,
                  isDark: isDark,
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor WhatsApp / Phone',
                  controller: contactCtrl,
                  isDark: isDark,
                  icon: Icons.phone_rounded,
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Status Sarana SOP Kantor',
                  controller: saranaCtrl,
                  isDark: isDark,
                  icon: Icons.verified_rounded,
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
              provider.editBranch(
                branch.branchNo,
                kabupaten: kabCtrl.text,
                provinsi: provCtrl.text,
                ownerName: ownerCtrl.text,
                contact: contactCtrl.text,
                saranaStatus: saranaCtrl.text,
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

  void _showRenewLicenseDialog(BuildContext context, AdminProvider provider, BranchModel branch, bool isDark) {
    int yearsToRenew = 1;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            title: Text(
              'Perpanjang Lisensi Franchise',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cabang: ${branch.kabupaten} (#${branch.branchNo})', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
                Text('Owner: ${branch.ownerName}', style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                const SizedBox(height: 16),
                Text('Pilih Durasi Perpanjangan Lisensi:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                const SizedBox(height: 8),
                Row(
                  children: [1, 2, 3].map((y) {
                    final isSel = yearsToRenew == y;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('+$y Tahun', style: TextStyle(color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87), fontWeight: FontWeight.w600)),
                        selected: isSel,
                        selectedColor: NeoBrutalTheme.bispiraBlue,
                        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        onSelected: (val) {
                          if (val) setModalState(() => yearsToRenew = y);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
              ),
              NeoBrutalButton(
                label: 'Perpanjang Sekarang',
                onPressed: () {
                  provider.renewBranchLicense(branch.branchNo, yearsToRenew);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lisensi #${branch.branchNo} berhasil diperpanjang +$yearsToRenew tahun!'), backgroundColor: NeoBrutalTheme.neoGreen),
                  );
                },
                bgColor: NeoBrutalTheme.neoGreen,
                fontSize: 13,
              ),
            ],
          );
        },
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

    final filteredBranches = provider.branches.where((b) {
      final matchSearch = b.kabupaten.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.branchNo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.ownerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.provinsi.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchStatus = _selectedStatusFilter == 'SEMUA' || b.licenseStatus == _selectedStatusFilter;

      return matchSearch && matchStatus;
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
                        'Pusat Admin Cabang & Lisensi Franchise',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftar Lisensi Franchise Wilayah, Owner, Alarm Masa Berakhir (60 Hari), & Profit Sharing 30%.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    NeoBrutalBadge(text: '${filteredBranches.length} Cabang Tampil', bgColor: NeoBrutalTheme.bispiraBlue),
                    const SizedBox(width: 12),
                    NeoBrutalButton(
                      label: '+ Buka Cabang Baru',
                      onPressed: () => _showAddBranchDialog(context, provider, isDark),
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
                        hintText: 'Cari Kabupaten, No Cabang, Owner, atau Provinsi...',
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

                  // License Status Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStatusFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('Status Lisensi: Semua')),
                          DropdownMenuItem(value: 'AKTIF', child: Text('Lisensi: AKTIF')),
                          DropdownMenuItem(value: 'PENDING_RENEWAL', child: Text('Lisensi: PENDING RENEWAL')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedStatusFilter = val;
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
                      DataColumn(label: Text('No. Cabang', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Kabupaten / Kota', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Provinsi', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Pemilik / Owner Cabang', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Kontak WA', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Tgl Bergabung', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Alarm Expire (60 Hari)', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Sarana & Prasarana SOP', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Status Lisensi', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Aksi Kelola', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                    ],
                    rows: filteredBranches.map((b) {
                      final isPendingRenewal = b.licenseStatus == 'PENDING_RENEWAL';
                      return DataRow(
                        color: WidgetStateProperty.all(cardBg),
                        cells: [
                          DataCell(Text(b.branchNo, style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text(b.kabupaten, style: TextStyle(fontWeight: FontWeight.w600, color: textPrimary))),
                          DataCell(Text(b.provinsi, style: TextStyle(color: textSecondary))),
                          DataCell(Text(b.ownerName, style: TextStyle(color: textPrimary))),
                          DataCell(Text(b.contact, style: const TextStyle(color: NeoBrutalTheme.bispiraBlue, fontWeight: FontWeight.w600))),
                          DataCell(Text('${b.joinDate.day}-${b.joinDate.month}-${b.joinDate.year}', style: TextStyle(color: textSecondary))),
                          DataCell(
                            NeoBrutalBadge(
                              text: '${b.daysLeftAlarm} Hari Sisa',
                              bgColor: b.daysLeftAlarm <= 60 ? NeoBrutalTheme.neoOrange : NeoBrutalTheme.neoYellow,
                            ),
                          ),
                          DataCell(Text(b.saranaStatus, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary))),
                          DataCell(
                            NeoBrutalBadge(
                              text: b.licenseStatus,
                              bgColor: isPendingRenewal ? NeoBrutalTheme.neoOrange : NeoBrutalTheme.neoGreen,
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPendingRenewal ? NeoBrutalTheme.neoOrange : NeoBrutalTheme.bispiraBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () {
                                    _showRenewLicenseDialog(context, provider, b, isDark);
                                  },
                                  child: const Text('Perpanjang', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 16, color: NeoBrutalTheme.bispiraBlue),
                                  onPressed: () => _showEditBranchDialog(context, provider, b, isDark),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: NeoBrutalTheme.neoRed),
                                  onPressed: () => provider.deleteBranch(b.branchNo),
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
                      values: provider.branches.map((b) => b.daysLeftAlarm.toDouble()).toList(),
                      labels: provider.branches.map((b) => b.branchNo).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(20),
                    child: BispiraLineChart(isDark: isDark),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
