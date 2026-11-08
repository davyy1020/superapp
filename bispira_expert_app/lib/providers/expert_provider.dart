import 'package:flutter/material.dart';

enum ExpertCategory {
  lesPrivatAkademik,
  trainerKejuruan,
  konsultanAhli,
  entertainmentMC,
  entertainmentMusik,
  teknisiService,
  penceramah,
}

class ExpertServiceItem {
  final String id;
  String name;
  String category;
  String unitLabel; // 'per Sesi (90 Menit)', 'per Event / Acara', 'per Unit AC'
  int basePrice; // 100% masuk ke mitra ahli
  bool isAvailable;
  String description;

  ExpertServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unitLabel,
    required this.basePrice,
    this.isAvailable = true,
    this.description = '',
  });

  // PKS & Excel Sheet 1 & 9: Mark Up 10% untuk tampilan aplikasi murid / klien
  int get consumerPrice => (basePrice * 1.10).round();
  int get platformMarkup => consumerPrice - basePrice;
}

class ClientBooking {
  final String id;
  final String clientName;
  final String clientPhone;
  final String locationAddress;
  final String serviceName;
  final String scheduleDate;
  final int fee;
  String status; // 'pending', 'confirmed', 'ongoing', 'completed', 'cancelled'
  String? clientNotes;

  ClientBooking({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.locationAddress,
    required this.serviceName,
    required this.scheduleDate,
    required this.fee,
    this.status = 'pending',
    this.clientNotes,
  });
}

class ExpertProvider extends ChangeNotifier {
  // Profil Mitra (FORMULIR PENJUAL Sheet 'BIMBELPRIVAT' & 'ENTERTAINMENT')
  String expertName = 'Hendra Wijaya, S.Pd., M.Kom.';
  String professionTitle = 'Guru Les Privat Matematika/Fisika & Trainer IT';
  String degreeCertification = 'S2 Ilmu Komputer Undip • Sertifikasi Pendidik BNSP';
  String operationalCity = 'Kota Semarang & Sekitarnya (Online / Onsite)';
  double rating = 4.96;
  int totalSessionsCompleted = 412;
  bool isReadyForBooking = true;

  // Keuangan & Saldo (Excel Sheet 2, 4, 5)
  int walletBalance = 4250000;
  int todayEarnings = 350000;
  int totalWithdrawn = 18900000;
  String bankAccount = 'Bank Mandiri - 13600192841 (Hendra Wijaya)';
  String payoutBatchInfo = 'Pencairan Otomatis Batch 17:00 WIB (Senin & Kamis)';

  final List<ExpertServiceItem> _services = [
    ExpertServiceItem(
      id: 'EXP-001',
      name: 'Les Privat Matematika & Fisika SMA (SNBT UTBK)',
      category: 'Edukasi & Bimbel Privat',
      unitLabel: 'per Sesi (90 Menit)',
      basePrice: 85000,
      description: 'Bimbingan intensif persiapan ujian sekolah & seleksi masuk perguruan tinggi negeri. Datang ke rumah atau daring via Google Meet.',
    ),
    ExpertServiceItem(
      id: 'EXP-002',
      name: 'Kursus Privat Pemrograman Web & Flutter Mobile',
      category: 'Trainer Pelatihan Kejuruan',
      unitLabel: 'per Sesi (120 Menit)',
      basePrice: 150000,
      description: 'Pelatihan langsung dari nol hingga membuat aplikasi siap rilis ke Play Store. Praktek intensif 1-on-1.',
    ),
    ExpertServiceItem(
      id: 'EXP-003',
      name: 'Master of Ceremony (MC) Wedding & Corporate Event',
      category: 'Entertainment & Acara',
      unitLabel: 'per Event / Acara (4 Jam)',
      basePrice: 1200000,
      description: 'MC profesional bilingual (Indonesia - Inggris) berpengalaman memandu lebih dari 150 pernikahan dan seminar nasional.',
    ),
    ExpertServiceItem(
      id: 'EXP-004',
      name: 'Jasa Cuci AC & Perawatan Rutin 0.5 - 2 PK',
      category: 'Teknisi Service Panggilan',
      unitLabel: 'per Unit AC',
      basePrice: 65000,
      description: 'Pembersihan evaporator, kondensor, tes tekanan freon, dan garansi kebocoran 30 hari.',
    ),
  ];

  final List<ClientBooking> _bookings = [
    ClientBooking(
      id: 'BKG-9921',
      clientName: 'Ibu Ratna Kumalasari',
      clientPhone: '0812-4455-6677',
      locationAddress: 'Jl. Erlangga Tengah No. 18, Pleburan, Semarang',
      serviceName: 'Les Privat Matematika & Fisika SMA',
      scheduleDate: 'Hari ini • 15:30 WIB',
      fee: 85000,
      status: 'confirmed',
      clientNotes: 'Materi persiapan ujian semester kelas 12 Bab Kalkulus & Dinamika Rotasi.',
    ),
    ClientBooking(
      id: 'BKG-9922',
      clientName: 'PT. Surya Nusantara Mandiri',
      clientPhone: '0813-7788-9900',
      locationAddress: 'Ballroom Hotel Ciputra Simpang Lima, Semarang',
      serviceName: 'Master of Ceremony (MC) Wedding & Corporate Event',
      scheduleDate: 'Sabtu, 14 Nov 2026 • 18:30 WIB',
      fee: 1200000,
      status: 'pending',
      clientNotes: 'Acara Annual Gala Dinner Mitra Bispira 2026.',
    ),
    ClientBooking(
      id: 'BKG-9918',
      clientName: 'Pak Dedy Prasetyo',
      clientPhone: '0811-2233-4455',
      locationAddress: 'Perumahan Bukit Sari No. 12, Banyumanik, Semarang',
      serviceName: 'Jasa Cuci AC & Perawatan Rutin',
      scheduleDate: 'Kemarin • 10:00 WIB',
      fee: 130000, // 2 Unit
      status: 'completed',
      clientNotes: 'Cuci 2 unit AC inverter kamar tidur dan ruang keluarga.',
    ),
  ];

  List<ExpertServiceItem> get services => _services;
  List<ClientBooking> get bookings => _bookings;

  void toggleAvailability() {
    isReadyForBooking = !isReadyForBooking;
    notifyListeners();
  }

  void addService(ExpertServiceItem item) {
    _services.add(item);
    notifyListeners();
  }

  void toggleServiceAvailability(String id) {
    final idx = _services.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _services[idx].isAvailable = !_services[idx].isAvailable;
      notifyListeners();
    }
  }

  void updateBookingStatus(String id, String newStatus) {
    final idx = _bookings.indexWhere((b) => b.id == id);
    if (idx != -1) {
      _bookings[idx].status = newStatus;
      if (newStatus == 'completed') {
        walletBalance += _bookings[idx].fee;
        todayEarnings += _bookings[idx].fee;
        totalSessionsCompleted += 1;
      }
      notifyListeners();
    }
  }

  bool withdrawFunds(int amount) {
    if (amount <= walletBalance && amount >= 50000) {
      walletBalance -= amount;
      totalWithdrawn += amount;
      notifyListeners();
      return true;
    }
    return false;
  }
}

