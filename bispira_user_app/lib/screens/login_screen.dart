import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  late AnimationController _flipController;

  bool _isLoginView = true;

  // Login Controllers
  final TextEditingController _loginPhoneController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  bool _isPhoneMode = true;
  bool _obscureLoginPass = true;

  // ULTRA-SIMPLE Customer Registration Controllers (Only 3 inputs!)
  final TextEditingController _regNamaLengkapController = TextEditingController();
  final TextEditingController _regPhoneOrEmailController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();
  bool _agreeTerms = true;
  bool _obscureRegPass = true;

  @override
  void initState() {
    super.initState();

    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _toggleAuthMode() {
    if (_isLoginView) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isLoginView = !_isLoginView;
    });
  }

  void _handleSuccessAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _flipController.dispose();
    _loginPhoneController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();

    _regNamaLengkapController.dispose();
    _regPhoneOrEmailController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.brand,
      body: AnimatedBuilder(
        animation: _bgAnimationController,
        builder: (context, child) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                // 1. HEADER WITH FLOATING BADGE
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // BISPIRA Logo
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.rotate(
                                angle: _bgAnimationController.value * 2 * math.pi,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        NeoColors.gold,
                                        NeoColors.brandSoft,
                                        NeoColors.gold.withOpacity(0.2),
                                        NeoColors.gold,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: NeoColors.white,
                                  border: Border.all(color: NeoColors.black, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(21),
                                  child: Image.asset(
                                    'assets/logo.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Text('B', style: TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 20)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Live Member Uptime Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: NeoColors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white30, width: 1),
                            ),
                            child: const Row(
                              children: [
                                Text('⚡', style: TextStyle(fontSize: 12)),
                                SizedBox(width: 6),
                                Text(
                                  'Pendaftaran Instan BISPIRA',
                                  style: TextStyle(color: NeoColors.white, fontSize: 11, fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Text(
                        _isLoginView ? 'Selamat Datang Kembali! 👋' : 'Daftar Akun Instan 🚀',
                        style: const TextStyle(
                          color: NeoColors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLoginView
                            ? 'Nikmati kemudahan 12+ layanan digital dalam satu genggaman.'
                            : 'Cukup isi 3 langkah praktis di bawah ini.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. ELEVATED CARD WITH TOGGLE SWITCH
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: NeoColors.bg,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      border: Border.all(color: NeoColors.black, width: 2.5),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(0, -4), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // TOGGLE SWITCH
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: NeoColors.brandSoft,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: NeoColors.black, width: 2),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!_isLoginView) _toggleAuthMode();
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: _isLoginView ? NeoColors.brand : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: _isLoginView ? Border.all(color: NeoColors.black, width: 1.8) : null,
                                        boxShadow: _isLoginView
                                            ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '🔑 MASUK',
                                          style: TextStyle(
                                            color: _isLoginView ? NeoColors.white : NeoColors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_isLoginView) _toggleAuthMode();
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: !_isLoginView ? NeoColors.gold : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: !_isLoginView ? Border.all(color: NeoColors.black, width: 1.8) : null,
                                        boxShadow: !_isLoginView
                                            ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '📝 DAFTAR INSTAN',
                                          style: TextStyle(
                                            color: !_isLoginView ? NeoColors.black : NeoColors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // FORM CONTENT
                        Expanded(
                          child: AnimatedCrossFade(
                            firstChild: _buildLoginForm(),
                            secondChild: _buildUltraSimpleRegisterForm(),
                            crossFadeState: _isLoginView ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // BUILD LOGIN FORM
  Widget _buildLoginForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildPhoneEmailSubTab('📱 Nomor WA', true),
              const SizedBox(width: 10),
              _buildPhoneEmailSubTab('✉️ Email / Username', false),
            ],
          ),
          const SizedBox(height: 18),

          if (_isPhoneMode) ...[
            const Text(
              'NOMOR WHATSAPP',
              style: TextStyle(color: NeoColors.black, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: NeoColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NeoColors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: NeoColors.brandSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NeoColors.black, width: 1.5),
                    ),
                    child: const Row(
                      children: [
                        Text('🇮🇩', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 6),
                        Text('+62', style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _loginPhoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: '812-3456-7890',
                        hintStyle: TextStyle(color: NeoColors.textMuted, fontWeight: FontWeight.w500, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Text(
              'EMAIL / USERNAME',
              style: TextStyle(color: NeoColors.black, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: NeoColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NeoColors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: TextField(
                controller: _loginEmailController,
                decoration: const InputDecoration(
                  hintText: 'Username atau davy@bispira.id',
                  hintStyle: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                  prefixIcon: Icon(Icons.person_outline_rounded, color: NeoColors.brand),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'PASSWORD',
              style: TextStyle(color: NeoColors.black, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: NeoColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NeoColors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: TextField(
                controller: _loginPasswordController,
                obscureText: _obscureLoginPass,
                decoration: InputDecoration(
                  hintText: '••••••••••••',
                  hintStyle: const TextStyle(color: NeoColors.textMuted, fontSize: 14),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: NeoColors.brand),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureLoginPass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: NeoColors.black),
                    onPressed: () => setState(() => _obscureLoginPass = !_obscureLoginPass),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: SoftNeoButton(
                  text: _isPhoneMode ? 'Lanjutkan SMS / WA →' : 'Masuk ke BISPIRA 🚀',
                  backgroundColor: NeoColors.brand,
                  textColor: NeoColors.white,
                  onPressed: _handleSuccessAuth,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _handleSuccessAuth,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NeoColors.gold,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                    ],
                  ),
                  child: const Icon(Icons.fingerprint_rounded, size: 22, color: NeoColors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1-TAP GOOGLE SIGN IN
          GestureDetector(
            onTap: _handleSuccessAuth,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: NeoColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NeoColors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌐', style: TextStyle(fontSize: 19)),
                  SizedBox(width: 10),
                  Text(
                    'Masuk Cepat dengan Google',
                    style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ULTRA-SIMPLE CUSTOMER REGISTRATION FORM (ONLY 3 STEPS FOR CUSTOMER, SYSTEM AUTO-HANDLES REST!)
  Widget _buildUltraSimpleRegisterForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // QUICK GOOGLE 1-CLICK REGISTER
          GestureDetector(
            onTap: _handleSuccessAuth,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: NeoColors.gold,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NeoColors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌐', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Text(
                    'Daftar 1-Klik dengan Google',
                    style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: Container(height: 1.5, color: NeoColors.black.withOpacity(0.12))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Atau isi 3 langkah simpel',
                  style: TextStyle(color: NeoColors.textMuted, fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(child: Container(height: 1.5, color: NeoColors.black.withOpacity(0.12))),
            ],
          ),
          const SizedBox(height: 16),

          // 1. NAMA LENGKAP
          const Text('1. NAMA LENGKAP', style: TextStyle(color: NeoColors.black, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
          const SizedBox(height: 6),
          _inputBox(_regNamaLengkapController, 'Davy Wahyu Saputra', Icons.person_outline_rounded),
          const SizedBox(height: 14),

          // 2. NOMOR WHATSAPP ATAU EMAIL
          const Text('2. NOMOR WHATSAPP / EMAIL', style: TextStyle(color: NeoColors.black, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
          const SizedBox(height: 6),
          _inputBox(_regPhoneOrEmailController, '0812-3456-7890 atau davy@bispira.id', Icons.phone_iphone_rounded, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),

          // 3. PASSWORD
          const Text('3. BUAT PASSWORD', style: TextStyle(color: NeoColors.black, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: NeoColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: NeoColors.black, width: 2.2),
              boxShadow: const [
                BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
              ],
            ),
            child: TextField(
              controller: _regPasswordController,
              obscureText: _obscureRegPass,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                hintText: '••••••••••••',
                hintStyle: const TextStyle(color: NeoColors.textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: NeoColors.brand),
                suffixIcon: IconButton(
                  icon: Icon(_obscureRegPass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: NeoColors.black),
                  onPressed: () => setState(() => _obscureRegPass = !_obscureRegPass),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),



          Row(
            children: [
              Checkbox(
                value: _agreeTerms,
                activeColor: NeoColors.brand,
                checkColor: NeoColors.white,
                onChanged: (val) => setState(() => _agreeTerms = val!),
              ),
              const Expanded(
                child: Text(
                  'Saya setuju mendaftar BISPIRA SuperApp.',
                  style: TextStyle(color: NeoColors.black, fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SoftNeoButton(
            text: 'Daftar Akun Sekarang 🚀',
            backgroundColor: NeoColors.brand,
            textColor: NeoColors.white,
            onPressed: () {
              if (!_agreeTerms) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Harap setujui pendaftaran terlebih dahulu.'),
                    backgroundColor: NeoColors.black,
                  ),
                );
                return;
              }
              _handleSuccessAuth();
            },
          ),
        ],
      ),
    );
  }

  Widget _inputBox(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: NeoColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoColors.black, width: 2.2),
        boxShadow: const [
          BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: NeoColors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: NeoColors.textMuted, fontSize: 13.5),
          prefixIcon: Icon(icon, color: NeoColors.brand),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildPhoneEmailSubTab(String label, bool isPhone) {
    final bool isSelected = _isPhoneMode == isPhone;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isPhoneMode = isPhone),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? NeoColors.brand : NeoColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: NeoColors.black, width: 1.8),
            boxShadow: [
              if (isSelected)
                const BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
            ],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? NeoColors.white : NeoColors.black,
              fontWeight: FontWeight.w900,
              fontSize: 11.5,
            ),
          ),
        ),
      ),
    );
  }
}
