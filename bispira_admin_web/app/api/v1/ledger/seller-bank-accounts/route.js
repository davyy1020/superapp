import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const bank = (searchParams.get('bank') || '').toUpperCase().trim();
    const kategori = (searchParams.get('kategori') || '').toUpperCase().trim();

    let list = [...(db.masterBankAccounts || [])];

    if (q) {
      list = list.filter(
        (item) =>
          (item.nama_toko_warung_driver && item.nama_toko_warung_driver.toLowerCase().includes(q)) ||
          (item.nama_pemilik && item.nama_pemilik.toLowerCase().includes(q)) ||
          (item.nomor_rekening && item.nomor_rekening.includes(q)) ||
          (item.nama_bank && item.nama_bank.toLowerCase().includes(q))
      );
    }

    if (bank && bank !== 'SEMUA') {
      list = list.filter((item) => item.nama_bank && item.nama_bank.toUpperCase() === bank);
    }

    if (kategori && kategori !== 'SEMUA') {
      list = list.filter(
        (item) => item.kategori_entitas && item.kategori_entitas.toUpperCase() === kategori
      );
    }

    const bankCounts = {};
    (db.masterBankAccounts || []).forEach((item) => {
      bankCounts[item.nama_bank] = (bankCounts[item.nama_bank] || 0) + 1;
    });

    const calculatedSummary = {
      totalRekening: list.length,
      totalRekeningSemua: (db.masterBankAccounts || []).length,
      totalMerchant: list.filter((i) => !i.nama_toko_warung_driver.toLowerCase().includes('driver'))
        .length,
      totalDriver: list.filter((i) => i.nama_toko_warung_driver.toLowerCase().includes('driver'))
        .length,
      bankDistribution: bankCounts,
    };

    return NextResponse.json({
      success: true,
      message: 'Master Rekening Toko / Warung / Merchant / Driver (Sheet 4) berhasil diambil.',
      sheet: '4. Master Rekening Penjual',
      subtitle:
        'Direktori Master Rekening Bank Operasional Mitra untuk Rekonsiliasi, Validasi Mutasi, dan Batch Payout Harian.',
      summary: calculatedSummary,
      data: list,
    });
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

export async function POST(request) {
  try {
    const body = await request.json();
    const { namaTokoWarungDriver, namaPemilik, kategoriEntitas, namaBank, nomorRekening, cabangKota } =
      body;

    if (!namaTokoWarungDriver || !nomorRekening || !namaBank) {
      return NextResponse.json(
        { success: false, message: 'namaTokoWarungDriver, nomorRekening, dan namaBank wajib diisi.' },
        { status: 400 }
      );
    }

    const list = db.masterBankAccounts || [];
    const newEntry = {
      no: list.length + 1,
      nama_toko_warung_driver: namaTokoWarungDriver,
      nama_pemilik: namaPemilik || `Bpk/Ibu ${namaTokoWarungDriver}`,
      kategori_entitas: kategoriEntitas || 'Umum',
      nama_bank: namaBank,
      nomor_rekening: String(nomorRekening).trim(),
      cabang_kota: cabangKota || 'Cabang Utama',
    };

    list.push(newEntry);

    return NextResponse.json({
      success: true,
      message: 'Master Rekening baru berhasil ditambahkan.',
      entry: newEntry,
    });
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

export async function PUT(request) {
  try {
    const body = await request.json();
    const { no, namaBank, nomorRekening, namaPemilik, cabangKota } = body;

    if (!no) {
      return NextResponse.json({ success: false, message: 'Nomor urut (no) wajib diisi.' }, { status: 400 });
    }

    const list = db.masterBankAccounts || [];
    const target = list.find((item) => item.no === Number(no));

    if (!target) {
      return NextResponse.json(
        { success: false, message: `Rekening dengan no #${no} tidak ditemukan.` },
        { status: 404 }
      );
    }

    if (namaBank) target.nama_bank = namaBank;
    if (nomorRekening) target.nomor_rekening = String(nomorRekening).trim();
    if (namaPemilik) target.nama_pemilik = namaPemilik;
    if (cabangKota) target.cabang_kota = cabangKota;

    return NextResponse.json({
      success: true,
      message: `Master Rekening #${no} berhasil diperbarui.`,
      entry: target,
    });
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

