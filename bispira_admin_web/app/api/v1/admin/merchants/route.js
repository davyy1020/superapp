import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const branchId = searchParams.get('branchId');
    const kabupaten = searchParams.get('kabupaten');

    let list = db.merchants;

    if (branchId && branchId !== 'BRN-HQ') {
      list = list.filter((m) => m.branchId === branchId);
    }

    if (kabupaten) {
      list = list.filter((m) => m.kabupaten.toLowerCase().includes(kabupaten.toLowerCase()));
    }

    return successResponse(
      {
        total: list.length,
        items: list,
      },
      'Master Data Merchant & Katalog Berhasil Diambil'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}

export async function POST(request) {
  try {
    const body = await request.json();
    const {
      storeName,
      ownerName,
      category = 'Food & Fresh Sembako',
      kabupaten = 'Jakarta Selatan',
      branchId = 'BRN-001',
      basePriceAvg = 20000,
      markupPercent = 10,
    } = body;

    if (!storeName || !ownerName) {
      return errorResponse('Nama Toko dan Nama Pemilik wajib diisi', 400);
    }

    const newMerchant = {
      id: `MCH-00${db.merchants.length + 1}`,
      storeName,
      ownerName,
      category,
      kabupaten,
      branchId,
      basePriceAvg: Number(basePriceAvg), // Rerata harga dasar per produk item
      markupPercent: Number(markupPercent),
      subscriptionStatus: 'LUNAS BULANAN',
      accumulatedSales: 0,
      walletBalance: 0,
      createdAt: new Date().toISOString(),
    };

    db.merchants.push(newMerchant);

    return successResponse(
      newMerchant,
      `Merchant #${newMerchant.id} (${newMerchant.storeName}) Berhasil Didaftarkan!`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}

export async function PUT(request) {
  try {
    const body = await request.json();
    const { id, storeName, ownerName, category, kabupaten, basePriceAvg, markupPercent } = body;

    const merchant = db.merchants.find((m) => m.id === id);
    if (!merchant) {
      return errorResponse(`Merchant #${id} tidak ditemukan`, 404);
    }

    if (storeName) merchant.storeName = storeName;
    if (ownerName) merchant.ownerName = ownerName;
    if (category) merchant.category = category;
    if (kabupaten) merchant.kabupaten = kabupaten;
    if (basePriceAvg !== undefined) merchant.basePriceAvg = Number(basePriceAvg);
    if (markupPercent !== undefined) merchant.markupPercent = Number(markupPercent);

    return successResponse(merchant, `Data Merchant #${id} Berhasil Diperbarui`);
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
