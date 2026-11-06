import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET() {
  try {
    return NextResponse.json({
      status: 'SUCCESS',
      success: true,
      message: 'Katalog Produk Ekosistem Front End & Back End (Sheet 10 & 11) berhasil diambil.',
      sheet: '10.PRODUK PENJUAL BACK END & 11. PEMBELI FRONT END',
      data: {
        ...db.catalogEcosystem,
        sheet10_backend: db.productsBackend,
        sheet11_frontend: db.pembeliFrontend,
      },
    });
  } catch (error) {
    return NextResponse.json({ status: 'ERROR', success: false, error: error.message }, { status: 500 });
  }
}

