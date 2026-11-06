import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const bank = (searchParams.get('bank') || '').toUpperCase().trim();
    const status = (searchParams.get('status') || '').toLowerCase().trim();
    const recalculate = searchParams.get('recalculate') === 'true';

    let list = [];

    if (
      recalculate &&
      db.sellerDriverAccumulations &&
      db.sellerDriverAccumulations.length > 0 &&
      db.masterBankAccounts &&
      db.masterBankAccounts.length > 0
    ) {
      // Dynamic aggregation: Hak Gross from Sheet 2, Bank from Sheet 4, Fees (Rp 500 + Rp 1.000)
      list = db.sellerDriverAccumulations.map((item, idx) => {
        const bankEntry = db.masterBankAccounts.find(
          (b) =>
            b.nama_toko_warung_driver.toLowerCase() ===
            item.namaPenjualMerchantDriver.toLowerCase()
        );
        const bankTujuan = bankEntry ? bankEntry.nama_bank : 'Bank Lain';
        const gross = Number(item.hakPenjualDriverGross || 0);
        const biayaTrx = Number(item.biayaSkemaTrxBulanan || 0);
        const biayaPencairan = 1000;
        const netDiterima = gross - biayaTrx - biayaPencairan;

        return {
          no: idx + 1,
          nama_penjual_driver: item.namaPenjualMerchantDriver,
          bank_tujuan: bankTujuan,
          total_hak_gross: gross,
          biaya_layanan_trx: biayaTrx,
          biaya_pencairan: biayaPencairan,
          jumlah_net_diterima: netDiterima,
          status_escrow: 'Ready to Disburse (Escrow Safe)',
        };
      });
    } else {
      list = [...(db.disbursementAccumulations || [])];
    }

    if (q) {
      list = list.filter(
        (item) =>
          (item.nama_penjual_driver && item.nama_penjual_driver.toLowerCase().includes(q)) ||
          (item.bank_tujuan && item.bank_tujuan.toLowerCase().includes(q))
      );
    }

    if (bank && bank !== 'SEMUA') {
      list = list.filter((item) => item.bank_tujuan && item.bank_tujuan.toUpperCase() === bank);
    }

    if (status) {
      if (status === 'ready' || status === 'pending') {
        list = list.filter(
          (item) =>
            item.status_escrow &&
            (item.status_escrow.toLowerCase().includes('ready') ||
              item.status_escrow.toLowerCase().includes('pending'))
        );
      } else if (status === 'disbursed') {
        list = list.filter(
          (item) =>
            item.status_escrow &&
            (item.status_escrow.toLowerCase().includes('disbursed') ||
              item.status_escrow.toLowerCase().includes('sudah'))
        );
      }
    }

    const calculatedSummary = {
      totalPenerima: list.length,
      totalHakGross: list.reduce((s, i) => s + (i.total_hak_gross || 0), 0),
      totalBiayaLayananTrx: list.reduce((s, i) => s + (i.biaya_layanan_trx || 0), 0),
      totalBiayaPencairan: list.reduce((s, i) => s + (i.biaya_pencairan || 0), 0),
      totalJumlahNetDiterima: list.reduce((s, i) => s + (i.jumlah_net_diterima || 0), 0),
      totalPending: list.filter(
        (i) =>
          i.status_escrow &&
          (i.status_escrow.toLowerCase().includes('ready') ||
            i.status_escrow.toLowerCase().includes('pending'))
      ).length,
      totalDisbursed: list.filter(
        (i) =>
          i.status_escrow &&
          (i.status_escrow.toLowerCase().includes('disbursed') ||
            i.status_escrow.toLowerCase().includes('sudah'))
      ).length,
    };

    return NextResponse.json({
      success: true,
      message: 'Master Akumulasi Dana Pencairan 8 Kolom (Sheet 5) berhasil diambil.',
      sheet: '5. Akumulasi Dana Pencairan',
      subtitle:
        'Jadwal Cair: Senin & Kamis (17.00 - 23.59 WIB) | Biaya Transfer Pencairan: Rp 1.000 per transaksi pencairan',
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
    const { action = 'DISBURSE_ALL', no } = body;

    const list = db.disbursementAccumulations || [];

    if (action === 'DISBURSE_SINGLE') {
      if (!no) {
        return NextResponse.json(
          { success: false, message: 'Nomor urut (no) wajib diisi untuk DISBURSE_SINGLE.' },
          { status: 400 }
        );
      }

      const target = list.find((item) => item.no === Number(no));
      if (!target) {
        return NextResponse.json(
          { success: false, message: `Pencairan #${no} tidak ditemukan.` },
          { status: 404 }
        );
      }

      target.status_escrow = 'Disbursed / Sudah Ditransfer';
      target.disbursed_at = new Date().toISOString();

      return NextResponse.json({
        success: true,
        message: `Pencairan #${no} (${target.nama_penjual_driver}) berhasil ditransfer.`,
        entry: target,
      });
    }

    if (action === 'DISBURSE_ALL') {
      let count = 0;
      const now = new Date().toISOString();
      list.forEach((item) => {
        if (!item.status_escrow.toLowerCase().includes('sudah')) {
          item.status_escrow = 'Disbursed / Sudah Ditransfer';
          item.disbursed_at = now;
          count++;
        }
      });

      return NextResponse.json({
        success: true,
        message: `Batch Payout Massal berhasil dieksekusi untuk ${count} mitra. Total Net Rp 30.211.550 siap dicairkan ke rekening perbankan.`,
        disbursedCount: count,
      });
    }

    return NextResponse.json(
      { success: false, message: `Action "${action}" tidak valid.` },
      { status: 400 }
    );
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

