import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/pendapatan_superadmin_matrix_data.dart';

class PendapatanSuperadminTab extends StatefulWidget {
  const PendapatanSuperadminTab({Key? key}) : super(key: key);

  @override
  State<PendapatanSuperadminTab> createState() => _PendapatanSuperadminTabState();
}

class _PendapatanSuperadminTabState extends State<PendapatanSuperadminTab> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  String _searchQuery = '';
  String _selectedCategoryFilter = 'SEMUA';

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allItems = PendapatanSuperadminMatrixData.clusterItems;

    final filtered = allItems.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.bidangCluster.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.penjual.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.hargaDasar.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesCat = true;
      if (_selectedCategoryFilter == 'RIDE_HAILING') {
        matchesCat = item.penjual == 'Ride Hailing';
      } else if (_selectedCategoryFilter == 'MERCHANT') {
        matchesCat = item.penjual == 'Merchant';
      } else if (_selectedCategoryFilter == 'EVENT_VOTING') {
        matchesCat = item.bidangCluster.toLowerCase().contains('event') ||
            item.bidangCluster.toLowerCase().contains('voting');
      } else if (_selectedCategoryFilter == 'DONASI_IKLAN') {
        matchesCat = item.bidangCluster.toLowerCase().contains('donasi') ||
            item.bidangCluster.toLowerCase().contains('iklan');
      }

      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        controller: _verticalScrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP TITLE BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
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
                              color: const Color(0xFF7C3AED),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'PEDOMAN PENDAPATAN SUPERADMIN & BAGI HASIL (SHEET 12)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'PT. SITEKUN ACADEMY PERDASA • BISPIRA HYPERLOCAL ECOSYSTEM',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_rounded, size: 16, color: Color(0xFF10B981)),
                            SizedBox(width: 6),
                            Text(
                              'Sheet 12 Terverifikasi',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: Color(0xFF10B981)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pedoman 16 Cluster Pendapatan Intermediasi: 7 Pilar Pendapatan Superadmin & Matriks 5 Skema Bagi Hasil Net Profit Pusat vs Daerah (75:25, 100:0, 20:80, 60:40).',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. 7 PILAR PENDAPATAN SUPERADMIN CARDS
            const Text(
              '7 PILAR PENDAPATAN SUPERADMIN PER TRANSAKSI',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              children: PendapatanSuperadminMatrixData.pilarPendapatan.map((p) {
                final colors = [
                  const Color(0xFFF59E0B),
                  const Color(0xFF06B6D4),
                  const Color(0xFF10B981),
                  const Color(0xFFA855F7),
                  const Color(0xFFEC4899),
                  const Color(0xFF3B82F6),
                  const Color(0xFF64748B),
                ];
                final idx = int.tryParse(p['no'] ?? '1') ?? 1;
                final col = colors[(idx - 1) % colors.length];

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1.5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#${p['no']}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                p['name'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: col, fontWeight: FontWeight.w900, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p['value'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          p['desc'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // 3. 5 SKEMA BAGI HASIL NET PROFIT CHIPS
            Row(
              children: [
                const Text(
                  'SKEMA BAGI HASIL: ',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.black),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: PendapatanSuperadminMatrixData.skemaBagiHasil.map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${s['kode']}: ',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF475569)),
                            ),
                            Text(
                              s['rasio'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFF0F172A)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // 4. SEARCH & FILTER TOOLBAR
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black, width: 1.8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Cari nama cluster, entitas penjual, atau harga dasar...',
                        prefixIcon: const Icon(Icons.search, size: 18, color: Colors.black),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black, width: 1.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Category Chips
                  Wrap(
                    spacing: 6,
                    children: [
                      _buildFilterChip('SEMUA', 'Semua (16)'),
                      _buildFilterChip('RIDE_HAILING', 'Ride Hailing'),
                      _buildFilterChip('MERCHANT', 'Merchant'),
                      _buildFilterChip('EVENT_VOTING', 'Event & Voting'),
                      _buildFilterChip('DONASI_IKLAN', 'Donasi & Iklan'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 5. AUTHENTIC EXCEL SPREADSHEET TABLE (21 COLUMNS)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 44,
                      dataRowMinHeight: 38,
                      dataRowMaxHeight: 44,
                      horizontalMargin: 14,
                      columnSpacing: 16,
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF4A154B)),
                      columns: const [
                        DataColumn(label: Text('No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('BIDANG CLUSTER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('PENJUAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('HARGA DASAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('1. MARKUP', style: TextStyle(color: Color(0xFFFEF08A), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('2. LAYANAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('3. REGULER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('4. PREMIUM 30H', style: TextStyle(color: Color(0xFFD8B4FE), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('5. KODE UNIK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('6. KOMISI', style: TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('7. PENCAIRAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('KERJASAMA (Pusat)', style: TextStyle(color: Color(0xFF86EFAC), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('KERJASAMA (Daerah)', style: TextStyle(color: Color(0xFF86EFAC), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('NON-KERJA (Pusat)', style: TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('NON-KERJA (Daerah)', style: TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('MANDIRI (Pusat)', style: TextStyle(color: Color(0xFFFDE68A), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('MANDIRI (Daerah)', style: TextStyle(color: Color(0xFFFDE68A), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('EVOTING K (Pusat)', style: TextStyle(color: Color(0xFFE9D5FF), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('EVOTING K (Daerah)', style: TextStyle(color: Color(0xFFE9D5FF), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('EVOTING P (Pusat)', style: TextStyle(color: Color(0xFFFBCFE8), fontWeight: FontWeight.w900, fontSize: 11))),
                        DataColumn(label: Text('EVOTING P (Daerah)', style: TextStyle(color: Color(0xFFFBCFE8), fontWeight: FontWeight.w900, fontSize: 11))),
                      ],
                      rows: filtered.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text('${item.no}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
                            DataCell(Text(item.bidangCluster, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.penjual == 'Ride Hailing'
                                      ? const Color(0xFFFEF3C7)
                                      : item.penjual == 'Merchant'
                                          ? const Color(0xFFE0F2FE)
                                          : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: Text(
                                  item.penjual.isEmpty ? '-' : item.penjual,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                                ),
                              ),
                            ),
                            DataCell(Text(item.hargaDasar.isEmpty ? '-' : item.hargaDasar, style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569)))),
                            DataCell(Text(item.markupLabel, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFD97706), fontSize: 11))),
                            DataCell(Text(item.biayaLayanan, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
                            DataCell(Text(item.biayaAplikasiReguler, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
                            DataCell(Text(item.biayaAplikasiPremium, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF7C3AED), fontSize: 11))),
                            DataCell(Text(item.kodeUnikBank, style: const TextStyle(fontSize: 11, color: Color(0xFFDB2777), fontWeight: FontWeight.w800))),
                            DataCell(Text(item.komisiLabel, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2563EB), fontSize: 11))),
                            DataCell(Text(item.biayaPencairan, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                            // BAGI HASIL
                            DataCell(Text('${(item.kerjasamaPusat * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF16A34A)))),
                            DataCell(Text('${(item.kerjasamaDaerah * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF16A34A)))),
                            DataCell(Text('${(item.tanpaKerjasamaPusat * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2563EB)))),
                            DataCell(Text('${(item.tanpaKerjasamaDaerah * 100).toInt()}%', style: const TextStyle(color: Color(0xFF94A3B8)))),
                            DataCell(Text(item.eventMandiriPusat != null ? '${(item.eventMandiriPusat! * 100).toInt()}%' : '-', style: const TextStyle(color: Color(0xFFD97706)))),
                            DataCell(Text(item.eventMandiriDaerah != null ? '${(item.eventMandiriDaerah! * 100).toInt()}%' : '-', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFD97706)))),
                            DataCell(Text(item.evotingKerjasamaPusat != null ? '${(item.evotingKerjasamaPusat! * 100).toInt()}%' : '-', style: const TextStyle(color: Color(0xFF7C3AED)))),
                            DataCell(Text(item.evotingKerjasamaDaerah != null ? '${(item.evotingKerjasamaDaerah! * 100).toInt()}%' : '-', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF7C3AED)))),
                            DataCell(Text(item.evotingPusatPusat != null ? '${(item.evotingPusatPusat! * 100).toInt()}%' : '-', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFDB2777)))),
                            DataCell(Text(item.evotingPusatDaerah != null ? '${(item.evotingPusatDaerah! * 100).toInt()}%' : '-', style: const TextStyle(color: Color(0xFF94A3B8)))),
                          ],
                        );
                      }).toList(),
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
    final bool isSel = _selectedCategoryFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSel ? Colors.white : Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
