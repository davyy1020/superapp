import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import 'desktop_admin_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(text: 'admin@bispira.id');
  final _passwordController = TextEditingController(text: 'admin123');
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;
  bool _isHoveringLogin = false;
  int _selectedRoleIndex = 0; // 0: Pusat HQ, 1: Cabang Wilayah

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<Offset> _leftSlideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _leftSlideAnim = Tween<Offset>(
      begin: const Offset(-0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Silakan masukkan email dan kata sandi administrator!'),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final isBranch = _emailController.text.toLowerCase().contains('cabang') || _selectedRoleIndex == 1;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => DesktopAdminMainScreen(
            userRole: isBranch ? 'Admin Cabang Wilayah' : 'Super Admin Pusat',
            userEmail: _emailController.text.trim(),
            branchName: isBranch ? 'Cabang Jakarta Selatan' : 'Pusat (HQ)',
          ),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 200),
        ),
      );
    });
  }

  void _selectRole(int roleIndex) {
    setState(() {
      _selectedRoleIndex = roleIndex;
      if (roleIndex == 0) {
        _emailController.text = 'admin@bispira.id';
      } else {
        _emailController.text = 'cabang@bispira.id';
      }
      _passwordController.text = 'admin123';
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    // Executive Midnight Theme Palette
    final screenBg = isDark ? const Color(0xFF050814) : const Color(0xFFE9F0FA);
    final panelBgLeft = isDark ? const Color(0xFF080E20) : const Color(0xFF0B142B);
    final cardBg = isDark ? const Color(0xFF0D1527) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF141F36) : const Color(0xFFF3F7FC);
    final borderColor = isDark ? const Color(0xFF1E2D4A) : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: screenBg,
      body: Stack(
        children: [
          // Ambient Radial Light Glows
          Positioned(
            top: -150,
            left: -120,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0066FF).withValues(alpha: isDark ? 0.22 : 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            right: -120,
            child: Container(
              width: 650,
              height: 650,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00E5FF).withValues(alpha: isDark ? 0.18 : 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main View Layout
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 980;

                if (isCompact) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCompactHero(),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: SlideTransition(
                            position: _slideAnim,
                            child: FadeTransition(
                              opacity: _fadeAnim,
                              child: _buildFormCard(
                                provider: provider,
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                inputBg: inputBg,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Row(
                  children: [
                    // LEFT SIDE: LUXURY HIGH-TECH HERO SHOWCASE
                    Expanded(
                      flex: 5,
                      child: SlideTransition(
                        position: _leftSlideAnim,
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: panelBgLeft,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: _buildLeftHeroPanel(),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // RIGHT SIDE: MODERN LOGIN FORM
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          // Top Bar with Theme Toggle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildThemeToggle(provider, isDark, cardBg, borderColor, textPrimary),
                              ],
                            ),
                          ),

                          // Centered Login Card
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
                                child: SlideTransition(
                                  position: _slideAnim,
                                  child: FadeTransition(
                                    opacity: _fadeAnim,
                                    child: _buildFormCard(
                                      provider: provider,
                                      isDark: isDark,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textPrimary: textPrimary,
                                      textSecondary: textSecondary,
                                      inputBg: inputBg,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Footer Security Note
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF0066FF)),
                                const SizedBox(width: 6),
                                Text(
                                  '© 2026 PT BISPIRA Digital Indonesia  •  Sistem Terproteksi Enkripsi TLS 1.3',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Compact Header for smaller screens
  Widget _buildCompactHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF040816), Color(0xFF0C1D42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0066FF).withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(height: 14),
          const Text(
            'BISPIRA SUPERAPP',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2.0),
          ),
          const SizedBox(height: 4),
          Text(
            'DESKTOP ADMIN SUITE — EXECUTIVE EDITION',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// High-Tech Enterprise Showcase Left Panel
  Widget _buildLeftHeroPanel() {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _GridPatternPainter()),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Brand
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0066FF).withValues(alpha: 0.45),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BISPIRA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0066FF).withValues(alpha: 0.3),
                              const Color(0xFF00E5FF).withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF0066FF).withValues(alpha: 0.4)),
                        ),
                        child: const Text(
                          'DESKTOP ADMIN SUITE v2.4',
                          style: TextStyle(
                            color: Color(0xFF7DD3FC),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Hero Headline
              const Text(
                'Sistem Operasional &\nOtomasi Finansial\nTerpadu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Konsol komprehensif untuk tata kelola lisensi cabang nasional, rekonsiliasi perbankan multi-channel otomatis, telemetri GIS, dan penyelesaian dana penjual.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 13.5,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 28),

              // Interactive Hoverable Feature Highlights
              _InteractiveHeroCard(
                icon: Icons.sync_rounded,
                title: 'Otomasi Rekonsiliasi Bank 99.9%',
                subtitle: 'Matching kode unik otomatis dengan mutasi BNI, BCA, Mandiri, dan BRI.',
                tag: '● REALTIME',
                tagColor: const Color(0xFF10B981),
                accentGradient: const [Color(0xFF10B981), Color(0xFF059669)],
              ),
              const SizedBox(height: 12),
              _InteractiveHeroCard(
                icon: Icons.send_and_archive_rounded,
                title: 'Pencairan Massal Mitra 17:00 WIB',
                subtitle: 'Akumulasi penjualan 2 hari dipotong biaya otomatis per toko atau serentak.',
                tag: '⚡ BATCH CRON',
                tagColor: const Color(0xFF00AAFF),
                accentGradient: const [Color(0xFF0066FF), Color(0xFF00E5FF)],
              ),
              const SizedBox(height: 12),
              _InteractiveHeroCard(
                icon: Icons.navigation_rounded,
                title: 'GIS Routing OSRM & Anti-Fraud',
                subtitle: 'Telemetri armada aktif, estimasi rute presisi, dan deteksi Fake GPS terproteksi.',
                tag: '🛡️ FRAUD GUARD',
                tagColor: const Color(0xFFF59E0B),
                accentGradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),

              const SizedBox(height: 32),

              // Live Status Telemetry Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0xFF10B981), blurRadius: 6, spreadRadius: 1),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Core Engine: Operational (99.9%)  •  Latency: 4ms',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Modern Executive Login Form Card
  Widget _buildFormCard({
    required AdminProvider provider,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color inputBg,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 460),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2D4A) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.6) : const Color(0xFF0066FF).withValues(alpha: 0.10),
            blurRadius: 40,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emblem & Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0052CC), Color(0xFF0077FF), Color(0xFF00AAFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0066FF).withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Masuk ke Konsol Suite',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Masukkan kredensial administrator untuk akses sistem.',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Role Switcher Tabs (Pusat vs Cabang)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectRole(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _selectedRoleIndex == 0 ? const Color(0xFF0066FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: _selectedRoleIndex == 0
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF0066FF).withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.apartment_rounded,
                            size: 15,
                            color: _selectedRoleIndex == 0 ? Colors.white : textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Super Admin Pusat',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _selectedRoleIndex == 0 ? Colors.white : textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectRole(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _selectedRoleIndex == 1 ? const Color(0xFF06B6D4) : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: _selectedRoleIndex == 1
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF06B6D4).withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storefront_rounded,
                            size: 15,
                            color: _selectedRoleIndex == 1 ? Colors.white : textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Admin Cabang',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _selectedRoleIndex == 1 ? Colors.white : textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Email Input Field
          Text(
            'EMAIL / USERNAME ADMIN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          _buildInteractiveInputField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            icon: Icons.alternate_email_rounded,
            hint: 'admin@bispira.id',
            inputBg: inputBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onSubmitted: (_) => _handleLogin(),
          ),

          const SizedBox(height: 18),

          // Password Input Field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KATA SANDI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Hubungi IT Support BISPIRA Pusat untuk reset kredensial akun.'),
                      backgroundColor: const Color(0xFF0066FF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: const Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0066FF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInteractiveInputField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            icon: Icons.lock_outline_rounded,
            hint: '••••••••',
            obscureText: _obscurePassword,
            inputBg: inputBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onSubmitted: (_) => _handleLogin(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: textSecondary,
                size: 18,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),

          const SizedBox(height: 18),

          // Remember Me Checkbox
          Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: const Color(0xFF0066FF),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  side: BorderSide(color: borderColor, width: 1.5),
                  onChanged: (val) => setState(() => _rememberMe = val!),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Ingat sesi saya di komputer ini',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // Primary Action Login Button with Smooth Hover Micro-Animation
          MouseRegion(
            onEnter: (_) => setState(() => _isHoveringLogin = true),
            onExit: (_) => setState(() => _isHoveringLogin = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              transform: _isHoveringLogin ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isHoveringLogin
                            ? [const Color(0xFF0044BB), const Color(0xFF0066FF), const Color(0xFF0088FF)]
                            : [const Color(0xFF0052CC), const Color(0xFF0066FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0066FF).withValues(alpha: _isHoveringLogin ? 0.5 : 0.3),
                          blurRadius: _isHoveringLogin ? 20 : 12,
                          offset: Offset(0, _isHoveringLogin ? 6 : 4),
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Mengautentikasi Sesi...',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'MASUK KE DESKTOP SUITE',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 19),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Interactive Input Field Component with Focus Glow
  Widget _buildInteractiveInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String hint,
    required Color inputBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    bool obscureText = false,
    Widget? suffixIcon,
    ValueChanged<String>? onSubmitted,
  }) {
    final isFocused = focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFocused ? const Color(0xFF0066FF) : borderColor,
          width: isFocused ? 1.8 : 1.2,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF0066FF).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        style: TextStyle(fontWeight: FontWeight.w600, color: textPrimary, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: isFocused ? const Color(0xFF0066FF) : textSecondary,
            size: 19,
          ),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// Theme Switcher Pill Widget
  Widget _buildThemeToggle(AdminProvider provider, bool isDark, Color cardBg, Color borderColor, Color textPrimary) {
    return InkWell(
      onTap: () => provider.toggleTheme(),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 16,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF0066FF),
            ),
            const SizedBox(width: 8),
            Text(
              isDark ? 'Mode Terang' : 'Mode Gelap',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Interactive Micro-Hover Hero Feature Card Component
class _InteractiveHeroCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final List<Color> accentGradient;

  const _InteractiveHeroCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.accentGradient,
  }) : super(key: key);

  @override
  State<_InteractiveHeroCard> createState() => _InteractiveHeroCardState();
}

class _InteractiveHeroCardState extends State<_InteractiveHeroCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isHovered ? Matrix4.translationValues(0, -3, 0) : Matrix4.identity(),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? widget.tagColor.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.tagColor.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isHovered ? widget.accentGradient : [Colors.white.withValues(alpha: 0.14), Colors.white.withValues(alpha: 0.08)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: widget.tagColor.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Icon(widget.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.tagColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: widget.tagColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          widget.tag,
                          style: TextStyle(
                            color: widget.tagColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 11.5,
                      height: 1.35,
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
}

/// Grid pattern painter for cyber hero panel
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 0.5;

    const spacing = 36.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
