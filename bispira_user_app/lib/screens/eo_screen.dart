import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class EOScreen extends StatefulWidget {
  final VoidCallback onBackPressed;
  final bool initialIsPusat;

  const EOScreen({
    Key? key,
    required this.onBackPressed,
    this.initialIsPusat = false,
  }) : super(key: key);

  @override
  State<EOScreen> createState() => _EOScreenState();
}

class _EOScreenState extends State<EOScreen> {
  late bool _isPusat;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _isPusat = widget.initialIsPusat;
  }

  // DATA TURNAMEN CABANG (KABUPATEN / KOTA) - MENU 11
  final List<Map<String, dynamic>> _cabangEvents = [
    {
      'title': 'Turnamen Futsal Pelajar Kota Semarang 2026',
      'level': 'KABUPATEN / KOTA',
      'category': 'Olahraga',
      'date': '12 - 16 Nov 2026',
      'venue': 'GOR Jatidiri, Semarang',
      'organizer': 'Bispira EO Cabang Semarang',
      'fee': 'Rp 250.000 / Tim',
      'slots': '16 / 32 Tim Terdaftar',
      'bracket': [
        {'match': 'Q1', 'teamA': 'SMAN 1 SMG (3)', 'teamB': 'SMAN 3 SMG (1)'},
        {'match': 'Q2', 'teamA': 'SMKN 2 SMG (2)', 'teamB': 'SMA Sedes (0)'},
        {'match': 'Semi 1', 'teamA': 'SMAN 1 SMG', 'teamB': 'SMKN 2 SMG'},
        {'match': 'Final', 'teamA': 'TBD', 'teamB': 'TBD'},
      ],
      'emoji': '⚽',
    },
    {
      'title': 'Olimpiade Sains & Cerdas Cermat Tingkat SMP',
      'level': 'KABUPATEN / KOTA',
      'category': 'Pendidikan',
      'date': '28 Nov 2026',
      'venue': 'Auditorium Balaikota Semarang',
      'organizer': 'Bispira EO Cabang Semarang',
      'fee': 'Rp 75.000 / Peserta',
      'slots': '84 / 100 Kursi',
      'bracket': [
        {'match': 'Babak Penyisihan', 'teamA': '48 Sekolah', 'teamB': 'Tes CBT'},
        {'match': 'Semi Final', 'teamA': 'Top 10 Sekolah', 'teamB': 'Cepat Tepat'},
        {'match': 'Grand Final', 'teamA': '3 Finalis', 'teamB': 'Studi Kasus'},
      ],
      'emoji': '🧠',
    },
  ];

  // DATA TURNAMEN PUSAT (PROVINSI & NASIONAL) - MENU 12
  final List<Map<String, dynamic>> _pusatEvents = [
    {
      'title': 'Kejuaraan Nasional Pencak Silat Piala Presiden 2026',
      'level': 'TINGKAT NASIONAL',
      'category': 'Kejurnas',
      'date': '05 - 10 Des 2026',
      'venue': 'Istora Senayan, Jakarta',
      'organizer': 'Bispira EO Pusat (Nasional)',
      'fee': 'Rp 500.000 / Kontingen',
      'slots': '34 Provinsi Terverifikasi',
      'bracket': [
        {'match': 'Pool A', 'teamA': 'Jawa Tengah (Emas)', 'teamB': 'DKI Jakarta'},
        {'match': 'Pool B', 'teamA': 'Jawa Timur', 'teamB': 'Jawa Barat'},
        {'match': 'Final Kejurnas', 'teamA': 'Juara Pool A', 'teamB': 'Juara Pool B'},
      ],
      'emoji': '🥋',
    },
    {
      'title': 'BISPIRA National SuperApp Hackathon 2026',
      'level': 'TINGKAT PROVINSI & NASIONAL',
      'category': 'Teknologi & Inovasi',
      'date': '18 - 20 Des 2026',
      'venue': 'Online & Hybrid JCC Senayan',
      'organizer': 'Bispira EO Pusat (Nasional)',
      'fee': 'GRATIS (Sponsor Bispira)',
      'slots': '142 / 200 Tim Startup',
      'bracket': [
        {'match': 'Idea Screening', 'teamA': '500+ Proposal', 'teamB': 'Review Dewan Juri'},
        {'match': 'Demo Day 20 Besar', 'teamA': 'Pitching 10 Menit', 'teamB': 'Tanya Jawab Investor'},
        {'match': 'Winner Stage', 'teamA': 'Top 3 Nasional', 'teamB': 'Pendanaan Rp 500 Juta'},
      ],
      'emoji': '💻',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final events = _isPusat ? _pusatEvents : _cabangEvents;

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // TOP HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                border: const Border(bottom: BorderSide(color: NeoColors.black, width: 2.2)),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(0, 2), blurRadius: 0),
                ],
              ),
              child: Row(
                children: [
                  SoftNeoBackButton(onBackPressed: widget.onBackPressed),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _isPusat ? 'Bispira EO Pusat 🏆' : 'Bispira EO Cabang ⚡',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                          ),
                        ],
                      ),
                      Text(
                        _isPusat ? 'Menu 12: Turnamen Provinsi & Nasional' : 'Menu 11: Lomba & Bagan Kota/Kabupaten',
                        style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // SEGMENTED SWITCHER (CABANG VS PUSAT)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NeoColors.black, width: 2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPusat = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isPusat ? NeoColors.brand : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '📍 11. EO Cabang (Lokal)',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: !_isPusat ? NeoColors.white : NeoColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPusat = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isPusat ? NeoColors.gold : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '👑 12. EO Pusat (Nasional)',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: _isPusat ? NeoColors.black : NeoColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // EVENT LIST WITH BRACKET TREE
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final ev = events[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isPusat ? NeoColors.goldSoft : NeoColors.brandSoft,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                              ),
                              child: Center(
                                child: Text(ev['emoji'], style: const TextStyle(fontSize: 26)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _isPusat ? NeoColors.gold : NeoColors.brand,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      ev['level'],
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                        color: _isPusat ? NeoColors.black : NeoColors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ev['title'],
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: NeoColors.black),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '📍 ${ev['venue']} • 📅 ${ev['date']}',
                                    style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: NeoColors.black, height: 1, thickness: 1),
                        const SizedBox(height: 12),

                        // SKEMA BAGAN PERTANDINGAN (BRACKET MATCH TREE)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'SKEMA BAGAN & OPERASIONAL LOMBA 📊',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: NeoColors.black),
                            ),
                            Text('Live Update 🟢', style: TextStyle(fontSize: 10, color: Color(0xFF00C853), fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                          ),
                          child: Column(
                            children: (ev['bracket'] as List).map<Widget>((b) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: NeoColors.black,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        b['match'],
                                        style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 9.5),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${b['teamA']} vs ${b['teamB']}',
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: NeoColors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // FOOTER REGISTER BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Biaya Pendaftaran', style: TextStyle(fontSize: 10, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                                Text(
                                  ev['fee'],
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.brand),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Pendaftaran ${ev['title']} Berhasil Dibuka!'),
                                    backgroundColor: NeoColors.brand,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: NeoColors.brand,
                                foregroundColor: NeoColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: NeoColors.black, width: 1.8),
                                ),
                              ),
                              child: const Text('Daftar Turnamen 🚀', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
