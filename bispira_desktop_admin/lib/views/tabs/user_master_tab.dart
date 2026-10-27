import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class UserMasterTab extends StatefulWidget {
  const UserMasterTab({Key? key}) : super(key: key);

  @override
  State<UserMasterTab> createState() => _UserMasterTabState();
}

class _UserMasterTabState extends State<UserMasterTab> {
  String _searchQuery = '';
  String _selectedKycFilter = 'SEMUA';

  void _showAddUserDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final kabCtrl = TextEditingController(text: 'Jakarta Selatan');
    final provCtrl = TextEditingController(text: 'DKI Jakarta');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Tambah Pelanggan Baru',
        subtitle: 'Input profil & kontak domisili pengguna BISPIRA.',
        icon: Icons.person_add_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Lengkap',
                  controller: nameCtrl,
                  isDark: isDark,
                  icon: Icons.person_outline_rounded,
                  hint: 'Contoh: Dewi Sartika',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor WhatsApp / Phone',
                  controller: phoneCtrl,
                  isDark: isDark,
                  icon: Icons.phone_rounded,
                  hint: 'Contoh: 081388776655',
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Alamat Email',
                  controller: emailCtrl,
                  isDark: isDark,
                  icon: Icons.email_rounded,
                  hint: 'dewi.sartika@gmail.com',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kabupaten / Kota',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_city_rounded,
                  hint: 'Contoh: Jakarta Selatan',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Provinsi',
                  controller: provCtrl,
                  isDark: isDark,
                  icon: Icons.map_rounded,
                  hint: 'Contoh: DKI Jakarta',
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
            label: 'Simpan User',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                final newId = 'USR-00${provider.users.length + 1}';
                provider.addUser(
                  UserModel(
                    userId: newId,
                    fullName: nameCtrl.text,
                    phone: phoneCtrl.text,
                    email: emailCtrl.text.isEmpty ? '${nameCtrl.text.toLowerCase().replaceAll(' ', '')}@gmail.com' : emailCtrl.text,
                    kabupaten: kabCtrl.text,
                    provinsi: provCtrl.text,
                    status: 'e-KYC Verified',
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pelanggan #$newId (${nameCtrl.text}) berhasil ditambahkan!'), backgroundColor: NeoBrutalTheme.neoGreen),
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

  void _showEditUserDialog(BuildContext context, AdminProvider provider, UserModel user, bool isDark) {
    final nameCtrl = TextEditingController(text: user.fullName);
    final phoneCtrl = TextEditingController(text: user.phone);
    final emailCtrl = TextEditingController(text: user.email);
    final kabCtrl = TextEditingController(text: user.kabupaten);
    final provCtrl = TextEditingController(text: user.provinsi);

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Edit Data Pelanggan #${user.userId}',
        subtitle: 'Perbarui rincian identitas & alamat pengguna.',
        icon: Icons.edit_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Lengkap',
                  controller: nameCtrl,
                  isDark: isDark,
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor WA / Phone',
                  controller: phoneCtrl,
                  isDark: isDark,
                  icon: Icons.phone_rounded,
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Alamat Email',
                  controller: emailCtrl,
                  isDark: isDark,
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 14),
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
              provider.editUser(
                user.userId,
                fullName: nameCtrl.text,
                phone: phoneCtrl.text,
                email: emailCtrl.text,
                kabupaten: kabCtrl.text,
                provinsi: provCtrl.text,
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

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final filteredUsers = provider.users.where((u) {
      final matchSearch = u.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.userId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.kabupaten.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchKyc = _selectedKycFilter == 'SEMUA' || u.status.contains(_selectedKycFilter);

      return matchSearch && matchKyc;
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
                        'Pusat User Pelanggan & Nasabah Nasional',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftar User Terdaftar secara Nasional, Provinsi, dan Kabupaten/Kota. Status verifikasi Bank Digital e-KYC.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    NeoBrutalBadge(text: '${filteredUsers.length} Pelanggan Tampil', bgColor: NeoBrutalTheme.bispiraBlue),
                    const SizedBox(width: 12),
                    NeoBrutalButton(
                      label: '+ Tambah User Baru',
                      onPressed: () => _showAddUserDialog(context, provider, isDark),
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
                        hintText: 'Cari Nama Pelanggan, ID User, Email, atau Kabupaten...',
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

                  // KYC Status Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKycFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('Status e-KYC: Semua')),
                          DropdownMenuItem(value: 'Verified', child: Text('Verified')),
                          DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedKycFilter = val;
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
                      DataColumn(label: Text('ID User', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Nomor WA / Phone', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Kabupaten / Kota', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Provinsi', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Status e-KYC', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Aksi Kelola', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                    ],
                    rows: filteredUsers.map((u) {
                      final isVerified = u.status.contains('Verified');
                      return DataRow(
                        color: WidgetStateProperty.all(cardBg),
                        cells: [
                          DataCell(Text(u.userId, style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text(u.fullName, style: TextStyle(fontWeight: FontWeight.w600, color: textPrimary))),
                          DataCell(Text(u.phone, style: const TextStyle(fontWeight: FontWeight.w600, color: NeoBrutalTheme.bispiraBlue))),
                          DataCell(Text(u.email, style: TextStyle(color: textSecondary))),
                          DataCell(Text(u.kabupaten, style: TextStyle(color: textSecondary))),
                          DataCell(Text(u.provinsi, style: TextStyle(color: textSecondary))),
                          DataCell(
                            NeoBrutalBadge(
                              text: u.status,
                              bgColor: isVerified ? NeoBrutalTheme.neoGreen : NeoBrutalTheme.neoOrange,
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isVerified ? NeoBrutalTheme.neoOrange : NeoBrutalTheme.neoGreen,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () {
                                    provider.toggleUserKYC(u.userId);
                                  },
                                  child: Text(isVerified ? 'Pending' : 'Verify', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 16, color: NeoBrutalTheme.bispiraBlue),
                                  onPressed: () => _showEditUserDialog(context, provider, u, isDark),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: NeoBrutalTheme.neoRed),
                                  onPressed: () => provider.deleteUser(u.userId),
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
                    child: BispiraLineChart(isDark: isDark),
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
