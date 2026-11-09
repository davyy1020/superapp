import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

const DRIVER_NAMES = [
  { name: 'Ahmad Fauzi', plate: 'H 4521 SXZ', rating: 4.95, vehicle: 'Honda Vario 160 (Hitam)' },
  { name: 'Bambang Hermanto', plate: 'H 1928 AB', rating: 4.88, vehicle: 'Yamaha NMAX (Silver)' },
  { name: 'Rian Priangan', plate: 'H 8832 CTY', rating: 4.92, vehicle: 'Honda Beat Street (Abu-abu)' },
  { name: 'Dedy Prasetyo', plate: 'H 3341 TYU', rating: 4.90, vehicle: 'Honda PCX 160 (Putih)' },
  { name: 'Eko Wahyudi', plate: 'H 6729 BZ', rating: 4.86, vehicle: 'Yamaha Aerox (Biru)' },
  { name: 'Suryanto', plate: 'H 2901 MP', rating: 4.97, vehicle: 'Honda Scoopy (Merah)' },
];

const CAR_DRIVER_NAMES = [
  { name: 'Joko Susilo', plate: 'H 1234 CD', rating: 4.93, vehicle: 'Toyota Avanza (Silver)' },
  { name: 'Hendro Gunawan', plate: 'H 8765 XY', rating: 4.89, vehicle: 'Daihatsu Xenia (Putih)' },
  { name: 'Agus Pratama', plate: 'H 5521 KLM', rating: 4.96, vehicle: 'Toyota Calya (Hitam)' },
];

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const originLat = parseFloat(searchParams.get('lat') || searchParams.get('originLat') || '-6.9536');
    const originLng = parseFloat(searchParams.get('lng') || searchParams.get('originLng') || '110.4682');
    const vehicleType = (searchParams.get('type') || 'motor').toLowerCase();

    const isCar = vehicleType === 'mobil' || vehicleType === 'car';
    const driverPool = isCar ? CAR_DRIVER_NAMES : DRIVER_NAMES;

    // Distribute 4-6 nearby drivers in a realistic road grid radius (~300m - 1200m)
    const offsets = [
      { dLat: 0.0028, dLng: 0.0031, bearing: 45, distMeters: 450, etaMin: 2 },
      { dLat: -0.0035, dLng: 0.0022, bearing: 135, distMeters: 620, etaMin: 3 },
      { dLat: 0.0019, dLng: -0.0041, bearing: 290, distMeters: 710, etaMin: 3 },
      { dLat: -0.0042, dLng: -0.0033, bearing: 220, distMeters: 890, etaMin: 4 },
      { dLat: 0.0051, dLng: -0.0015, bearing: 340, distMeters: 980, etaMin: 4 },
      { dLat: -0.0018, dLng: 0.0054, bearing: 85, distMeters: 820, etaMin: 3 },
    ];

    const nearbyDrivers = offsets.slice(0, driverPool.length).map((offset, idx) => {
      const driverInfo = driverPool[idx];
      return {
        id: `drv_live_${idx + 1}`,
        name: driverInfo.name,
        licensePlate: driverInfo.plate,
        vehicleModel: driverInfo.vehicle,
        vehicleType: isCar ? 'CAR' : 'MOTORCYCLE',
        rating: driverInfo.rating,
        lat: parseFloat((originLat + offset.dLat).toFixed(6)),
        lng: parseFloat((originLng + offset.dLng).toFixed(6)),
        bearing: offset.bearing,
        distanceMeters: offset.distMeters,
        etaMinutes: offset.etaMin,
        etaLabel: `${offset.etaMin} Menit`,
        isAvailable: true,
      };
    });

    return successResponse(
      {
        pickup: { lat: originLat, lng: originLng },
        vehicleType: isCar ? 'CAR' : 'MOTORCYCLE',
        totalNearby: nearbyDrivers.length,
        closestEtaMinutes: nearbyDrivers[0].etaMinutes,
        drivers: nearbyDrivers,
      },
      'Data armada mitra sekitar titik jemput berhasil didapatkan'
    );
  } catch (err) {
    return errorResponse(err.message, 500);
  }
}

