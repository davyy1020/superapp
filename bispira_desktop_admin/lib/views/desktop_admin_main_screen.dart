import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../theme/neo_brutal_theme.dart';
import 'login_screen.dart';
import 'tabs/dashboard_overview_tab.dart';
import 'tabs/manual_reconciliation_tab.dart';
import 'tabs/batch_settlement_tab.dart';
import 'tabs/branch_licenses_tab.dart';
import 'tabs/driver_master_tab.dart';
import 'tabs/merchant_master_tab.dart';
import 'tabs/user_master_tab.dart';
import 'tabs/fee_customization_tab.dart';
import 'tabs/gis_tracking_tab.dart';

class DesktopAdminMainScreen extends StatefulWidget {
  final String userRole;
  final String userEmail;
  final String branchName;

  const DesktopAdminMainScreen({
    Key? key,
    this.userRole = 'Super Admin Pusat',
    this.userEmail = 'admin@bispira.id',
    this.branchName = 'Pusat (HQ)',
  }) : super(key: key);

  @override
  State<DesktopAdminMainScreen> createState() => _DesktopAdminMainScreenState();
}

class _DesktopAdminMainScreenState extends State<DesktopAdminMainScreen> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final List<Widget> _tabs = const [
    DashboardOverviewTab(),
    ManualReconciliationTab(),
    BatchSettlementTab(),
    BranchLicensesTab(),
    DriverMasterTab(),
    MerchantMasterTab(),
    UserMasterTab(),
    FeeCustomizationTab(),
    GisTrackingTab(),
  ];

  final List<_NavItemData> _navItems = const [
    _NavItemData(Icons.dashboard_rounded, 'Dashboard & Finansial', 'Dashboard'),
    _NavItemData(Icons.fact_check_rounded, 'Verifikasi Mutasi Bank', 'Mutasi'),
    _NavItemData(Icons.account_balance_wallet_rounded, 'Batch Payout 17:00 WIB', 'Payout'),
    _NavItemData(Icons.apartment_rounded, 'Pusat Cabang & Lisensi', 'Cabang'),
    _NavItemData(Icons.two_wheeler_rounded, 'Pusat Driver & Atribut', 'Driver'),
    _NavItemData(Icons.storefront_rounded, 'Pusat Merchant & Katalog', 'Merchant'),
    _NavItemData(Icons.people_alt_rounded, 'Pusat User & Nasabah', 'User'),
    _NavItemData(Icons.tune_rounded, 'Pengaturan Tarif & Fees', 'Tarif'),
    _NavItemData(Icons.map_rounded, 'Peta GIS Live Tracking', 'GIS'),
  ];

  void _handleLogout() {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    final isDark = provider.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1.0),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeoBrutalTheme.neoRed.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: NeoBrutalTheme.neoRed, size: 22),
            ),
            const SizedBox(width: 12),
            Text('Konfirmasi Logout',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF0F172A))),
          ],
        ),
        content: Text('Apakah Anda yakin ingin keluar dari BISPIRA Desktop Admin Suite?',
          style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          NeoBrutalButton(
            label: 'Ya, Keluar',
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            bgColor: NeoBrutalTheme.neoRed, fontSize: 14,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<Map<String, dynamic>> _buildThemeMenuItem(String name, Color color, bool isDark) {
    return PopupMenuItem<Map<String, dynamic>>(
      value: {'name': name, 'color': color},
      child: Row(
        children: [
          Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)])),
          const SizedBox(width: 10),
          Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF0F172A))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final bgDark = NeoBrutalTheme.getBgDark(isDark);
    final bgSurface = NeoBrutalTheme.getBgSurface(isDark);
    final textPrimary = NeoBrutalTheme.getTextPrimary(isDark);
    final textSecondary = NeoBrutalTheme.getTextSecondary(isDark);
    final textMuted = NeoBrutalTheme.getTextMuted(isDark);
    final borderSubtle = NeoBrutalTheme.getBorderSubtle(isDark);

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: bgSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.06) : borderSubtle, width: 1.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.08), offset: const Offset(0, 10), blurRadius: 30),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Column(
                children: [
                  // ═══════════ PREMIUM HEADER BAR ═══════════
                  _buildHeaderBar(provider, isDark, bgSurface, textPrimary, textSecondary, textMuted, borderSubtle),

                  // ═══════════ MAIN CONTENT ═══════════
                  Expanded(
                    child: Row(
                      children: [
                        // Premium Sidebar
                        _buildSidebar(isDark, bgSurface, textPrimary, textSecondary, textMuted, borderSubtle),

                        // Tab Content with smooth 60fps entrance transition
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.01, 0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              key: ValueKey(_selectedTabIndex),
                              color: isDark ? const Color(0xFF070B14) : const Color(0xFFF6F8FC),
                              child: _tabs[_selectedTabIndex],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBar(AdminProvider provider, bool isDark, Color bgSurface, Color textPrimary, Color textSecondary, Color textMuted, Color borderSubtle) {
    final accent = provider.accentColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1321) : bgSurface,
        border: Border(bottom: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.06) : borderSubtle, width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Logo + Brand
          Row(
            children: [
              Container(
                width: 36, height: 36, padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [accent, accent.withValues(alpha: 0.75)]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Image.asset('assets/logo.png', fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BISPIRA Desktop Admin Suite v2.4',
                    style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary, fontSize: 14.5)),
                  Text('Wilayah: ${widget.branchName} • Hak Akses: ${widget.userRole}',
                    style: TextStyle(fontWeight: FontWeight.w600, color: textSecondary, fontSize: 11.5)),
                ],
              ),
            ],
          ),

          // Right: Search, Theme, Mode, Logout
          Row(
            children: [
              // Search bar
              Container(
                width: 220, height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.06) : borderSubtle),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: textMuted, size: 18),
                    const SizedBox(width: 8),
                    Text('Cari master data...', style: TextStyle(color: textMuted, fontSize: 12.5)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('⌘K', style: TextStyle(color: textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Theme picker
              PopupMenuButton<Map<String, dynamic>>(
                tooltip: 'Pilih Tema Aksen Warna',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: borderSubtle)),
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                onSelected: (preset) => provider.setAccentTheme(preset['name'] as String, preset['color'] as Color),
                itemBuilder: (ctx) => [
                  _buildThemeMenuItem('Royal Blue (Standard)', const Color(0xFF0066FF), isDark),
                  _buildThemeMenuItem('Emerald Fintech', const Color(0xFF10B981), isDark),
                  _buildThemeMenuItem('Indigo SaaS Pro', const Color(0xFF6366F1), isDark),
                  _buildThemeMenuItem('Sunset Coral', const Color(0xFFF43F5E), isDark),
                ],
                child: _buildHeaderPill(
                  isDark: isDark, borderSubtle: borderSubtle,
                  child: Row(children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(
                      color: provider.accentColor, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: provider.accentColor.withValues(alpha: 0.4), blurRadius: 6)],
                    )),
                    const SizedBox(width: 8),
                    Text(provider.themePresetName, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textPrimary)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down_rounded, size: 16, color: textMuted),
                  ]),
                ),
              ),
              const SizedBox(width: 8),

              // Dark/light toggle
              InkWell(
                onTap: () => provider.toggleTheme(),
                borderRadius: BorderRadius.circular(10),
                child: _buildHeaderPill(
                  isDark: isDark, borderSubtle: borderSubtle,
                  child: Row(children: [
                    Icon(isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      color: isDark ? const Color(0xFFF59E0B) : const Color(0xFF6366F1), size: 15),
                    const SizedBox(width: 6),
                    Text(isDark ? 'Terang' : 'Gelap',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textPrimary)),
                  ]),
                ),
              ),
              const SizedBox(width: 8),

              // Logout
              InkWell(
                onTap: _handleLogout,
                borderRadius: BorderRadius.circular(10),
                child: _buildHeaderPill(
                  isDark: isDark, borderSubtle: borderSubtle,
                  child: Row(children: [
                    Icon(Icons.logout_rounded, color: NeoBrutalTheme.neoRed, size: 15),
                    const SizedBox(width: 6),
                    Text('Logout', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textPrimary)),
                  ]),
                ),
              ),
              const SizedBox(width: 14),

              // Window dots
              _buildWindowDot(const Color(0xFFEF4444)),
              const SizedBox(width: 6),
              _buildWindowDot(const Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              _buildWindowDot(const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderPill({required bool isDark, required Color borderSubtle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.06) : borderSubtle),
      ),
      child: child,
    );
  }

  Widget _buildSidebar(bool isDark, Color bgSurface, Color textPrimary, Color textSecondary, Color textMuted, Color borderSubtle) {
    final provider = Provider.of<AdminProvider>(context);
    final accent = provider.accentColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0F1C) : bgSurface,
        border: Border(right: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : borderSubtle, width: 1.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Card
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F172A), accent.withValues(alpha: 0.15)]
                    : [accent.withValues(alpha: 0.08), accent.withValues(alpha: 0.16)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: 0.3), width: 1.0),
            ),
            child: Row(
              children: [
                // Avatar with ring
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [accent, accent.withValues(alpha: 0.6)]),
                  ),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(Icons.person_rounded, color: accent, size: 18)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userEmail,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: textPrimary),
                        overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(widget.userRole,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: accent),
                              overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Section label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
            child: Text('MASTER SHEETS EXCEL',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textMuted, letterSpacing: 1.2)),
          ),

          // Nav items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _navItems.length,
              itemBuilder: (context, index) => _buildNavItem(index, isDark, textPrimary, textSecondary, textMuted),
            ),
          ),

          // Bottom branding
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : borderSubtle, width: 1.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24, height: 24, padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [accent, accent.withValues(alpha: 0.7)]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BISPIRA SUPERAPP', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: textPrimary)),
                        const SizedBox(height: 1),
                        Text('PT. SITEKUN ACADEMY', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 9.5, color: textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, bool isDark, Color textPrimary, Color textSecondary, Color textMuted) {
    final provider = Provider.of<AdminProvider>(context);
    final accent = provider.accentColor;
    final isSelected = _selectedTabIndex == index;
    final item = _navItems[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? accent.withValues(alpha: 0.18) : accent.withValues(alpha: 0.10))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: accent.withValues(alpha: isDark ? 0.4 : 0.3), width: 1.0)
                : null,
          ),
          child: Row(
            children: [
              // Active indicator bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 3, height: isSelected ? 20 : 0,
                decoration: BoxDecoration(
                  color: isSelected ? accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: isSelected ? 10 : 0),
              Icon(item.icon,
                color: isSelected ? accent : textMuted,
                size: 19),
              const SizedBox(width: 12),
              Expanded(
                child: Text(item.title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13,
                    color: isSelected
                        ? accent
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWindowDot(Color color) {
    return Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class _NavItemData {
  final IconData icon;
  final String title;
  final String shortTitle;
  const _NavItemData(this.icon, this.title, this.shortTitle);
}
