import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const q = (searchParams.get('q') || '').toLowerCase().trim();
    const scheme = (searchParams.get('scheme') || '').toLowerCase().trim();

    let rawList = [...(db.bagiHasilPusatDaerah || [])];
    let list = rawList.map((item) => ({
      no: item.no,
      wilayah_kab_kota: item.wilayah_kab_kota || item.wilayahKabKota,
      wilayahKabKota: item.wilayahKabKota || item.wilayah_kab_kota,
      provinsi: item.provinsi,
      status_skema_kerjasama: item.status_skema_kerjasama || item.statusSkemaKerjasama,
      statusSkemaKerjasama: item.statusSkemaKerjasama || item.status_skema_kerjasama,
      net_profit_superadmin: item.net_profit_superadmin !== undefined ? item.net_profit_superadmin : item.netProfitSuperadmin,
      netProfitSuperadmin: item.netProfitSuperadmin !== undefined ? item.netProfitSuperadmin : item.net_profit_superadmin,
      porsi_pusat: item.porsi_pusat !== undefined ? item.porsi_pusat : item.porsiPusat,
      porsiPusat: item.porsiPusat !== undefined ? item.porsiPusat : item.porsi_pusat,
      porsi_admin_daerah: item.porsi_admin_daerah !== undefined ? item.porsi_admin_daerah : item.porsiAdminDaerah,
      porsiAdminDaerah: item.porsiAdminDaerah !== undefined ? item.porsiAdminDaerah : item.porsi_admin_daerah,
      jadwal_pembayaran: item.jadwal_pembayaran || item.jadwalPembayaran || 'Tgl 1 Awal Bulan',
      jadwalPembayaran: item.jadwalPembayaran || item.jadwal_pembayaran || 'Tgl 1 Awal Bulan',
    }));

    if (q) {
      list = list.filter(
        (item) =>
          (item.wilayah_kab_kota && item.wilayah_kab_kota.toLowerCase().includes(q)) ||
          (item.provinsi && item.provinsi.toLowerCase().includes(q))
      );
    }

    if (scheme) {
      if (scheme === 'kerjasama' || scheme === '75:25') {
        list = list.filter((i) => (i.status_skema_kerjasama || '').includes('75%:25%'));
      } else if (scheme === 'tanpa' || scheme === '100:0') {
        list = list.filter((i) => (i.status_skema_kerjasama || '').includes('100%:0%'));
      } else if (scheme === 'event' || scheme === '20:80') {
        list = list.filter((i) => (i.status_skema_kerjasama || '').includes('20%:80%'));
      }
    }

    const calculatedSummary = {
      totalWilayah: list.length,
      totalNetProfitSuperadmin: list.reduce((s, i) => s + Number(i.net_profit_superadmin || 0), 0),
      totalPorsiPusat: list.reduce((s, i) => s + Number(i.porsi_pusat || 0), 0),
      totalPorsiAdminDaerah: list.reduce((s, i) => s + Number(i.porsi_admin_daerah || 0), 0),
      jadwalPembayaran: 'Tgl 1 Awal Bulan',
    };

    return NextResponse.json({
      status: 'SUCCESS',
      success: true,
      message: 'Skema Bagi Hasil Net Profit Superadmin Pusat dan Admin Daerah (Sheet 7) berhasil diambil.',
      sheet: '7. Bagi Hasil Pusat & Daerah',
      subtitle: 'Kerjasama (75%:25%) | Tanpa Kerjasama (100%:0%) | Event Mandiri Daerah (20%:80%) | Dibayarkan Setiap Tanggal 1 Awal Bulan',
      data: {
        profitSharing: list,
        totalSummary: calculatedSummary,
        count: list.length,
      },
    });
  } catch (error) {
    return NextResponse.json({ status: 'ERROR', success: false, error: error.message }, { status: 500 });
  }
}

