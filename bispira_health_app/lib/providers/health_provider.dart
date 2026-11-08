import 'package:flutter/material.dart';

enum HealthProfession {
  dokterSpesialis,
  dokterUmum,
  bidan,
  fisioterapi,
  psikolog,
  psikiater,
  perawatHomecare,
  caregiver,
  apoteker,
  spaTerapis,
}

enum VisitType {
  chatTelemedicine,
  homeVisit,
  clinicVisit,
}

class HealthServiceItem {
  final String id;
  String name;
  String category;
  VisitType visitType;
  int basePrice; // 100% masuk ke tenaga medis
  int durationMinutes;
  bool isAvailable;
  String description;

  HealthServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.visitType,
    required this.basePrice,
    this.durationMinutes = 30,
    this.isAvailable = true,
    this.description = '',
  });

  // PKS & Excel Sheet 1 & 9: Mark Up 10% untuk tampilan aplikasi pasien
  int get consumerPrice => (basePrice * 1.10).round();
  int get platformMarkup => consumerPrice - basePrice;
}

class PatientConsultation {
  final String id;
  final String patientName;
  final int patientAge;
  final String gender;
  final String complaint;
  final VisitType visitType;
  final String scheduleTime;
  final int fee;
  String status; // 'waiting', 'active', 'completed', 'cancelled'
  String? diagnosis;
  String? ePrescription;

  PatientConsultation({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.gender,
    required this.complaint,
    required this.visitType,
    required this.scheduleTime,
    required this.fee,
    this.status = 'waiting',
    this.diagnosis,
    this.ePrescription,
  });
}

class HealthProvider extends ChangeNotifier {
  // Profil Tenaga Medis (Sesuai FORMULIR PENJUAL Sheet 'TENAGA KESEHATAN')
  String practitionerName = 'dr. Farhan Alamsyah, Sp.PD';
  String strNumber = 'STR-IDI-3374-2026-8891';
  String sipNumber = '503/SIP.DS/DINKES/2026';
  HealthProfession profession = HealthProfession.dokterSpesialis;
  String clinicHospital = 'Klinik Pratama Sehat Bispira & RSUD Dr. Kariadi';
  String practiceAddress = 'Jl. Pandanaran No. 42, Kota Semarang';
  double rating = 4.95;
  int totalPatients = 382;
  bool isOnline = true;

  // Keuangan & Saldo (Excel Sheet 2, 4, 5)
  int walletBalance = 3850000;
  int todayEarnings = 450000;
  int totalWithdrawn = 14200000;
  String bankAccount = 'BCA - 0884910284 (dr. Farhan Alamsyah)';
  String payoutBatchInfo = 'Pencairan Otomatis Batch 17:00 WIB (Senin & Kamis)';

  final List<HealthServiceItem> _services = [
    HealthServiceItem(
      id: 'HLT-001',
      name: 'Telemedicine Chat Medis & Resep',
      category: 'Dokter Spesialis Penyakit Dalam',
      visitType: VisitType.chatTelemedicine,
      basePrice: 50000,
      durationMinutes: 30,
      description: 'Konsultasi keluhan medis secara daring, penegakan diagnosa awal, dan resep digital (e-Prescription).',
    ),
    HealthServiceItem(
      id: 'HLT-002',
      name: 'Pemeriksaan Tatap Muka di Klinik',
      category: 'Dokter Spesialis Penyakit Dalam',
      visitType: VisitType.clinicVisit,
      basePrice: 100000,
      durationMinutes: 45,
      description: 'Pemeriksaan fisik langsung di ruang praktik klinik dokter.',
    ),
    HealthServiceItem(
      id: 'HLT-003',
      name: 'Layanan Home Visit Dokter ke Rumah',
      category: 'Kunjungan Medis ke Rumah',
      visitType: VisitType.homeVisit,
      basePrice: 200000,
      durationMinutes: 60,
      description: 'Pemeriksaan pasien di rumah oleh dokter lengkap dengan tensi, glukosa, dan tindakan dasar.',
    ),
  ];

  final List<PatientConsultation> _consultations = [
    PatientConsultation(
      id: 'CON-8841',
      patientName: 'Budi Santoso',
      patientAge: 46,
      gender: 'Laki-laki',
      complaint: 'Demam tinggi 3 hari disertai batuk kering dan nyeri sendi hebat.',
      visitType: VisitType.chatTelemedicine,
      scheduleTime: 'Hari ini • 09:30 WIB',
      fee: 50000,
      status: 'active',
      diagnosis: 'Suspek Infeksi Saluran Pernapasan Akut (ISPA) febris',
      ePrescription: 'Paracetamol 500mg (3x1), N-Acetylcysteine 200mg (3x1), Vitamin C 500mg',
    ),
    PatientConsultation(
      id: 'CON-8842',
      patientName: 'Siti Rahmawati',
      patientAge: 32,
      gender: 'Perempuan',
      complaint: 'Nyeri ulu hati menjalar ke punggung dan sering mual di pagi hari.',
      visitType: VisitType.chatTelemedicine,
      scheduleTime: 'Hari ini • 11:00 WIB',
      fee: 50000,
      status: 'waiting',
    ),
    PatientConsultation(
      id: 'CON-8839',
      patientName: 'H. Ahmad Subagyo',
      patientAge: 68,
      gender: 'Laki-laki',
      complaint: 'Kontrol rutin hipertensi dan evaluasi obat jantung pasca rawat inap.',
      visitType: VisitType.homeVisit,
      scheduleTime: 'Kemarin • 15:00 WIB',
      fee: 200000,
      status: 'completed',
      diagnosis: 'Hipertensi Grade II terkontrol',
      ePrescription: 'Amlodipine 10mg (1x1 malam), Candesartan 8mg (1x1 pagi)',
    ),
  ];

  List<HealthServiceItem> get services => _services;
  List<PatientConsultation> get consultations => _consultations;

  void toggleOnlineStatus() {
    isOnline = !isOnline;
    notifyListeners();
  }

  void addService(HealthServiceItem item) {
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

  void updateConsultationStatus(String id, String newStatus, {String? diagnosis, String? prescription}) {
    final idx = _consultations.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _consultations[idx].status = newStatus;
      if (diagnosis != null) _consultations[idx].diagnosis = diagnosis;
      if (prescription != null) _consultations[idx].ePrescription = prescription;
      if (newStatus == 'completed') {
        walletBalance += _consultations[idx].fee;
        todayEarnings += _consultations[idx].fee;
        totalPatients += 1;
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

