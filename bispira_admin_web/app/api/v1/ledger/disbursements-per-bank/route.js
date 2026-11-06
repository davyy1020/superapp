import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const status = (searchParams.get('status') || '').toLowerCase().trim();
    const recalculate = searchParams.get('recalculate') === 'true';

    let list = [];

    if (
      recalculate &&
      db.disbursementAccumulations &&
      db.disbursementAccumulations.length > 0 &&
      db.disbursementsPerBank
    ) {
      // Dynamic aggregation implementing exact Sheet 6 COUNTIF & SUMIF formulas over Sheet 5
      const bankNames = db.disbursementsPerBank.map((b) => b.nama_bank);

      list = bankNames.map((bankName, idx) => {
        const matches = db.disbursementAccumulations.filter(
          (d) => (d.bank_tujuan || '').toUpperCase() === bankName.toUpperCase()
        );

        const mitraCount = matches.length;
        const gross = matches.reduce((s, i) => s + Number(i.total_hak_gross || 0), 0);
        const biayaTrx = matches.reduce((s, i) => s + Number(i.biaya_layanan_trx || 0), 0);
        const biayaPencairan = matches.reduce((s, i) => s + Number(i.biaya_pencairan || 0), 0);
        const net = gross - biayaTrx - biayaPencairan;

        return {
          no: idx + 1,
          nama_bank: bankName,
          jumlah_mitra: mitraCount,
          total_pencairan_gross: gross,
          total_biaya_layanan_trx: biayaTrx,
          total_biaya_pencairan: biayaPencairan,
          net_disbursement: net,
        };
      });
    } else {
      list = [...(db.disbursementsPerBank || [])];
    }

    if (q) {
      list = list.filter(
        (item) => item.nama_bank && item.nama_bank.toLowerCase().includes(q)
      );
    }

    if (status) {
      if (status === 'active' || status === 'aktif') {
        list = list.filter((item) => (item.jumlah_mitra || 0) > 0);
      } else if (status === 'standby' || status === 'empty') {
        list = list.filter((item) => (item.jumlah_mitra || 0) === 0);
      }
    }

    const calculatedSummary = {
      totalBank: list.length,
      totalBankAktif: list.filter((i) => (i.jumlah_mitra || 0) > 0).length,
      totalBankStandby: list.filter((i) => (i.jumlah_mitra || 0) === 0).length,
      totalMitra: list.reduce((s, i) => s + (i.jumlah_mitra || 0), 0),
      totalGross: list.reduce((s, i) => s + (i.total_pencairan_gross || 0), 0),
      totalBiayaLayananTrx: list.reduce((s, i) => s + (i.total_biaya_layanan_trx || 0), 0),
      totalBiayaPencairan: list.reduce((s, i) => s + (i.total_biaya_pencairan || 0), 0),
      totalNetDisbursement: list.reduce((s, i) => s + (i.net_disbursement || 0), 0),
    };

    return NextResponse.json({
      success: true,
      message:
        'Rekapitulasi Akumulasi Pencairan Dana Per Bank Operasional Superadmin (Sheet 6) berhasil diambil.',
      sheet: '6. Pencairan Per Bank',
      subtitle:
        'Konsolidasi Arus Kas Keluar per Bank Operasional (9 Bank Aktif, 3 Bank Cadangan) untuk Rekonsiliasi Rekening Giro Superadmin.',
      summary: calculatedSummary,
      data: list,
    });
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

