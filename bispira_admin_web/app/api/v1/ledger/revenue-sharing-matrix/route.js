import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET() {
  try {
    return NextResponse.json({
      status: 'SUCCESS',
      success: true,
      message: 'Pedoman Pendapatan Superadmin Per Transaksi & Peta Bagi Hasil Net Profit berhasil diambil.',
      sheet: 'PENDAPATAN SUPERADMIN&BAGIHASIL',
      data: db.revenueSharingMatrix,
    });
  } catch (error) {
    return NextResponse.json({ status: 'ERROR', success: false, error: error.message }, { status: 500 });
  }
}

