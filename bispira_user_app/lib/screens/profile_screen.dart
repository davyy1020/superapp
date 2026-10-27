import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Editable State
  String _name = 'Davy Wahyu Saputra';
  String _username = '@davywahyu';
  String _email = 'davy.wahyu@bispira.id';
  String _phone = '+62 812-3456-7890';
  String _memberId = 'BSP-2026-9042';
  String _accountType = 'Pusat User 👑';
  bool _isBiometricEnabled = true;

  void _showEditProfileModal() {
    final nameCtrl = TextEditingController(text: _name);
    final usernameCtrl = TextEditingController(text: _username);
    final emailCtrl = TextEditingController(text: _email);
    final phoneCtrl = TextEditingController(text: _phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Profil BISPIRA ✏️',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: NeoColors.black),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: NeoColors.brandSoft, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 18, color: NeoColors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Fields
                _buildInputField('Nama Lengkap', nameCtrl, Icons.badge_rounded),
                const SizedBox(height: 12),
                _buildInputField('Username', usernameCtrl, Icons.alternate_email_rounded),
                const SizedBox(height: 12),
                _buildInputField('Email', emailCtrl, Icons.email_rounded),
                const SizedBox(height: 12),
                _buildInputField('Nomor Telepon', phoneCtrl, Icons.phone_android_rounded),
                const SizedBox(height: 20),

                // Save Button
                GestureDetector(
                  onTap: () {
                    if (nameCtrl.text.trim().isNotEmpty && usernameCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        _name = nameCtrl.text.trim();
                        _username = usernameCtrl.text.trim();
                        _email = emailCtrl.text.trim();
                        _phone = phoneCtrl.text.trim();
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil BISPIRA Anda Berhasil Diperbarui! ✨'),
                          backgroundColor: NeoColors.brand,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Simpan Perubahan 💾',
                        style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: NeoColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: NeoColors.black, width: 1.5),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NeoColors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(icon, size: 18, color: NeoColors.brand),
            ),
          ),
        ),
      ],
    );
  }

  void _showQRCodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: NeoColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: NeoColors.black, width: 2.5),
            boxShadow: const [
              BoxShadow(color: NeoColors.black, offset: Offset(4, 4), blurRadius: 0),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'BISPIRA VIP Pass QR 👑',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
              ),
              const SizedBox(height: 6),
              Text(
                _memberId,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.brand),
              ),
              const SizedBox(height: 16),

              // Mock QR Code Box
              Container(
                width: 180,
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code_2_rounded, size: 130, color: NeoColors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tunjukkan QR ini kepada Merchant atau Concierge BISPIRA.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: NeoColors.brandSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: NeoColors.black, width: 1.5),
                  ),
                  child: const Text(
                    'Tutup Pass',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ============================================================
              // 1. HERO USER PROFILE CARD
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF0040B8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: NeoColors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(4, 4), blurRadius: 0),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            shape: BoxShape.circle,
                            border: Border.all(color: NeoColors.black, width: 2.5),
                          ),
                          child: Center(
                            child: Text(
                              _name.isNotEmpty ? _name[0].toUpperCase() : 'B',
                              style: const TextStyle(color: NeoColors.black, fontSize: 38, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: NeoColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: const Text('👑', style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      _name,
                      style: const TextStyle(color: NeoColors.white, fontSize: 21, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),

                    Text(
                      _username,
                      style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),

                    // Badges Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: Text(
                            'ID: $_memberId',
                            style: const TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: NeoColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: Text(
                            'AKUN: $_accountType',
                            style: const TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _showEditProfileModal,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: NeoColors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.edit_rounded, size: 14, color: NeoColors.black),
                                SizedBox(width: 6),
                                Text(
                                  'Edit Profil',
                                  style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _showQRCodeDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF08A),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.qr_code_rounded, size: 14, color: NeoColors.black),
                                SizedBox(width: 6),
                                Text(
                                  'VIP Pass QR',
                                  style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ============================================================
              // 2. USER DETAILS DATA LIST
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'DATA RESMI ANGGOTA BISPIRA',
                    style: TextStyle(color: NeoColors.black, fontSize: 12.5, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                  ),
                  Text(
                    'Tersinkron ⚡',
                    style: TextStyle(color: NeoColors.brand, fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _profileDetailTile(
                num: '1',
                title: 'NAMA LENGKAP',
                value: _name,
                icon: Icons.badge_rounded,
                badge: 'Verified KTP',
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '2',
                title: 'USER NAME',
                value: _username,
                icon: Icons.alternate_email_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '3',
                title: 'ALAMAT EMAIL',
                value: _email,
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '4',
                title: 'NOMOR TELEPON (WHATSAPP)',
                value: _phone,
                icon: Icons.phone_android_rounded,
                badge: 'Aktif',
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '5',
                title: 'TIPE AKUN & AKSES',
                value: 'Pusat User (VIP National)',
                icon: Icons.workspace_premium_rounded,
                badge: 'Pusat VIP',
              ),
              const SizedBox(height: 10),

              _profileDetailTile(
                num: '6',
                title: 'STATUS E-KTP & BIOMETRIK',
                value: '3171029482910002 • Terverifikasi',
                icon: Icons.verified_user_rounded,
                badge: 'Terverifikasi',
              ),
              const SizedBox(height: 22),

              // ============================================================
              // 3. SECURITY & PREFERENCES TOGGLE
              // ============================================================
              const Text(
                'KEAMANAN & PENGATURAN',
                style: TextStyle(color: NeoColors.black, fontSize: 12.5, fontWeight: FontWeight.w900, letterSpacing: 0.8),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.fingerprint_rounded, color: NeoColors.brand, size: 22),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Login Biometrik (Fingerprint/FaceID)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black)),
                            SizedBox(height: 2),
                            Text('Verifikasi ekstra sebelum transaksi', style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _isBiometricEnabled,
                      activeColor: NeoColors.brand,
                      onChanged: (val) {
                        setState(() => _isBiometricEnabled = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ============================================================
              // 4. LOGOUT BUTTON
              // ============================================================
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anda telah keluar dari sesi BISPIRA SuperApp.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent, width: 1.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Keluar Sesi Akun',
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileDetailTile({
    required String num,
    required String title,
    required String value,
    required IconData icon,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NeoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoColors.black, width: 1.8),
        boxShadow: const [
          BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: NeoColors.brandSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NeoColors.brand, width: 1.2),
            ),
            child: Center(
              child: Icon(icon, color: NeoColors.brand, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted, letterSpacing: 0.5),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: NeoColors.black),
                ),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NeoColors.brandSoft,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: NeoColors.brand, width: 1),
              ),
              child: Text(
                badge,
                style: const TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}
