import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const bank = (searchParams.get('bank') || '').toUpperCase().trim();
    const metode = (searchParams.get('metode') || '').toUpperCase().trim();

    let list = db.ledgerTransactions || [];

    if (q) {
      list = list.filter((item) =>
        (item.namaPembeli && item.namaPembeli.toLowerCase().includes(q)) ||
        (item.layananProduk && item.layananProduk.toLowerCase().includes(q)) ||
        (item.penjualMerchantDriver && item.penjualMerchantDriver.toLowerCase().includes(q)) ||
        (item.wilayahKabKota && item.wilayahKabKota.toLowerCase().includes(q))
      );
    }

    if (bank && bank !== 'SEMUA') {
      list = list.filter((item) => (item.bank && item.bank.toUpperCase() === bank));
    }

    if (metode && metode !== 'SEMUA') {
      list = list.filter((item) => (item.metodeBayar && item.metodeBayar.toUpperCase().includes(metode)));
    }

    const calculatedSummary = {
      totalTransactions: list.length,
      totalHargaDasar: list.reduce((s, i) => s + (i.hargaDasar || 0), 0),
      totalHargaResmi: list.reduce((s, i) => s + (i.hargaResmi || 0), 0),
      totalBayarPembeli: list.reduce((s, i) => s + (i.totalBayarPembeli || 0), 0),
      totalKomisiMarketplace: list.reduce((s, i) => s + (i.komisiMarketplace || 0), 0),
      totalHakPenjualDriverNet: list.reduce((s, i) => s + (i.hakPenjualDriverNet || 0), 0),
      totalPusatNetProfit: list.reduce((s, i) => s + (i.pusatNetProfit || 0), 0),
    };

    return NextResponse.json({
      success: true,
      message: 'Master Detail Transaksi 21 Kolom (Sheet 1) berhasil diambil.',
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
    const {
      namaPembeli,
      layananProduk,
      penjualMerchantDriver,
      wilayahKabKota,
      provinsi,
      bank,
      metodeBayar,
      hargaDasar,
      biayaAngkut = 0,
      komisiMarketplace,
    } = body;

    if (!namaPembeli || !layananProduk || !hargaDasar) {
      return NextResponse.json(
        { success: false, message: 'namaPembeli, layananProduk, dan hargaDasar wajib diisi.' },
        { status: 400 }
      );
    }

    const basePrice = Number(hargaDasar);
    const angkut = Number(biayaAngkut || 0);
    const isTopUp = layananProduk.toLowerCase().includes('top up');
    const isCash = (metodeBayar || '').toLowerCase().includes('cash');

    // Excel Sheet 1 Calculation Formulas
    const markup10 = isTopUp ? 0 : Math.round(basePrice * 0.10);
    const hargaResmi = basePrice + markup10;
    const biayaLayanan = 500;
    const biayaAplikasi = 500;
    const kodeUnikBank = isCash ? 0 : (100 + Math.floor(Math.random() * 899));
    const totalBayarPembeli = hargaResmi + biayaLayanan + biayaAplikasi + angkut + kodeUnikBank;

    // Default commission if not provided: 5% of base, or 7.5% for car, or 1% for porter
    let komisi = komisiMarketplace != null ? Number(komisiMarketplace) : Math.round(basePrice * 0.05);
    if (isTopUp) komisi = 0;

    const hakPenjualDriverNet = basePrice + angkut - komisi;
    const pusatNetProfit = markup10 + biayaLayanan + biayaAplikasi + komisi + kodeUnikBank;

    const now = new Date();
    const tanggal = now.toISOString().slice(0, 10);
    const jamWib = now.toTimeString().slice(0, 8);

    const nextNo = (db.ledgerTransactions?.length || 0) + 1;

    const newTx = {
      no: nextNo,
      tanggal,
      jam: jamWib,
      namaPembeli,
      layananProduk,
      penjualMerchantDriver: penjualMerchantDriver || 'Mitra BISPIRA',
      wilayahKabKota: wilayahKabKota || 'Nasional',
      provinsi: provinsi || 'Indonesia',
      bank: bank || (isCash ? 'Cash' : 'BCA'),
      metodeBayar: metodeBayar || (isCash ? 'Cash' : 'Transfer Bank'),
      hargaDasar: basePrice,
      markup10,
      hargaResmi,
      biayaLayanan,
      biayaAplikasi,
      biayaAngkut: angkut,
      kodeUnikBank,
      totalBayarPembeli,
      komisiMarketplace: komisi,
      hakPenjualDriverNet,
      pusatNetProfit,
    };

    if (!db.ledgerTransactions) {
      db.ledgerTransactions = [];
    }
    db.ledgerTransactions.unshift(newTx);

    return NextResponse.json({
      success: true,
      message: `Transaksi #${newTx.no} berhasil dicatat ke Ledger Real-Time sesuai rumus Excel Sheet 1.`,
      data: newTx,
    });
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

