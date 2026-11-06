import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET() {
  try {
    return NextResponse.json({
      status: 'SUCCESS',
      success: true,
      message: 'Pengaturan Tarif & Fees Revisi (Sheet 9) berhasil diambil.',
      sheet: '9. Pengaturan Tarif & Fees',
      data: db.tariffAndFeesSettings,
    });
  } catch (error) {
    return NextResponse.json({ status: 'ERROR', success: false, error: error.message }, { status: 500 });
  }
}

