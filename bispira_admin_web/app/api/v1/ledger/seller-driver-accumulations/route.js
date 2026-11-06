import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const kategori = (searchParams.get('kategori') || '').toUpperCase().trim();
    const recalculate = searchParams.get('recalculate') === 'true';

    let list = [];

    if (recalculate && db.ledgerTransactions && db.ledgerTransactions.length > 0) {
      // Dynamic aggregation from 21-column ledger transactions
      const map = new Map();

      db.ledgerTransactions.forEach((tx) => {
        const name = tx.penjualMerchantDriver || 'Mitra Lain';
        const kat = tx.layananProduk ? tx.layananProduk.split(' ')[0] : 'Umum';

        if (!map.has(name)) {
          map.set(name, {
            no: map.size + 1,
            namaPenjualMerchantDriver: name,
            kategoriBisnis: kat,
            totalTrx: 0,
            akumulasiHargaDasar: 0,
            akumulasiBiayaAngkut: 0,
            akumulasiKomisiMarketplace: 0,
            hakPenjualDriverGross: 0,
            biayaSkemaTrxBulanan: 0,
          });
        }

        const entry = map.get(name);
        entry.totalTrx += 1;
        entry.akumulasiHargaDasar += Number(tx.hargaDasar || 0);
        entry.akumulasiBiayaAngkut += Number(tx.biayaAngkut || 0);
        entry.akumulasiKomisiMarketplace += Number(tx.komisiMarketplace || 0);
        entry.hakPenjualDriverGross =
          entry.akumulasiHargaDasar + entry.akumulasiBiayaAngkut - entry.akumulasiKomisiMarketplace;
        entry.biayaSkemaTrxBulanan = entry.totalTrx * 500;
      });

      list = Array.from(map.values());
    } else {
      list = [...(db.sellerDriverAccumulations || [])];
    }

    if (q) {
      list = list.filter(
        (item) =>
          (item.namaPenjualMerchantDriver &&
            item.namaPenjualMerchantDriver.toLowerCase().includes(q)) ||
          (item.kategoriBisnis && item.kategoriBisnis.toLowerCase().includes(q))
      );
    }

    if (kategori && kategori !== 'SEMUA') {
      list = list.filter(
        (item) => item.kategoriBisnis && item.kategoriBisnis.toUpperCase() === kategori
      );
    }

    const calculatedSummary = {
      totalMitra: list.length,
      totalTrx: list.reduce((s, i) => s + (i.totalTrx || 0), 0),
      totalHargaDasar: list.reduce((s, i) => s + (i.akumulasiHargaDasar || 0), 0),
      totalBiayaAngkut: list.reduce((s, i) => s + (i.akumulasiBiayaAngkut || 0), 0),
      totalKomisiMarketplace: list.reduce(
        (s, i) => s + (i.akumulasiKomisiMarketplace || 0),
        0
      ),
      totalHakPenjualDriverGross: list.reduce(
        (s, i) => s + (i.hakPenjualDriverGross || 0),
        0
      ),
      totalBiayaSkemaTrx: list.reduce(
        (s, i) => s + (i.biayaSkemaTrxBulanan || 0),
        0
      ),
    };

    return NextResponse.json({
      success: true,
      message: 'Master Akumulasi Penjual & Driver 9 Kolom (Sheet 2) berhasil diambil.',
      summary: calculatedSummary,
      data: list,
    });
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

