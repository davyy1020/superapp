import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/admin_provider.dart';

class MitraRegistrationItem {
  final String id;
  final String name;
  final String owner;
  final String role; // 'Penjual', 'Driver', 'Cabang'
  final String categoryOrArmada;
  final String phone;
  final String city;
  final String date;
  String status; // 'Menunggu Verifikasi', 'Disetujui & Aktif'
  String? issuedId;
  String defaultPin;
  bool isWaSent;

  MitraRegistrationItem({
    required this.id,
    required this.name,
    required this.owner,
    required this.role,
    required this.categoryOrArmada,
    required this.phone,
    required this.city,
    required this.date,
    this.status = 'Menunggu Verifikasi',
    this.issuedId,
    this.defaultPin = '123456',
    this.isWaSent = false,
  });
}

class MitraApprovalTab extends StatefulWidget {
  const MitraApprovalTab({Key? key}) : super(key: key);

  @override
  State<MitraApprovalTab> createState() => _MitraApprovalTabState();
}

class _MitraApprovalTabState extends State<MitraApprovalTab> {
  String _searchQuery = '';
  String _selectedRoleFilter = 'SEMUA';

  final List<MitraRegistrationItem> _registrations = [
    // 1. Penjual Apotek
    MitraRegistrationItem(
      id: 'REG-20261125-01',
      name: 'Apotek Kimia Farma Simpang Lima',
      owner: 'apt. Dewi Sartika, S.Farm',
      role: 'Penjual',
      categoryOrArmada: 'Apotek & Farmasi (Obat Bebas & Resep)',
      phone: '081223344556',
      city: 'Kota Semarang',
      date: '25 Nov 2026, 19:40 WIB',
      status: 'Menunggu Verifikasi',
    ),
    // 2. Driver Mobil Box
    MitraRegistrationItem(
      id: 'REG-20261125-02',
      name: 'Budi Santoso (Kargo Box)',
      owner: 'Budi Santoso',
      role: 'Driver',
      categoryOrArmada: 'Mobil Box (Kargo Logistik Tertutup)',
      phone: '081398765432',
      city: 'Kota Semarang',
      date: '25 Nov 2026, 20:15 WIB',
      status: 'Menunggu Verifikasi',
    ),
    // 3. Driver Bak Terbuka
    MitraRegistrationItem(
      id: 'REG-20261125-03',
      name: 'Agus Sutrisno (Pickup Bak)',
      owner: 'Agus Sutrisno',
      role: 'Driver',
      categoryOrArmada: 'Bak Terbuka (Pickup Muatan)',
      phone: '085712349876',
      city: 'Kab. Demak',
      date: '25 Nov 2026, 20:25 WIB',
      status: 'Menunggu Verifikasi',
    ),
    // 4. Penjual Sewa Properti & Busana
    MitraRegistrationItem(
      id: 'REG-20261125-04',
      name: 'Griya Busana Adat & Toga Wisuda Cantika',
      owner: 'Ibu Ratna Kumala',
      role: 'Penjual',
      categoryOrArmada: 'Sewa Properti & Busana (Baju Wisuda & Kostum)',
      phone: '081566778899',
      city: 'Kota Semarang',
      date: '25 Nov 2026, 20:45 WIB',
      status: 'Menunggu Verifikasi',
    ),
    // 5. Penjual Tiket Mess & Wisata
    MitraRegistrationItem(
      id: 'REG-20261125-05',
      name: 'Wisma Atlet & MICE Training Center',
      owner: 'Hendra Gunawan',
      role: 'Penjual',
      categoryOrArmada: 'Tiket Mess & Wisata (Seminar & Penginapan)',
      phone: '082144556677',
      city: 'Kota Semarang',
      date: '25 Nov 2026, 21:00 WIB',
      status: 'Menunggu Verifikasi',
    ),
    // 6. Mitra Lisensi Cabang
    MitraRegistrationItem(
      id: 'REG-20261125-06',
      name: 'PT Bispira Kemitraan Solo Raya',
      owner: 'Bambang Pamungkas, S.E.',
      role: 'Cabang',
      categoryOrArmada: 'Lisensi Cabang Regional (Eksklusif 40%)',
      phone: '081122334455',
      city: 'Kota Surakarta (Solo)',
      date: '25 Nov 2026, 21:10 WIB',
      status: 'Menunggu Verifikasi',
    ),
    // 7. Penjual Kuliner (Contoh yang sudah di-ACC)
    MitraRegistrationItem(
      id: 'REG-20261125-07',
      name: 'Warung Makan Padang Sederhana Baru',
      owner: 'H. Syamsul Bahri',
      role: 'Penjual',
      categoryOrArmada: 'Kuliner & Resto (Bispira Food)',
      phone: '081298877665',
      city: 'Kota Semarang',
      date: '24 Nov 2026, 14:20 WIB',
      status: 'Disetujui & Aktif',
      issuedId: 'MRC-FOOD-9021',
      defaultPin: '123456',
      isWaSent: true,
    ),
  ];

