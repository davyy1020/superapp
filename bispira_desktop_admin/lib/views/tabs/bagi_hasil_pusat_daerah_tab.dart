import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_provider.dart';

class BagiHasilPusatDaerahTab extends StatefulWidget {
  const BagiHasilPusatDaerahTab({Key? key}) : super(key: key);

  @override
  State<BagiHasilPusatDaerahTab> createState() => _BagiHasilPusatDaerahTabState();
}

class _BagiHasilPusatDaerahTabState extends State<BagiHasilPusatDaerahTab> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final currencyFmtDec = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedSchemeFilter = 'SEMUA';

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _getSchemeColor(String scheme) {
    if (scheme.contains('75%:25%')) return const Color(0xFF2563EB); // Blue
    if (scheme.contains('100%:0%')) return const Color(0xFF16A34A); // Green
    if (scheme.contains('20%:80%')) return const Color(0xFFEA580C); // Orange
    if (scheme.contains('60%:40%')) return const Color(0xFF9333EA); // Purple
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final allItems = provider.bagiHasilList;
    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.wilayahKabKota.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.provinsi.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesScheme = true;
      if (_selectedSchemeFilter == 'KERJASAMA') {
        matchesScheme = item.isKerjasamaPusatDaerah;
      } else if (_selectedSchemeFilter == 'TANPA_KERJASAMA') {
        matchesScheme = item.isTanpaKerjasama;
      } else if (_selectedSchemeFilter == 'EVENT_MANDIRI') {
        matchesScheme = item.isEventMandiri;
      }

      return matchesSearch && matchesScheme;
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
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: const Icon(Icons.pie_chart_rounded, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SKEMA BAGI HASIL PUSAT & DAERAH (SHEET 7)',
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
                          color: const Color(0xFF10B981).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.event_available_rounded, size: 16, color: Color(0xFF10B981)),
                            SizedBox(width: 6),
                            Text(
                              'Jadwal Bayar: Tgl 1 Awal Bulan',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: Color(0xFF10B981)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kerjasama (75%:25%) | Tanpa Kerjasama (100%:0%) | Event Mandiri Daerah (20%:80%) | Dibayarkan Setiap Tanggal 1 Awal Bulan',
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
                    title: 'TOTAL WILAYAH KAB/KOTA',
                    value: '${provider.totalWilayahBagiHasil} Wilayah',
                    subtitle: '29 Cabang Regional Aktif',
                    color: const Color(0xFF6366F1),
                    icon: Icons.location_city_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildKpiCard(
                    title: 'NET PROFIT SUPERADMIN',
                    value: currencyFmt.format(provider.totalNetProfitSuperadmin),
                    subtitle: 'Formula: SUMIF Sheet 1 Kolom U',
                    color: const Color(0xFF0284C7),
                    icon: Icons.account_balance_wallet_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildKpiCard(
                    title: 'TOTAL PORSI PUSAT',
                    value: currencyFmtDec.format(provider.totalPorsiPusat),
                    subtitle: '87.75% Akumulasi Net Profit',
                    color: const Color(0xFF10B981),
                    icon: Icons.domain_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildKpiCard(
                    title: 'TOTAL PORSI ADMIN DAERAH',
                    value: currencyFmtDec.format(provider.totalPorsiAdminDaerah),
                    subtitle: '12.25% Hak Admin Cabang',
                    color: const Color(0xFFF59E0B),
                    icon: Icons.handshake_rounded,
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
                        hintText: 'Cari nama Kabupaten / Kota atau Provinsi...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  _buildFilterChip('SEMUA', 'Semua Skema (${allItems.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip('KERJASAMA', 'Kerjasama 75:25'),
                  const SizedBox(width: 8),
                  _buildFilterChip('TANPA_KERJASAMA', 'Tanpa Kerjasama 100:0'),
                  const SizedBox(width: 8),
                  _buildFilterChip('EVENT_MANDIRI', 'Event Mandiri 20:80'),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // DATA TABLE (8 KOLOM SESUAI EXCEL SHEET 7)
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
                      constraints: const BoxConstraints(minWidth: 1200),
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
                        ),
                        headingRowHeight: 46,
                        dataRowHeight: 44,
                        columnSpacing: 22,
                        columns: const [
                          DataColumn(label: Text('No', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('Wilayah Kab / Kota', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('Provinsi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(label: Text('Status Skema Kerjasama', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(numeric: true, label: Text('Net Profit Superadmin (Rp)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                          DataColumn(numeric: true, label: Text('Porsi Pusat (Rp)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF10B981)))),
                          DataColumn(numeric: true, label: Text('Porsi Admin Daerah (Rp)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFFF59E0B)))),
                          DataColumn(label: Text('Jadwal Pembayaran', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                        ],
                        rows: [
                          ...filtered.map((item) {
                            final schemeColor = _getSchemeColor(item.statusSkemaKerjasama);

                            return DataRow(
                              cells: [
                                DataCell(Text('${item.no}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                                DataCell(
                                  Text(
                                    item.wilayahKabKota,
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5),
                                  ),
                                ),
                                DataCell(Text(item.provinsi, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: schemeColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: schemeColor, width: 1.2),
                                    ),
                                    child: Text(
                                      item.statusSkemaKerjasama,
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: schemeColor),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    currencyFmt.format(item.netProfitSuperadmin),
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    currencyFmtDec.format(item.porsiPusat),
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: Color(0xFF10B981)),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item.porsiAdminDaerah > 0 ? currencyFmtDec.format(item.porsiAdminDaerah) : 'Rp 0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.5,
                                      color: item.porsiAdminDaerah > 0 ? const Color(0xFFF59E0B) : Colors.grey,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.blueGrey),
                                      const SizedBox(width: 6),
                                      Text(item.jadwalPembayaran, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),

                          // STICKY TOTAL FOOTER ROW (ROW 34 SESUAI EXCEL)
                          DataRow(
                            color: MaterialStateProperty.all(
                              const Color(0xFF2563EB).withOpacity(0.15),
                            ),
                            cells: [
                              const DataCell(Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                              const DataCell(Text('TOTAL SELURUH KAB/KOTA (BARIS 34)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5))),
                              const DataCell(Text('-')),
                              const DataCell(Text('29 Wilayah Terdaftar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5))),
                              DataCell(
                                Text(
                                  currencyFmt.format(provider.totalNetProfitSuperadmin),
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF0284C7)),
                                ),
                              ),
                              DataCell(
                                Text(
                                  currencyFmtDec.format(provider.totalPorsiPusat),
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF10B981)),
                                ),
                              ),
                              DataCell(
                                Text(
                                  currencyFmtDec.format(provider.totalPorsiAdminDaerah),
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFFF59E0B)),
                                ),
                              ),
                              const DataCell(Text('Tgl 1 Awal Bulan', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SKEMA KONTRAK REFERENCE CARD (BARIS 38 - 43 EXCEL)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.gavel_rounded, color: Color(0xFF2563EB), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'MASTER REGULASI SKEMA KERJASAMA (BARIS 38-43 EXCEL SHEET 7)',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.black, height: 1, thickness: 1),
                  const SizedBox(height: 12),
                  _buildSchemeItem(
                    no: '1',
                    name: 'Kerjasama Pusat & Daerah (75%:25%)',
                    desc: 'Admin Daerah berlisensi resmi. Pusat 75% • Daerah 25% dari Net Profit Platform.',
                    color: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 8),
                  _buildSchemeItem(
                    no: '2',
                    name: 'Tanpa Kerjasama (100%:0%)',
                    desc: 'Wilayah operasional langsung Superadmin Pusat tanpa cabang lokal. Hak Pusat 100%.',
                    color: const Color(0xFF16A34A),
                  ),
                  const SizedBox(height: 8),
                  _buildSchemeItem(
                    no: '3',
                    name: 'Event Lomba Mandiri Daerah (20%:80%)',
                    desc: 'Event atau kampanye mandiri inisiasi cabang lokal (contoh: Kab. Subang). Pusat 20% • Daerah 80%.',
                    color: const Color(0xFFEA580C),
                  ),
                  const SizedBox(height: 8),
                  _buildSchemeItem(
                    no: '4',
                    name: 'Evoting Populer Pusat dan Daerah (60%:40%)',
                    desc: 'Polling berbayar atau voting kolaborasi Pusat dan Daerah. Pusat 60% • Daerah 40%.',
                    color: const Color(0xFF9333EA),
                  ),
                  const SizedBox(height: 8),
                  _buildSchemeItem(
                    no: '5',
                    name: 'Evoting Populer Mandiri Pusat (100%:0%)',
                    desc: 'Voting nasional inisiasi langsung Pusat. Hak Pusat 100%.',
                    color: const Color(0xFF0D9488),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedSchemeFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedSchemeFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
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

  Widget _buildSchemeItem({
    required String no,
    required String name,
    required String desc,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              no,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
