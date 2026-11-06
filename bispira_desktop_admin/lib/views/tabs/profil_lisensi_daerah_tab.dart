import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class ProfilLisensiDaerahTab extends StatefulWidget {
  const ProfilLisensiDaerahTab({Key? key}) : super(key: key);

  @override
  State<ProfilLisensiDaerahTab> createState() => _ProfilLisensiDaerahTabState();
}

class _ProfilLisensiDaerahTabState extends State<ProfilLisensiDaerahTab> {
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedBankFilter = 'SEMUA';

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _getBankBadgeColor(String bank) {
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allItems = provider.profilLisensiDaerahList;
    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.namaPembeliLisensi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.kabupatenKota.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.rekeningBankAktif.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesBank = true;
      if (_selectedBankFilter != 'SEMUA') {
        matchesBank = item.rekeningBankAktif.toUpperCase().contains(_selectedBankFilter);
      }

      return matchesSearch && matchesBank;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1329) : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER TITLE BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: const Icon(Icons.badge_rounded, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MASTER PROFIL PEMBELI LISENSI ADMIN DAERAH (SHEET 8)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'PT. SITEKUN ACADEMY PERDASA • BISPIRA HYPERLOCAL ECOSYSTEM',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF0D9488), width: 1.5),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF0D9488)),
                            SizedBox(width: 6),
                            Text(
                              '12 Lisensi Kabupaten/Kota Aktif',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: Color(0xFF0D9488)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Data Pemegang Lisensi Resmi Kabupaten/Kota Aktif, Akun Rekening Bank Operasional, Armada Penjual & Driver, Serta Event Bispira.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.grey[300] : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4 KPI SUMMARY CARDS
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'TOTAL LISENSI RESMI',
                    value: '${provider.totalLisensiDaerahCount} Lisensi',
                    subtitle: '12 Admin Cabang Regional',
                    color: const Color(0xFF0D9488),
                    icon: Icons.assignment_ind_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildKpiCard(
                    title: 'TOTAL PENJUAL AKTIF',
                    value: '${provider.totalPenjualMitraDaerah} Toko',
                    subtitle: 'Terverifikasi di 12 Wilayah',
                    color: const Color(0xFF2563EB),
                    icon: Icons.storefront_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildKpiCard(
                    title: 'TOTAL DRIVER AKTIF',
                    value: '${provider.totalDriverMitraDaerah} Driver',
                    subtitle: 'Armada Motor, Mobil, Logistik',
                    color: const Color(0xFF10B981),
                    icon: Icons.two_wheeler_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildKpiCard(
                    title: 'TOTAL EVENT DAERAH',
                    value: '${provider.totalSeluruhEventDaerah} Event',
                    subtitle: '${provider.totalEventBispiraDaerah} Bispira • ${provider.totalEventKompetisiDaerah} Lomba • ${provider.totalEventEvotingDaerah} Voting',
                    color: const Color(0xFFF59E0B),
                    icon: Icons.celebration_rounded,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // SEARCH & FILTER BAR
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black, width: 1.8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Cari nama pembeli lisensi, kabupaten / kota, atau bank...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  _buildFilterChip('SEMUA', 'Semua Bank (${allItems.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip('JATENG', 'Bank Jateng'),
                  const SizedBox(width: 8),
                  _buildFilterChip('MANDIRI', 'Bank Mandiri'),
                  const SizedBox(width: 8),
                  _buildFilterChip('BCA', 'BCA'),
                  const SizedBox(width: 8),
                  _buildFilterChip('BNI', 'BNI'),
                  const SizedBox(width: 8),
                  _buildFilterChip('BJB', 'Bank BJB'),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // DATA TABLE (11 KOLOM SESUAI EXCEL SHEET 8)
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Scrollbar(
                  controller: _horizontalScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 1300),
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
                        ),
                        headingRowHeight: 46,
                        dataRowHeight: 46,
                        columnSpacing: 18,
                        columns: const [
                          DataColumn(label: Text('No', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('Nama Pembeli Lisensi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('Kabupaten / Kota', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('No. WA/Telepon', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('Rekening Bank Aktif', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('Nama Pemilik Rekening', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(numeric: true, label: Text('Jumlah Penjual', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF2563EB)))),
                          DataColumn(numeric: true, label: Text('Jumlah Driver', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF10B981)))),
                          DataColumn(numeric: true, label: Text('Event Bispira', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(numeric: true, label: Text('Event Kompetisi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(numeric: true, label: Text('Event E-Voting', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                        ],
                        rows: [
                          ...filtered.map((item) {
                            final bankColor = _getBankBadgeColor(item.rekeningBankAktif);

                            return DataRow(
                              cells: [
                                DataCell(Text('${item.no}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                                DataCell(
                                  Row(
                                    children: [
                                      const Icon(Icons.person_pin_rounded, size: 16, color: Color(0xFF0D9488)),
                                      const SizedBox(width: 8),
                                      Text(
                                        item.namaPembeliLisensi,
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item.kabupatenKota,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                                  ),
                                ),
                                DataCell(Text(item.noWaTelepon, style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey, fontWeight: FontWeight.w600))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: bankColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: bankColor, width: 1.2),
                                    ),
                                    child: Text(
                                      item.rekeningBankAktif,
                                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: bankColor),
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.namaPemilikRekening, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                                DataCell(
                                  Text(
                                    '${item.jumlahPenjualAktif} Toko',
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: Color(0xFF2563EB)),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.jumlahDriverAktif} Driver',
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: Color(0xFF10B981)),
                                  ),
                                ),
                                DataCell(Text('${item.jumlahEventBispira}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))),
                                DataCell(Text('${item.jumlahEventKompetisi}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))),
                                DataCell(Text('${item.jumlahEventEvoting}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))),
                              ],
                            );
                          }),

                          // STICKY TOTAL FOOTER ROW
                          DataRow(
                            color: MaterialStateProperty.all(
                              const Color(0xFF0D9488).withOpacity(0.15),
                            ),
                            cells: [
                              const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                              const DataCell(Text('TOTAL SELURUH LISENSI RESMI', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5))),
                              const DataCell(Text('12 Wilayah', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12))),
                              const DataCell(Text('-')),
                              const DataCell(Text('9 Bank Mitra', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5))),
                              const DataCell(Text('-')),
                              DataCell(
                                Text(
                                  '${provider.totalPenjualMitraDaerah} Toko',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF2563EB)),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${provider.totalDriverMitraDaerah} Driver',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF10B981)),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${provider.totalEventBispiraDaerah}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${provider.totalEventKompetisiDaerah}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${provider.totalEventEvotingDaerah}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedBankFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedBankFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D9488) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade400,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