  String _cleanPhoneForWhatsApp(String rawPhone) {
    String clean = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.startsWith('0')) {
      clean = '62' + clean.substring(1);
    } else if (clean.startsWith('8')) {
      clean = '62' + clean;
    }
    return clean;
  }

  void _approveRegistration(MitraRegistrationItem item) {
    setState(() {
      item.status = 'Disetujui & Aktif';
      if (item.issuedId == null) {
        final randDigits = (1000 + (item.hashCode.abs() % 9000)).toString();
        if (item.role == 'Penjual') {
          if (item.categoryOrArmada.contains('Apotek')) {
            item.issuedId = 'MRC-APT-$randDigits';
          } else if (item.categoryOrArmada.contains('Sewa')) {
            item.issuedId = 'MRC-PROP-$randDigits';
          } else if (item.categoryOrArmada.contains('Tiket')) {
            item.issuedId = 'MRC-TKT-$randDigits';
          } else {
            item.issuedId = 'MRC-FOOD-$randDigits';
          }
        } else if (item.role == 'Driver') {
          if (item.categoryOrArmada.contains('Box')) {
            item.issuedId = 'DRV-BOX-$randDigits';
          } else if (item.categoryOrArmada.contains('Bak')) {
            item.issuedId = 'DRV-BAK-$randDigits';
          } else {
            item.issuedId = 'DRV-RIDE-$randDigits';
          }
        } else {
          item.issuedId = 'CAB-REG-$randDigits';
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF059669),
        content: Text('✅ Akun Mitra ${item.name} berhasil DISETUJUI! ID: ${item.issuedId}, PIN: ${item.defaultPin}'),
      ),
    );
  }

  Future<void> _sendOneWayWhatsAppNotification(MitraRegistrationItem item) async {
    final phoneClean = _cleanPhoneForWhatsApp(item.phone);
    final String issuedId = item.issuedId ?? 'MRC-PENDING';
    final String roleTitle = item.role == 'Penjual' ? 'Mitra Toko / Penjual' : (item.role == 'Driver' ? 'Mitra Driver / Kargo' : 'Pemegang Lisensi Cabang');

    final String message = 
'''*BISPIRA SUPERAPP INDONESIA - KONFIRMASI RESMI AKUN MITRA*
--------------------------------------------------
Halo Yth. Bpk/Ibu *${item.owner}* (${item.name}),

Selamat! Pendaftaran kemitraan Anda telah *DISETUJUI (ACC)* oleh Superadmin BISPIRA Pusat. Akun resmi Anda kini telah *AKTIF*.

*Rincian Akun Resmi Anda:*
• Peran: $roleTitle
• Bidang / Armada: ${item.categoryOrArmada}
• Wilayah: ${item.city}
• ID Mitra Resmi: *$issuedId*
• PIN Keamanan Kasir: *${item.defaultPin}*
• Status: *AKTIF & TERVERIFIKASI*

*Tautan Akses Aplikasi:*
https://agungtrijayaabadi.com/superapp/

*PENTING (NOTIFIKASI RESMI SATU ARAH):*
Pesan ini dikirimkan secara otomatis oleh sistem Superadmin BISPIRA Pusat. Nomor ini *TIDAK DAPAT* menerima balasan pesan chat maupun panggilan telepon.
Silakan segera login ke aplikasi BISPIRA dan ubah PIN kasir demi keamanan privasi akun Anda.

Terima kasih telah bergabung bersama Ekosistem BISPIRA Indonesia! 🚀
--------------------------------------------------''';

    final waUrl = 'https://wa.me/$phoneClean?text=${Uri.encodeComponent(message)}';

    setState(() {
      item.isWaSent = true;
    });

    try {
      final uri = Uri.parse(waUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF25D366),
          content: Text('💬 WhatsApp Terbuka! Mengirim konfirmasi akun resmi satu arah gratis ke $phoneClean (${item.name}).'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Gagal membuka WhatsApp: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = adminProvider.isDarkMode;

    final filteredList = _registrations.where((item) {
      if (_selectedRoleFilter != 'SEMUA' && item.role.toUpperCase() != _selectedRoleFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return item.name.toLowerCase().contains(q) ||
            item.owner.toLowerCase().contains(q) ||
            item.phone.contains(q) ||
            item.categoryOrArmada.toLowerCase().contains(q) ||
            item.city.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    final int totalCount = _registrations.length;
    final int pendingCount = _registrations.where((i) => i.status == 'Menunggu Verifikasi').length;
    final int approvedCount = _registrations.where((i) => i.status == 'Disetujui & Aktif').length;
    final int waSentCount = _registrations.where((i) => i.isWaSent).length;

    return Container(
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP HEADER & EXPLANATION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF25D366), width: 1.5),
                        ),
                        child: const Icon(Icons.how_to_reg_rounded, color: Color(0xFF25D366), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Persetujuan Mitra Baru & Konfirmasi WA (Gratis)',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Verifikasi pendaftar dari Web Landing Portal (Penjual, Driver Box/Bak, Lisensi Cabang) & kirim WhatsApp 1 arah tanpa biaya vendor.',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. METRIC STATS CARDS
          Row(
            children: [
              _buildStatCard(
                title: 'Total Pendaftar',
                value: '$totalCount Mitra',
                sub: 'Masuk dari Web Portal',
                color: const Color(0xFF2563EB),
                icon: Icons.people_outline_rounded,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              _buildStatCard(
                title: 'Menunggu ACC Admin',
                value: '$pendingCount Mitra',
                sub: 'Belum diterbitkan akun',
                color: const Color(0xFFF59E0B),
                icon: Icons.hourglass_top_rounded,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              _buildStatCard(
                title: 'Akun Aktif / Terbit',
                value: '$approvedCount Mitra',
                sub: 'ID Mitra & PIN aktif',
                color: const Color(0xFF10B981),
                icon: Icons.check_circle_outline_rounded,
                isDark: isDark,
              ),
              const SizedBox(width: 14),
              _buildStatCard(
                title: 'Konfirmasi WA Terkirim',
                value: '$waSentCount Mitra',
                sub: 'Protokol WA 1-Arah Gratis',
                color: const Color(0xFF25D366),
                icon: Icons.send_rounded,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. SEARCH & ROLE FILTER TABS
          Row(
            children: [
              // Search Input
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, size: 20, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Cari nama usaha, pemilik, no WhatsApp, armada, atau kota...',
                            hintStyle: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Filter Chips
              _buildRoleFilterBtn('SEMUA', 'Semua Mitra', isDark),
              const SizedBox(width: 8),
              _buildRoleFilterBtn('PENJUAL', '🏪 Penjual (Merchant)', isDark),
              const SizedBox(width: 8),
              _buildRoleFilterBtn('DRIVER', '🚚 Driver & Kargo', isDark),
              const SizedBox(width: 8),
              _buildRoleFilterBtn('CABANG', '🏢 Lisensi Cabang', isDark),
            ],
          ),
          const SizedBox(height: 18),

          // 4. REGISTRATIONS TABLE
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: ListView.separated(
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    final bool isApproved = item.status == 'Disetujui & Aktif';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Role Badge Icon
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: item.role == 'Penjual'
                                  ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                                  : (item.role == 'Driver' ? const Color(0xFF2563EB).withValues(alpha: 0.15) : const Color(0xFF7C3AED).withValues(alpha: 0.15)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                item.role == 'Penjual' ? '🏪' : (item.role == 'Driver' ? '🚚' : '🏢'),
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Name & Category
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.role.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${item.owner} • ${item.categoryOrArmada}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '📍 ${item.city} • 📅 ${item.date}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Phone & Account Info
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.phone_iphone_rounded, size: 14, color: Color(0xFF25D366)),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.phone,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (isApproved) ...[
                                  Text(
                                    'ID: ${item.issuedId} • PIN: ${item.defaultPin}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ] else ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      '⏳ Menunggu Verifikasi',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFD97706),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Action Buttons
                          Row(
                            children: [
                              // 1. Tombol ACC & Terbitkan Akun
                              if (!isApproved) ...[
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.check_rounded, size: 16),
                                  label: const Text(
                                    'ACC & Terbitkan Akun',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                                  ),
                                  onPressed: () => _approveRegistration(item),
                                ),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.verified_rounded, size: 16, color: Color(0xFF10B981)),
                                      SizedBox(width: 4),
                                      Text(
                                        'Terverifikasi',
                                        style: TextStyle(color: Color(0xFF10B981), fontSize: 11.5, fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(width: 10),

                              // 2. Tombol Kirim WhatsApp (Gratis)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF25D366),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                                label: Text(
                                  item.isWaSent ? 'Kirim Ulang WA (1-Arah)' : 'Kirim Konfirmasi WA (Gratis)',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                                ),
                                onPressed: () {
                                  if (!isApproved) {
                                    _approveRegistration(item);
                                  }
                                  _sendOneWayWhatsAppNotification(item);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String sub,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleFilterBtn(String key, String label, bool isDark) {
    final isSelected = _selectedRoleFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedRoleFilter = key),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB)
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: isSelected ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
            ),
          ),
        ),
      ),
    );
  }
}
