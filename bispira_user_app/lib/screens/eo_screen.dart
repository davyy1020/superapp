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
  int _selectedPillarIndex = 0;

  final List<String> _pillarFilters = [
    'Semua Pilar',
    'Pendidikan',
    'Kesenian',
    'Kebudayaan',
    'Olahraga',
  ];

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
      'organizer': 'Bispira Event Daerah Cabang Semarang',
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
      'title': 'Olimpiade Sains & Cerdas Cermat Tingkat SMP / MTs',
      'level': 'KABUPATEN / KOTA',
      'category': 'Pendidikan',
      'date': '28 Nov 2026',
      'venue': 'Auditorium Balaikota Semarang',
      'organizer': 'Bispira Event Daerah Cabang Semarang',
      'fee': 'Rp 75.000 / Peserta',
      'slots': '84 / 100 Kursi',
      'bracket': [
        {'match': 'Babak Penyisihan', 'teamA': '48 Sekolah', 'teamB': 'Tes CBT'},
        {'match': 'Semi Final', 'teamA': 'Top 10 Sekolah', 'teamB': 'Cepat Tepat'},
        {'match': 'Grand Final', 'teamA': '3 Finalis', 'teamB': 'Studi Kasus'},
      ],
      'emoji': '🧠',
    },
    {
      'title': 'Festival Tari Kreasi & Band Akustik Pelajar Daerah',
      'level': 'KABUPATEN / KOTA',
      'category': 'Kesenian',
      'date': '02 Des 2026',
      'venue': 'Taman Budaya Raden Saleh, Semarang',
      'organizer': 'Bispira Event Daerah Cabang Semarang',
      'fee': 'Rp 100.000 / Tim',
      'slots': '24 / 30 Grup Terdaftar',
      'bracket': [
        {'match': 'Audisi 1', 'teamA': '15 Grup Tari', 'teamB': 'Penilaian Koreografi'},
        {'match': 'Audisi 2', 'teamA': '15 Band Akustik', 'teamB': 'Penilaian Musikalitas'},
        {'match': 'Malam Puncak', 'teamA': '6 Finalis Terbaik', 'teamB': 'Pentas Terbuka Juara'},
      ],
      'emoji': '🎭',
    },
    {
      'title': 'Pentas Busana Batik & Lomba Cipta Puisi Daerah',
      'level': 'KABUPATEN / KOTA',
      'category': 'Kebudayaan',
      'date': '08 Des 2026',
      'venue': 'Gedung Kesenian Daerah Semarang',
      'organizer': 'Bispira Event Daerah Cabang Semarang',
      'fee': 'Rp 50.000 / Peserta',
      'slots': '52 / 80 Peserta',
      'bracket': [
        {'match': 'Babak Seleksi', 'teamA': 'Kurasi Puisi', 'teamB': 'Catwalk Batik'},
        {'match': 'Grand Final', 'teamA': 'Top 10 Duta Budaya', 'teamB': 'Pemberian Mahkota'},
      ],
      'emoji': '🏛️',
    },
  ];

  // DATA TURNAMEN PUSAT (PROVINSI & NASIONAL) - MENU 12
  final List<Map<String, dynamic>> _pusatEvents = [
    {
      'title': 'Kejuaraan Nasional Pencak Silat Piala Presiden 2026',
      'level': 'TINGKAT NASIONAL',
      'category': 'Olahraga',
      'date': '05 - 10 Des 2026',
      'venue': 'Istora Senayan, Jakarta',
      'organizer': 'Bispira Event Pusat (Nasional)',
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
      'title': 'BISPIRA National SuperApp Hackathon & AI Innovation 2026',
      'level': 'TINGKAT NASIONAL',
      'category': 'Pendidikan',
      'date': '18 - 20 Des 2026',
      'venue': 'Online & Hybrid JCC Senayan',
      'organizer': 'Bispira Event Pusat (Nasional)',
      'fee': 'GRATIS (Sponsor Bispira)',
      'slots': '142 / 200 Tim Mahasiswa & Startup',
      'bracket': [
        {'match': 'Idea Screening', 'teamA': '500+ Proposal', 'teamB': 'Review Dewan Juri'},
        {'match': 'Demo Day 20 Besar', 'teamA': 'Pitching 10 Menit', 'teamB': 'Tanya Jawab Investor'},
        {'match': 'Winner Stage', 'teamA': 'Top 3 Nasional', 'teamB': 'Pendanaan Rp 500 Juta'},
      ],
      'emoji': '💻',
    },
    {
      'title': 'Festival Paduan Suara & Orkestra Nasional Piala Harmoni',
      'level': 'TINGKAT NASIONAL',
      'category': 'Kesenian',
      'date': '22 - 24 Des 2026',
      'venue': 'Teater Jakarta, TIM Cikini',
      'organizer': 'Bispira Event Pusat (Nasional)',
      'fee': 'Rp 750.000 / Kontingen',
      'slots': '28 Provinsi Terdaftar',
      'bracket': [
        {'match': 'Penyisihan Nasional', 'teamA': 'Lagu Wajib Nusantara', 'teamB': 'Komposisi Klasik'},
        {'match': 'Final Kejurnas', 'teamA': 'Top 5 Kontingen', 'teamB': 'Pentas Akbar Istana'},
      ],
      'emoji': '🎶',
    },
    {
      'title': 'Pekan Kebudayaan Nasional & Parade Busana Adat 38 Provinsi',
      'level': 'TINGKAT NASIONAL',
      'category': 'Kebudayaan',
      'date': '26 - 29 Des 2026',
      'venue': 'Monas & Gelora Bung Karno, Jakarta',
      'organizer': 'Bispira Event Pusat (Nasional)',
      'fee': 'GRATIS (Terbuka untuk Umum)',
      'slots': '38 Delegasi Provinsi Resmi',
      'bracket': [
        {'match': 'Karnaval Akbar', 'teamA': 'Parade 38 Provinsi', 'teamB': 'Pameran Warisan Budaya'},
        {'match': 'Malam Anugerah', 'teamA': 'Penetapan Duta Budaya', 'teamB': 'Piala Bergilir Presiden'},
      ],
      'emoji': '👑',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final rawEvents = _isPusat ? _pusatEvents : _cabangEvents;
    final events = _selectedPillarIndex == 0
        ? rawEvents
        : rawEvents.where((e) => e['category'] == _pillarFilters[_selectedPillarIndex]).toList();

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
                            _isPusat ? 'Bispira Event Pusat 🏆' : 'Bispira Event Daerah 📍',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                          ),
                        ],
                      ),
                      Text(
                        _isPusat ? 'Lomba Nasional: Pendidikan, Seni, Budaya & Olahraga' : 'Lomba Daerah: Pendidikan, Seni, Budaya & Olahraga',
                        style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // SEGMENTED SWITCHER (CABANG VS PUSAT)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
                            '📍 Event Daerah (Lokal)',
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
                            '👑 Event Pusat (Nasional)',
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

            // 4 PILAR FILTER CHIPS (PENDIDIKAN, KESENIAN, KEBUDAYAAN, OLAHRAGA)
            Container(
              height: 38,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _pillarFilters.length,
                itemBuilder: (context, idx) {
                  final isSelected = _selectedPillarIndex == idx;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPillarIndex = idx),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0F172A) : NeoColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: NeoColors.black, width: 1.8),
                        boxShadow: isSelected
                            ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _pillarFilters[idx],
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? NeoColors.white : NeoColors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
