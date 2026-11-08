import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

// Service fare matrices per agreement (Sheet 9: Pengaturan Tarif & Fees Revisi)
const FARE_RULES = {
  motor: {
    name: 'Bispira Ride (Motor)',
    baseFare: 8000,
    baseKm: 3.0,
    perKm: 2500,
    markupPercent: 0.10,
    driverSharePercent: 0.95,
    platformSharePercent: 0.05,
    appFee: 500,
    serviceFee: 500,
  },
  mobil: {
    name: 'Bispira Car (Mobil)',
    baseFare: 15000,
    baseKm: 3.0,
    perKm: 4000,
    markupPercent: 0.10,
    driverSharePercent: 0.90,
    platformSharePercent: 0.10,
    appFee: 500,
    serviceFee: 500,
  },
  kurir: {
    name: 'Bispira Send (Food & Kurir Instan)',
    baseFare: 10000,
    baseKm: 3.0,
    perKm: 3000,
    markupPercent: 0.10,
    driverSharePercent: 0.95,
    platformSharePercent: 0.05,
    appFee: 500,
    serviceFee: 500,
  },
  ambulance: {
    name: 'Bispira Ambulance Darurat',
    baseFare: 50000,
    baseKm: 4.0,
    perKm: 5000,
    extraJasa: 50000,
    markupPercent: 0.10,
    driverSharePercent: 0.925,
    platformSharePercent: 0.075,
    appFee: 500,
    serviceFee: 500,
  },
  kargo: {
    name: 'Bispira Kargo (Logistik Besar)',
    baseFare: 50000,
    baseKm: 4.0,
    perKm: 4000,
    extraJasa: 50000,
    markupPercent: 0.10,
    driverSharePercent: 0.925,
    platformSharePercent: 0.075,
    appFee: 500,
    serviceFee: 500,
  },
};

function calculateFare(serviceType, distanceKm) {
  const rule = FARE_RULES[serviceType] || FARE_RULES.motor;
  
  let baseTripFare = rule.baseFare;
  if (distanceKm > rule.baseKm) {
    const extraKm = distanceKm - rule.baseKm;
    baseTripFare += Math.round(extraKm * rule.perKm);
  }

  const extraJasa = rule.extraJasa || 0;
  const markupAmount = Math.round(baseTripFare * rule.markupPercent);
  
  // Driver net earning
  const driverShare = Math.round(baseTripFare * rule.driverSharePercent) + Math.round(extraJasa * 0.99);
  const platformFee = Math.round(baseTripFare * rule.platformSharePercent) + Math.round(extraJasa * 0.01) + markupAmount;
  
  // Tax PPh 0.5% based on PMK 37/2025
  const taxPph = Math.round(baseTripFare * 0.005);
  
  const appFee = rule.appFee;
  const serviceFee = rule.serviceFee;
  const grandTotal = baseTripFare + extraJasa + markupAmount + appFee + serviceFee;

  return {
    serviceName: rule.name,
    distanceKm: parseFloat(distanceKm.toFixed(2)),
    tripFare: baseTripFare,
    extraJasa,
    markupAmount,
    driverShare,
    platformFee,
    taxPph,
    appFee,
    serviceFee,
    grandTotal,
  };
}

async function fetchOsrmRoute(originLat, originLng, destLat, destLng) {
  const baseUrl = process.env.OSRM_SERVER_URL || 'https://router.project-osrm.org';
  const osrmUrl = `${baseUrl}/route/v1/driving/${originLng},${originLat};${destLng},${destLat}?overview=full&geometries=geojson&steps=true`;
  
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 6000);

    const res = await fetch(osrmUrl, {
      signal: controller.signal,
      headers: {
        'User-Agent': 'Bispira-Routing-Core/1.0',
        'Accept': 'application/json',
      },
    });
    clearTimeout(timeoutId);

    if (res.ok) {
      const data = await res.json();
      if (data.code === 'Ok' && data.routes && data.routes.length > 0) {
        const primary = data.routes[0];
        const distKm = primary.distance / 1000.0;
        const durMin = Math.ceil(primary.duration / 60.0);
        
        // GeoJSON coordinates are [lng, lat]. Transform into [{lat, lng}, ...] and [[lat, lng], ...]
        const coordinates = primary.geometry.coordinates.map(([lng, lat]) => ({
          lat,
          lng,
        }));

        const polylinePoints = primary.geometry.coordinates.map(([lng, lat]) => [lat, lng]);

        const steps = (primary.legs[0]?.steps || []).map(s => ({
          instruction: s.maneuver?.type + (s.name ? ` ke ${s.name}` : ''),
          name: s.name || 'Jalan',
          distance: Math.round(s.distance),
          duration: Math.round(s.duration),
        }));

        return {
          source: 'OSRM_ONLINE_ENGINE',
          distanceKm: distKm,
          durationMinutes: durMin,
          coordinates,
          polylinePoints,
          steps,
        };
      }
    }
  } catch (err) {
    console.warn('[OSRM-ONLINE-WARN] Falling back to intelligent routing generator:', err.message);
  }

  // Fallback intelligent road interpolation
  return generateInterpolatedRoad(originLat, originLng, destLat, destLng);
}

