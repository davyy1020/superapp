import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class EVotingScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const EVotingScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<EVotingScreen> createState() => _EVotingScreenState();
}

class _EVotingScreenState extends State<EVotingScreen> {
  int _userBalance = 250000;
  int? _votedCandidateId;
  int _totalVotes = 12482901;

  final List<Map<String, dynamic>> _candidates = [
    {
      'id': 1,
      'numberBadge': 'CANDIDATE #01',
      'name': 'Dr. Aris Sudarsono',
      'expertise': 'Digital Infrastructure',
      'quote': '"Building a unified digital backbone for national prosperity and technological sovereignty."',
      'votesPercentage': 42,
      'emoji': '👨‍💼',
      'bgGradient': [const Color(0xFF0F172A), const Color(0xFF0040B8)],
    },
    {
      'id': 2,
      'numberBadge': 'CANDIDATE #02',
      'name': 'Siti Maemunah, M.A.',
      'expertise': 'Social Inclusion',
      'quote': '"Leveraging technology to ensure every citizen has equal access to education and opportunity."',
      'votesPercentage': 38,
      'emoji': '👩‍💼',
      'bgGradient': [const Color(0xFF10B981), const Color(0xFF0F172A)],
    },
    {
      'id': 3,
      'numberBadge': 'CANDIDATE #03',
      'name': 'Budi Santoso, Eng.',
      'expertise': 'Sustainable Cities',
      'quote': '"Transforming our urban landscapes into smart, carbon-neutral hubs for the next generation."',
      'votesPercentage': 20,
      'emoji': '🧑‍💻',
      'bgGradient': [const Color(0xFF0284C7), const Color(0xFF0040B8)],
    },
  ];

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _showVotingModal(Map<String, dynamic> candidate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
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
                    'Konfirmasi Suara (E-Voting) 🗳️',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
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
              const SizedBox(height: 14),

              // Candidate Card Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: candidate['bgGradient'] as List<Color>,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: Center(
                        child: Text(candidate['emoji'] as String, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidate['numberBadge'] as String,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF00B4D8)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            candidate['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black),
                          ),
                          Text(
                            'Expertise: ${candidate['expertise']}',
                            style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Biometric & Blockchain Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.brandSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.brand, width: 1.2),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.fingerprint_rounded, size: 28, color: NeoColors.brand),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Suara Anda akan diverifikasi menggunakan Enkripsi Blockchain Cryptographic Proof BISPIRA.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: NeoColors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Vote Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _votedCandidateId = candidate['id'] as int;
                    _totalVotes += 1;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Suara Anda untuk ${candidate['name']} Berhasil Terverifikasi di Blockchain! 📜✨'),
                      backgroundColor: NeoColors.brand,
                    ),
                  );
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Cast Vote Securely 🗳️',
                        style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAuditLogSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
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
                    'Blockchain Audit Log 🛡️',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
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
              const SizedBox(height: 14),
              _auditItem('Hash #0x8f3a9c...', 'Verified Biometric Identity (KTP-el)', '0.002s ago'),
              _auditItem('Hash #0x7b12d4...', 'Zero-Knowledge Proof Signed', '0.015s ago'),
              _auditItem('Hash #0x4e98f1...', 'Consensus Block #1,490,233 Mined', '0.040s ago'),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: NeoColors.brandSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NeoColors.black, width: 1.2),
                ),
                child: const Center(
                  child: Text(
                    '✅ Status Node: 100% Fully Immutable & Decentralized',
                    style: TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _auditItem(String hash, String detail, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: NeoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: NeoColors.black, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hash, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black)),
                Text(detail, style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
              ],
            ),
            Text(time, style: const TextStyle(fontSize: 10, color: NeoColors.brand, fontWeight: FontWeight.w800)),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // 1. TOP HEADER BAR (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.onBackPressed != null) ...[
                        GestureDetector(
                          onTap: widget.onBackPressed,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: NeoColors.brandSoft,
                              shape: BoxShape.circle,
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, size: 16, color: NeoColors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'BISPIRA',
                        style: TextStyle(
                          color: NeoColors.brand,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),

                  // Balance Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: NeoColors.brandSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.brand, width: 1.5),
                    ),
                    child: Text(
                      '💳 Rp ${_formatNumber(_userBalance)}',
                      style: const TextStyle(
                        color: NeoColors.brand,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 2. HERO LIVE STATUS HEADER (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Row(
                children: const [
                  Text('🔴 ', style: TextStyle(fontSize: 12)),
                  Text(
                    'LIVE ELECTION STATUS',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              const Text(
                'National Digital\nLeadership 2026',
                style: TextStyle(
                  color: NeoColors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "Cast your vote securely using BISPIRA's blockchain-verified infrastructure. Your identity is anonymized while your voice is guaranteed to be heard.",
                style: TextStyle(
                  color: NeoColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // ============================================================
              // 3. LIVE ANALYTICS & SECURITY CARD (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Anti-Manipulation',
                              style: TextStyle(
                                color: NeoColors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Secured by Cryptographic Proof',
                              style: TextStyle(
                                color: NeoColors.brand,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.shield_outlined, color: NeoColors.brand, size: 26),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Candidate A stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Candidate A', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                        Text('42%', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.42,
                        backgroundColor: NeoColors.bg,
                        color: Color(0xFF00B4D8),
                        minHeight: 7,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Candidate B stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Candidate B', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                        Text('38%', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.38,
                        backgroundColor: NeoColors.bg,
                        color: Color(0xFF00B4D8),
                        minHeight: 7,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Divider(color: NeoColors.black, thickness: 1.2),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Verified Votes',
                          style: TextStyle(
                            color: NeoColors.textMuted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _formatNumber(_totalVotes),
                          style: const TextStyle(
                            color: NeoColors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ============================================================
              // 4. OFFICIAL CANDIDATES SECTION (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    color: NeoColors.brand,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Official Candidates',
                    style: TextStyle(
                      color: NeoColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Candidates List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  final candidate = _candidates[index];
                  final bool isVotedThis = _votedCandidateId == candidate['id'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: NeoColors.black, width: 2.2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Candidate Banner Image / Emoji Gradient
                        Stack(
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: candidate['bgGradient'] as List<Color>,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                              ),
                              child: Center(
                                child: Text(
                                  candidate['emoji'] as String,
                                  style: const TextStyle(fontSize: 80),
                                ),
                              ),
                            ),

                            // Candidate Number Badge
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00B4D8),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                ),
                                child: Text(
                                  candidate['numberBadge'] as String,
                                  style: const TextStyle(
                                    color: NeoColors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10.5,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Candidate Details Body
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                candidate['name'] as String,
                                style: const TextStyle(
                                  color: NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 2),

                              Text(
                                'Expertise: ${candidate['expertise']}',
                                style: const TextStyle(
                                  color: NeoColors.brand,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Quote Box
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: NeoColors.black, width: 1.2),
                                ),
                                child: Text(
                                  candidate['quote'] as String,
                                  style: const TextStyle(
                                    color: NeoColors.black,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Action Button
                              GestureDetector(
                                onTap: () => _showVotingModal(candidate),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isVotedThis ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: NeoColors.black, width: 1.8),
                                    boxShadow: const [
                                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isVotedThis ? 'Voted ✅' : 'Cast Vote',
                                        style: const TextStyle(
                                          color: NeoColors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13.5,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        isVotedThis ? Icons.check_circle_rounded : Icons.how_to_vote_rounded,
                                        color: NeoColors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              // ============================================================
              // 5. IDENTITY VERIFICATION CARD (EXACT MATCH REFERENCE DESIGN)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B4D8).withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF00B4D8), width: 1.5),
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: Color(0xFF00B4D8), size: 28),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Identity Verification Successful',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: NeoColors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Your biometric and national ID data has been verified. You are authorized to cast one (1) vote for the National Digital Leadership 2026 election. Any attempt at duplicate voting is automatically flagged by our blockchain auditors.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: NeoColors.textMuted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: _showAuditLogSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: NeoColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: NeoColors.black, width: 1.8),
                        ),
                        child: const Text(
                          'View Audit Log',
                          style: TextStyle(
                            color: NeoColors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
