import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class DashboardOverviewTab extends StatelessWidget {
  const DashboardOverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final bgCard = NeoBrutalTheme.getBgCard(isDark);
    final textPrimary = NeoBrutalTheme.getTextPrimary(isDark);
    final textSecondary = NeoBrutalTheme.getTextSecondary(isDark);
    final borderSubtle = NeoBrutalTheme.getBorderSubtle(isDark);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xFF0066FF).withValues(alpha: 0.15),
                              const Color(0xFF00AAFF).withValues(alpha: 0.08),
                            ]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.dashboard_customize_rounded, color: Color(0xFF0066FF), size: 20),
                        ),
                        const SizedBox(width: 14),
                        Flexible(
                          child: Text(
                            'BISPIRA Executive Command Center',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.3),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pusat kendali desktop, verifikasi manual mutasi bank, batch payout 17:00 WIB, dan rekapitulasi finansial.',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const NeoBrutalBadge(text: 'Flutter Desktop Native', bgColor: NeoBrutalTheme.bispiraBlue),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Grid Cards
          GridView.count(
            crossAxisCount: 4, crossAxisSpacing: 14, mainAxisSpacing: 14,
            childAspectRatio: 1.75, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(title: 'Total User Terdaftar', value: '${provider.totalUsers}', footer: 'Pelanggan Aktif', badgeText: '+12.4%', accentColor: NeoBrutalTheme.bispiraBlue, icon: Icons.people_alt_rounded, isDark: isDark),
              _buildStatCard(title: 'Driver Terverifikasi', value: '${provider.totalDrivers}', footer: '${provider.driversOnline} Online', badgeText: '+8.2%', accentColor: NeoBrutalTheme.neoGreen, icon: Icons.two_wheeler_rounded, isDark: isDark),
              _buildStatCard(title: 'Merchant & Layanan', value: '520', footer: 'Food, Health & Ambulance', badgeText: '+5.1%', accentColor: NeoBrutalTheme.neoCyan, icon: Icons.storefront_rounded, isDark: isDark),
              _buildStatCard(title: 'Revenue Platform', value: 'Rp 48,250,000', footer: 'Markup & Admin Fee', badgeText: '+15.8%', accentColor: NeoBrutalTheme.neoPurple, icon: Icons.account_balance_wallet_rounded, isDark: isDark),
            ],
          ),
          const SizedBox(height: 24),

          // Charts Section 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: NeoBrutalCard(isDark: isDark, bgColor: bgCard, padding: const EdgeInsets.all(22), child: BispiraBarChart(isDark: isDark))),
              const SizedBox(width: 16),
              Expanded(flex: 5, child: NeoBrutalCard(isDark: isDark, bgColor: bgCard, padding: const EdgeInsets.all(22), child: BispiraDonutChart(isDark: isDark))),
            ],
          ),
          const SizedBox(height: 24),

          // Charts Section 2
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: NeoBrutalCard(isDark: isDark, bgColor: bgCard, padding: const EdgeInsets.all(22), child: BispiraLineChart(isDark: isDark))),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: NeoBrutalCard(
                  isDark: isDark, bgColor: bgCard, padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.checklist_rtl_rounded, color: NeoBrutalTheme.bispiraBlue, size: 20),
                            const SizedBox(width: 10),
                            Text('Status Operasional & Tugas Tim', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: textPrimary)),
                          ]),
                          const NeoBrutalBadge(text: '4 Active', bgColor: NeoBrutalTheme.bispiraBlue),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTaskRow('Verifikasi Mutasi Bank BISPIRA', '3 Transaksi Menunggu', true, isDark, textPrimary, textSecondary),
                      Divider(color: borderSubtle, height: 18),
                      _buildTaskRow('Batch Payout Pukul 17:00 WIB', 'Jadwal Otomatis Siap', true, isDark, textPrimary, textSecondary),
                      Divider(color: borderSubtle, height: 18),
                      _buildTaskRow('Monitoring GIS OSRM Engine', '44 Cabang Normal', false, isDark, textPrimary, textSecondary),
                      Divider(color: borderSubtle, height: 18),
                      _buildTaskRow('Audit Log System Security', 'Keamanan Verified 100%', false, isDark, textPrimary, textSecondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Financial Table
          NeoBrutalCard(
            isDark: isDark, bgColor: bgCard, padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NeoBrutalTheme.bispiraBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.table_chart_rounded, color: NeoBrutalTheme.bispiraBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('Rekapitulasi Finansial Pusat (CAPEX, OPEX & Pemasukan)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                    ]),
                    const NeoBrutalBadge(text: 'Tahun 2026', bgColor: NeoBrutalTheme.bispiraBlue),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: borderSubtle),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      border: TableBorder.all(color: borderSubtle, width: 1.0),
                      columns: [
                        DataColumn(label: Text('Kategori Finansial', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                        DataColumn(label: Text('Deskripsi Item Excel', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                        DataColumn(label: Text('Januari', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                        DataColumn(label: Text('Februari', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                        DataColumn(label: Text('Maret', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                        DataColumn(label: Text('April', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                        DataColumn(label: Text('Total 2026', style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 13.5))),
                      ],
                      rows: [
                        DataRow(
                          color: WidgetStateProperty.all(isDark ? const Color(0xFF1E293B) : Colors.white),
                          cells: [
                            DataCell(Text('CAPEX Pusat', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 13))),
                            DataCell(Text('Server OSRM GIS, Cluster Server & Infrastruktur', style: TextStyle(color: textSecondary, fontSize: 13))),
                            DataCell(Text('Rp 15.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 5.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 5.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 5.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            const DataCell(Text('Rp 30.000.000', style: TextStyle(fontWeight: FontWeight.w800, color: NeoBrutalTheme.neoRed, fontSize: 13))),
                          ],
                        ),
                        DataRow(
                          color: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                          cells: [
                            DataCell(Text('OPEX Pusat', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 13))),
                            DataCell(Text('Gaji Tim IT, Ops, Legalitas & Lisensi Cabang', style: TextStyle(color: textSecondary, fontSize: 13))),
                            DataCell(Text('Rp 22.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 22.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 22.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 22.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            const DataCell(Text('Rp 88.000.000', style: TextStyle(fontWeight: FontWeight.w800, color: NeoBrutalTheme.neoRed, fontSize: 13))),
                          ],
                        ),
                        DataRow(
                          color: WidgetStateProperty.all(isDark ? const Color(0xFF1E293B) : Colors.white),
                          cells: [
                            const DataCell(Text('Pemasukan Pusat', style: TextStyle(fontWeight: FontWeight.w800, color: NeoBrutalTheme.neoGreen, fontSize: 13))),
                            DataCell(Text('Lisensi Franchise, Komisi Markup 10%, App Fee & Ads', style: TextStyle(color: textSecondary, fontSize: 13))),
                            DataCell(Text('Rp 45.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 52.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 60.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            DataCell(Text('Rp 68.000.000', style: TextStyle(color: textPrimary, fontSize: 13))),
                            const DataCell(Text('Rp 225.000.000', style: TextStyle(fontWeight: FontWeight.w800, color: NeoBrutalTheme.neoGreen, fontSize: 13))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Audit Logs
          NeoBrutalCard(
            isDark: isDark, bgColor: bgCard, padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NeoBrutalTheme.neoGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.terminal_rounded, color: NeoBrutalTheme.neoGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('Desktop Event Audit Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                    ]),
                    NeoBrutalButton(
                      label: 'Hapus Log', onPressed: () => provider.clearLogs(),
                      bgColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF1F5F9),
                      textColor: isDark ? Colors.white : const Color(0xFF475569),
                      borderColor: borderSubtle, fontSize: 12.5,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 180, padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderSubtle, width: 1.0),
                  ),
                  child: ListView.builder(
                    itemCount: provider.auditLogs.length,
                    itemBuilder: (context, index) {
                      final log = provider.auditLogs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          '[${log['time']}] ${log['text']}',
                          style: TextStyle(
                            fontFamily: 'monospace', fontSize: 12.5, fontWeight: FontWeight.w600,
                            color: log['type'] == 'success' ? (isDark ? const Color(0xFF10B981) : const Color(0xFF059669))
                                : log['type'] == 'info' ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7))
                                : (isDark ? NeoBrutalTheme.neoYellow : const Color(0xFFD97706)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title, required String value, required String footer,
    required String badgeText, required Color accentColor, required IconData icon, required bool isDark,
  }) {
    final textPrimary = NeoBrutalTheme.getTextPrimary(isDark);
    final textSecondary = NeoBrutalTheme.getTextSecondary(isDark);

    return SmoothHoverCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [accentColor.withValues(alpha: 0.18), accentColor.withValues(alpha: 0.08)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, color: accentColor, size: 12),
                    const SizedBox(width: 4),
                    Text(badgeText, style: TextStyle(color: accentColor, fontWeight: FontWeight.w700, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary)),
          Text(footer, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTaskRow(String title, String subtitle, bool isUrgent, bool isDark, Color textPrimary, Color textSecondary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: isUrgent ? NeoBrutalTheme.bispiraBlue : NeoBrutalTheme.neoGreen,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: (isUrgent ? NeoBrutalTheme.bispiraBlue : NeoBrutalTheme.neoGreen).withValues(alpha: 0.4), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
            Text(subtitle, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: textSecondary)),
          ]),
        ]),
        NeoBrutalBadge(text: isUrgent ? 'Proses' : 'Normal', bgColor: isUrgent ? NeoBrutalTheme.bispiraBlue : NeoBrutalTheme.neoGreen),
      ],
    );
  }
}