function generateInterpolatedRoad(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth radius in km
  const dLat = (lat2 - lat1) * (Math.PI / 180);
  const dLon = (lon2 - lon1) * (Math.PI / 180);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * (Math.PI / 180)) *
      Math.cos(lat2 * (Math.PI / 180)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const straightDist = R * c;
  const roadDist = Math.max(1.2, parseFloat((straightDist * 1.35).toFixed(2)));
  const durMin = Math.max(4, Math.round(roadDist * 2.8));

  // Generate 8 interpolated road curve points
  const points = [];
  const polylinePoints = [];
  const stepsCount = 8;
  for (let i = 0; i <= stepsCount; i++) {
    const fraction = i / stepsCount;
    // Add slight curve offset to simulate road grid
    const curveOffset = Math.sin(fraction * Math.PI) * 0.002;
    const pLat = lat1 + (lat2 - lat1) * fraction + curveOffset;
    const pLng = lon1 + (lon2 - lon1) * fraction + curveOffset * 0.8;
    points.push({ lat: pLat, lng: pLng });
    polylinePoints.push([pLat, pLng]);
  }

  return {
    source: 'OSRM_FALLBACK_ENGINE',
    distanceKm: roadDist,
    durationMinutes: durMin,
    coordinates: points,
    polylinePoints,
    steps: [
      { instruction: 'Mulai dari titik penjemputan', distance: Math.round(roadDist * 300), duration: 180 },
      { instruction: 'Lurus mengikuti jalur utama', distance: Math.round(roadDist * 400), duration: 240 },
      { instruction: 'Tiba di tujuan', distance: Math.round(roadDist * 300), duration: 180 },
    ],
  };
}

export async function POST(request) {
  try {
    let body;
    const contentType = request.headers.get('content-type') || '';
    if (contentType.includes('application/json')) {
      try {
        body = await request.json();
      } catch {
        const raw = await request.text();
        body = JSON.parse(raw);
      }
    } else {
      const raw = await request.text();
      body = JSON.parse(raw);
    }

    const originLat = parseFloat(body.originLat !== undefined ? body.originLat : body.origin?.lat);
    const originLng = parseFloat(body.originLng !== undefined ? body.originLng : body.origin?.lng);
    const destLat = parseFloat(body.destLat !== undefined ? body.destLat : body.dest?.lat);
    const destLng = parseFloat(body.destLng !== undefined ? body.destLng : body.dest?.lng);
    const serviceType = (body.serviceType || 'motor').toLowerCase();

    if (isNaN(originLat) || isNaN(originLng) || isNaN(destLat) || isNaN(destLng)) {
      return errorResponse('Koordinat origin (lat, lng) dan destination (lat, lng) wajib valid.', 400);
    }

    const routeData = await fetchOsrmRoute(originLat, originLng, destLat, destLng);
    const fare = calculateFare(serviceType, routeData.distanceKm);

    return successResponse({
      route: routeData,
      fare,
      query: {
        origin: { lat: originLat, lng: originLng },
        destination: { lat: destLat, lng: destLng },
        serviceType,
      },
    }, 'Rute OSRM dan estimasi tarif berhasil dihitung');
  } catch (err) {
    return errorResponse(`Gagal memproses rute OSRM: ${err.message}`, 500);
  }
}

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const originLat = parseFloat(searchParams.get('originLat'));
    const originLng = parseFloat(searchParams.get('originLng'));
    const destLat = parseFloat(searchParams.get('destLat'));
    const destLng = parseFloat(searchParams.get('destLng'));
    const serviceType = (searchParams.get('serviceType') || 'motor').toLowerCase();

    if (isNaN(originLat) || isNaN(originLng) || isNaN(destLat) || isNaN(destLng)) {
      return errorResponse('Parameter originLat, originLng, destLat, destLng diperlukan.', 400);
    }

    const routeData = await fetchOsrmRoute(originLat, originLng, destLat, destLng);
    const fare = calculateFare(serviceType, routeData.distanceKm);

    return successResponse({
      route: routeData,
      fare,
    }, 'Rute OSRM berhasil didapatkan');
  } catch (err) {
    return errorResponse(`Gagal mendapatkan rute OSRM: ${err.message}`, 500);
  }
}
