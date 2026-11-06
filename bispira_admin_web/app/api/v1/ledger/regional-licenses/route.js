import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const bank = (searchParams.get('bank') || '').toUpperCase().trim();

    let rawList = [...(db.profilLisensiDaerah || [])];
    let list = rawList.map((item) => ({
      no: item.no,
      nama_pembeli_lisensi: item.nama_pembeli_lisensi || item.namaPembeliLisensi,
      namaPembeliLisensi: item.namaPembeliLisensi || item.nama_pembeli_lisensi,
      kabupaten_kota: item.kabupaten_kota || item.kabupatenKota,
      kabupatenKota: item.kabupatenKota || item.kabupaten_kota,
      no_wa_telepon: item.no_wa_telepon || item.noWaTelepon || '6221',
      noWaTelepon: item.noWaTelepon || item.no_wa_telepon || '6221',
      rekening_bank_aktif: item.rekening_bank_aktif || item.rekeningBankAktif,
      rekeningBankAktif: item.rekeningBankAktif || item.rekening_bank_aktif,
      nama_pemilik_rekening: item.nama_pemilik_rekening || item.namaPemilikRekening,
      namaPemilikRekening: item.namaPemilikRekening || item.nama_pemilik_rekening,
      jumlah_penjual_aktif: item.jumlah_penjual_aktif !== undefined ? item.jumlah_penjual_aktif : item.jumlahPenjualAktif,
      jumlahPenjualAktif: item.jumlahPenjualAktif !== undefined ? item.jumlahPenjualAktif : item.jumlah_penjual_aktif,
      jumlah_driver_aktif: item.jumlah_driver_aktif !== undefined ? item.jumlah_driver_aktif : item.jumlahDriverAktif,
      jumlahDriverAktif: item.jumlahDriverAktif !== undefined ? item.jumlahDriverAktif : item.jumlah_driver_aktif,
      jumlah_event_bispira: item.jumlah_event_bispira !== undefined ? item.jumlah_event_bispira : item.jumlahEventBispira,
      jumlahEventBispira: item.jumlahEventBispira !== undefined ? item.jumlahEventBispira : item.jumlah_event_bispira,
      jumlah_event_kompetisi: item.jumlah_event_kompetisi !== undefined ? item.jumlah_event_kompetisi : item.jumlahEventKompetisi,
      jumlahEventKompetisi: item.jumlahEventKompetisi !== undefined ? item.jumlahEventKompetisi : item.jumlah_event_kompetisi,
      jumlah_event_evoting: item.jumlah_event_evoting !== undefined ? item.jumlah_event_evoting : item.jumlahEventEvoting,
      jumlahEventEvoting: item.jumlahEventEvoting !== undefined ? item.jumlahEventEvoting : item.jumlah_event_evoting,
      total_event: item.total_event !== undefined ? item.total_event : item.totalEvent,
      totalEvent: item.totalEvent !== undefined ? item.totalEvent : item.total_event,
    }));

    if (q) {
      list = list.filter(
        (item) =>
          (item.nama_pembeli_lisensi && item.nama_pembeli_lisensi.toLowerCase().includes(q)) ||
          (item.kabupaten_kota && item.kabupaten_kota.toLowerCase().includes(q)) ||
          (item.rekening_bank_aktif && item.rekening_bank_aktif.toLowerCase().includes(q))
      );
    }

    if (bank && bank !== 'SEMUA') {
      list = list.filter((i) => (i.rekening_bank_aktif || '').toUpperCase().includes(bank));
    }

    const calculatedSummary = {
      totalLisensi: list.length,
      totalPenjualAktif: list.reduce((s, i) => s + Number(i.jumlah_penjual_aktif || 0), 0),
      totalDriverAktif: list.reduce((s, i) => s + Number(i.jumlah_driver_aktif || 0), 0),
      totalEventBispira: list.reduce((s, i) => s + Number(i.jumlah_event_bispira || 0), 0),
      totalEventKompetisi: list.reduce((s, i) => s + Number(i.jumlah_event_kompetisi || 0), 0),
      totalEventEvoting: list.reduce((s, i) => s + Number(i.jumlah_event_evoting || 0), 0),
      totalSemuaEvent: list.reduce(
        (s, i) =>
          s +
          Number(i.jumlah_event_bispira || 0) +
          Number(i.jumlah_event_kompetisi || 0) +
          Number(i.jumlah_event_evoting || 0),
        0
      ),
    };

    return NextResponse.json({
      status: 'SUCCESS',
      success: true,
      message: 'Master Profil Pembeli Lisensi Admin Daerah Bispira (Sheet 8) berhasil diambil.',
      sheet: '8. Profil Lisensi Daerah',
      title: 'MASTER PROFIL PEMBELI LISENSI ADMIN DAERAH BISPIRA',
      subtitle: 'Data Pemegang Lisensi Resmi Kabupaten/Kota Aktif',
      data: {
        licenses: list,
        totalSummary: calculatedSummary,
        count: list.length,
      },
    });
  } catch (error) {
    return NextResponse.json({ status: 'ERROR', success: false, error: error.message }, { status: 500 });
  }
}

