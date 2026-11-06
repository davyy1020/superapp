import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const moda = (searchParams.get('moda') || '').toUpperCase().trim();
    const status = (searchParams.get('status') || '').toLowerCase().trim();
    const recalculate = searchParams.get('recalculate') === 'true';

    let list = [];

    if (recalculate && db.ledgerTransactions && db.ledgerTransactions.length > 0) {
      // Dynamic aggregation implementing exact Sheet 3 SUMIFS formulas over Sheet 1
      const driverMap = new Map();

      // Collect known drivers from sheet 3 rows as base
      (db.driverWalletBalances || []).forEach((d) => {
        driverMap.set(d.nama_driver, {
          no: d.no,
          nama_driver: d.nama_driver,
          moda_transportasi: d.moda_transportasi,
          total_topup: 0,
          potongan_cicilan: 0,
          potongan_order_cash: 0,
          komisi_penghasilan: 0,
          saldo_akhir_wallet: 0,
        });
      });

      // Apply Excel formulas:
      // Col D: SUMIFS(Harga Dasar, Driver, Layanan contains "*Top Up*")
      // Col E: SUMIFS(Harga Dasar, Driver, Layanan contains "*Cicilan*")
      // Col F: SUMIFS(Total Bayar Pembeli, Driver, Metode Bayar == "Cash")
      // Col G: SUMIFS(Hak Penjual Net, Driver, Layanan NOT ("Top Up", "Cicilan", "DP"))
      // Col H: D - E - F + G
      db.ledgerTransactions.forEach((tx) => {
        const driverName = tx.penjualMerchantDriver;
        if (!driverName || !driverMap.has(driverName)) return;

        const entry = driverMap.get(driverName);
        const layanan = (tx.layananProduk || '').toLowerCase();
        const metode = (tx.metodeBayar || '').toLowerCase();
        const hargaDasar = Number(tx.hargaDasar || 0);
        const totalBayar = Number(tx.totalBayarPembeli || 0);
        const hakNet = Number(tx.hakPenjualDriverNet || 0);

        if (layanan.includes('top up')) {
          entry.total_topup += hargaDasar;
        }

        if (layanan.includes('cicilan')) {
          entry.potongan_cicilan += hargaDasar;
        }

        if (metode === 'cash') {
          entry.potongan_order_cash += totalBayar;
        }

        const isExemptFromIncome =
          layanan.includes('top up') || layanan.includes('cicilan') || layanan.includes('dp');
        if (!isExemptFromIncome) {
          entry.komisi_penghasilan += hakNet;
        }
      });

      // Final balance formula: D - E - F + G
      driverMap.forEach((entry) => {
        entry.saldo_akhir_wallet =
          entry.total_topup -
          entry.potongan_cicilan -
          entry.potongan_order_cash +
          entry.komisi_penghasilan;
      });

      list = Array.from(driverMap.values());
    } else {
      list = [...(db.driverWalletBalances || [])];
    }

    // Filters
    if (q) {
      list = list.filter(
        (item) =>
          (item.nama_driver && item.nama_driver.toLowerCase().includes(q)) ||
          (item.moda_transportasi && item.moda_transportasi.toLowerCase().includes(q))
      );
    }

    if (moda && moda !== 'SEMUA') {
      list = list.filter(
        (item) => item.moda_transportasi && item.moda_transportasi.toUpperCase() === moda
      );
    }

    if (status) {
      if (status === 'minus') {
        list = list.filter((item) => (item.saldo_akhir_wallet || 0) < 0);
      } else if (status === 'below_limit') {
        list = list.filter(
          (item) => (item.saldo_akhir_wallet || 0) >= 0 && (item.saldo_akhir_wallet || 0) < 10000
        );
      } else if (status === 'ready') {
        list = list.filter((item) => (item.saldo_akhir_wallet || 0) >= 10000);
      }
    }

    const calculatedSummary = {
      totalDriver: list.length,
      totalTopUp: list.reduce((s, i) => s + (i.total_topup || 0), 0),
      potonganCicilan: list.reduce((s, i) => s + (i.potongan_cicilan || 0), 0),
      potonganOrderCash: list.reduce((s, i) => s + (i.potongan_order_cash || 0), 0),
      komisiPenghasilan: list.reduce((s, i) => s + (i.komisi_penghasilan || 0), 0),
      saldoAkhirWallet: list.reduce((s, i) => s + (i.saldo_akhir_wallet || 0), 0),
      driverMinusCount: list.filter((i) => (i.saldo_akhir_wallet || 0) < 0).length,
      driverBelowLimitCount: list.filter(
        (i) => (i.saldo_akhir_wallet || 0) >= 0 && (i.saldo_akhir_wallet || 0) < 10000
      ).length,
      driverReadyCount: list.filter((i) => (i.saldo_akhir_wallet || 0) >= 10000).length,
    };

    return NextResponse.json({
      success: true,
      message: 'Master Saldo Wallet Driver 8 Kolom (Sheet 3) berhasil diambil.',
      sheet: '3. Saldo Wallet Driver',
      subtitle:
        'Mekanisme Wallet Driver: Top-Up Saldo, Potongan Cicilan Atribut (Rp 5.000/Hari), dan Potongan Order Cash Pembeli',
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
    const { driverName, amount, type = 'TOPUP', note = '' } = body;

    if (!driverName || !amount) {
      return NextResponse.json(
        { success: false, message: 'driverName dan amount wajib diisi.' },
        { status: 400 }
      );
    }

    const numAmount = Number(amount);
    if (type === 'TOPUP' && numAmount < 50000) {
      return NextResponse.json(
        { success: false, message: 'Batas minimal top-up saldo driver adalah Rp 50.000.' },
        { status: 400 }
      );
    }

    const driverList = db.driverWalletBalances || [];
    const targetDriver = driverList.find(
      (d) => d.nama_driver.toLowerCase() === driverName.toLowerCase()
    );

    if (!targetDriver) {
      return NextResponse.json(
        { success: false, message: `Driver dengan nama "${driverName}" tidak ditemukan.` },
        { status: 404 }
      );
    }

    if (type === 'TOPUP') {
      targetDriver.total_topup += numAmount;
      targetDriver.saldo_akhir_wallet += numAmount;
    } else if (type === 'CICILAN') {
      targetDriver.potongan_cicilan += numAmount;
      targetDriver.saldo_akhir_wallet -= numAmount;
    } else if (type === 'CASH_DEDUCTION') {
      targetDriver.potongan_order_cash += numAmount;
      targetDriver.saldo_akhir_wallet -= numAmount;
    }

    return NextResponse.json({
      success: true,
      message: `Transaksi wallet driver (${type}) berhasil diproses.`,
      driver: targetDriver,
    });
  } catch (error) {
    return NextResponse.json({ success: false, error: error.message }, { status: 500 });
  }
}

