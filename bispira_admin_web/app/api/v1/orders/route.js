import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const status = searchParams.get('status');

    let orders = db.orders || [];
    if (status) {
      orders = orders.filter((o) => o.status === status);
    }

    return successResponse({
      total: orders.length,
      orders,
    });
  } catch (error) {
    return errorResponse('Gagal mengambil daftar order: ' + error.message, 500);
  }
}

export async function POST(request) {
  try {
    const body = await request.json();
    const {
      serviceType = 'ride_motor',
      serviceName = 'BISPIRA Ride (Motor) 🛵',
      serviceEmoji = '🛵',
      customerName = 'Davy (User Bispira)',
      customerPhone = '0812-9876-5432',
      pickupAddress = 'Jl. Kaligawe Raya No. 12, Genuk, Semarang',
      dropoffAddress = 'Jl. Prof. Soedarto (Undip), Tembalang, Semarang',
      pickupLat = -6.9622,
      pickupLng = 110.4682,
      dropoffLat = -7.0545,
      dropoffLng = 110.4358,
      distanceKm = 17.19,
      durationMin = 18,
      fare = {},
      paymentMethod = 'Transfer Bank (Kode Unik)',
      uniqueCode = 247,
    } = body;

    const orderId = `BSP-ORD-${Date.now().toString().slice(-6)}`;

    const newOrder = {
      id: orderId,
      serviceType,
      serviceName,
      serviceEmoji,
      customerName,
      customerPhone,
      pickupAddress,
      dropoffAddress,
      pickupLat: Number(pickupLat),
      pickupLng: Number(pickupLng),
      dropoffLat: Number(dropoffLat),
      dropoffLng: Number(dropoffLng),
      distanceKm: Number(distanceKm),
      durationMin: Number(durationMin),
      totalFareCustomer: Number(fare.grandTotal || 48478),
      netDriverEarning: Number(fare.driverShare || Math.round((fare.tripFare || 45478) * 0.95)),
      platformFee: Number(fare.platformFee || Math.round((fare.tripFare || 45478) * 0.05)),
      taxPph: Number(fare.taxPph || 227),
      appFee: Number(fare.appFee || 500),
      serviceFee: Number(fare.serviceFee || 500),
      uniqueCode: Number(uniqueCode),
      paymentMethod,
      paymentStatus: paymentMethod.toLowerCase().includes('tunai')
        ? 'CASH_ON_DELIVERY'
        : 'PENDING_MANUAL_VERIFICATION',
      status: 'LOOKING_FOR_DRIVER',
      createdAt: new Date().toISOString(),
    };

    if (!db.orders) db.orders = [];
    db.orders.unshift(newOrder);

    // Also record into 21-column Master Ledger (Sheet 1)
    const basePrice = Number(fare.tripFare || 25000);
    const markup10 = Math.round(basePrice * 0.10);
    const hargaResmi = basePrice + markup10;
    const biayaLayanan = 500;
    const biayaAplikasi = 500;
    const isCash = paymentMethod.toLowerCase().includes('tunai');
    const uCode = isCash ? 0 : Number(uniqueCode || 123);
    const totalBayar = hargaResmi + biayaLayanan + biayaAplikasi + uCode;
    const komisi = Math.round(basePrice * 0.05);
    const netDriver = basePrice - komisi;
    const pusatNet = markup10 + biayaLayanan + biayaAplikasi + komisi + uCode;

    const now = new Date();
    const ledgerTx = {
      no: (db.ledgerTransactions?.length || 0) + 1,
      tanggal: now.toISOString().slice(0, 10),
      jam: now.toTimeString().slice(0, 8),
      namaPembeli: customerName,
      layananProduk: serviceName,
      penjualMerchantDriver: 'Driver BISPIRA Terdekat',
      wilayahKabKota: 'Kota Semarang',
      provinsi: 'Jawa Tengah',
      bank: isCash ? 'Cash' : 'BCA',
      metodeBayar: isCash ? 'Cash' : 'Transfer Bank',
      hargaDasar: basePrice,
      markup10,
      hargaResmi,
      biayaLayanan,
      biayaAplikasi,
      biayaAngkut: 0,
      kodeUnikBank: uCode,
      totalBayarPembeli: totalBayar,
      komisiMarketplace: komisi,
      hakPenjualDriverNet: netDriver,
      pusatNetProfit: pusatNet,
    };

    if (!db.ledgerTransactions) db.ledgerTransactions = [];
    db.ledgerTransactions.unshift(ledgerTx);

    // If manual bank transfer or QRIS, add to pending payments for manual admin verification
    if (!paymentMethod.toLowerCase().includes('tunai')) {
      if (!db.pendingPayments) db.pendingPayments = [];
      db.pendingPayments.unshift({
        id: `pay_${orderId.toLowerCase()}`,
        userId: customerName,
        userName: customerName,
        serviceType: serviceName,
        nominalBase: newOrder.totalFareCustomer,
        uniqueCode: Number(uniqueCode),
        totalTransferRequired: newOrder.totalFareCustomer + Number(uniqueCode),
        bankDestination: 'BCA (8840-192-381 a.n PT BISPIRA DIGITAL NUSANTARA)',
        status: 'PENDING_VERIFICATION',
        orderId: newOrder.id,
        createdAt: new Date().toISOString(),
        expiresAt: new Date(Date.now() + 30 * 60 * 1000).toISOString(),
      });
    }

    return successResponse(newOrder, 'Order berhasil dibuat dan mencari driver terdekat!');
  } catch (error) {
    return errorResponse('Gagal membuat order: ' + error.message, 500);
  }
}
