import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const sheetName = (searchParams.get('sheet') || '').toLowerCase().trim();
    const q = (searchParams.get('q') || '').toLowerCase().trim();

    const master = db.formulirPenjualMaster || {};
    const sheetKeys = Object.keys(master);

    if (sheetName) {
      const matchedKey = sheetKeys.find((k) => k.toLowerCase() === sheetName || k.toLowerCase().includes(sheetName));
      if (matchedKey) {
        return NextResponse.json({
          status: 'SUCCESS',
          success: true,
          sheet: matchedKey,
          data: master[matchedKey],
        });
      }
    }

    let summaryList = sheetKeys.map((k) => {
      const item = master[k];
      return {
        sheet_name: k,
        total_rows: item.total_rows,
        header: item.rows?.[0]?.[0] || k,
        subHeader: item.rows?.[1]?.[0] || '',
      };
    });

    if (q) {
      summaryList = summaryList.filter(
        (s) => s.sheet_name.toLowerCase().includes(q) || s.header.toLowerCase().includes(q)
      );
    }

    return NextResponse.json({
      status: 'SUCCESS',
      success: true,
      message: 'Katalog 22 Formulir Pendaftaran Penjual & Spesifikasi Input Produk berhasil diambil.',
      workbook: 'FORMULIR PENJUAL.xlsx',
      totalSheets: sheetKeys.length,
      data: {
        sheets: summaryList,
        fullCatalog: master,
      },
    });
  } catch (error) {
    return NextResponse.json({ status: 'ERROR', success: false, error: error.message }, { status: 500 });
  }
}

