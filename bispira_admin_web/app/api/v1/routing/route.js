import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

// Service fare matrices per agreement
const FARE_RULES = {
  motor: {
    name: 'Bispira Ride (Motor)',
    baseFare: 10000,
    baseKm: 3.0,
    perKm: 2500,
    driverSharePercent: 0.95,
    platformSharePercent: 0.05,
    appFee: 2000,
    serviceFee: 1000,
  },
  mobil: {
    name: 'Bispira Car (Mobil)',
    baseFare: 18000,
    baseKm: 3.0,
    perKm: 4500,
    driverSharePercent: 0.95,
    platformSharePercent: 0.05,
    appFee: 2500,
    serviceFee: 1000,
  },
  kurir: {
    name: 'Bispira Send (Kurir Instan)',
    baseFare: 12000,
    baseKm: 3.0,
    perKm: 3000,
    driverSharePercent: 0.95,
    platformSharePercent: 0.05,
    appFee: 2000,
    serviceFee: 1000,
  },
  kargo: {
    name: 'Bispira Kargo (Logistik Besar)',
    baseFare: 60000,
    baseKm: 5.0,
    perKm: 8000,
    driverSharePercent: 0.95,
    platformSharePercent: 0.05,
    appFee: 5000,
    serviceFee: 2000,
  },
  ambulance: {
    name: 'Bispira Ambulance Darurat',
    baseFare: 120000,
    baseKm: 10.0,
    perKm: 6000,
    driverSharePercent: 0.95,
    platformSharePercent: 0.05,
    appFee: 0,
    serviceFee: 0,
  },
};

function calculateFare(serviceType, distanceKm) {
  const rule = FARE_RULES[serviceType] || FARE_RULES.motor;
  
  let tripFare = rule.baseFare;
  if (distanceKm > rule.baseKm) {
    const extraKm = distanceKm - rule.baseKm;
    tripFare += Math.round(extraKm * rule.perKm);
  }

  // 95% driver net earning, 5% platform fee
  const driverShare = Math.round(tripFare * rule.driverSharePercent);
  const platformFee = tripFare - driverShare;
  
  // Tax PPh 0.5% based on PMK 37/2025
  const taxPph = Math.round(tripFare * 0.005);
  
  const appFee = rule.appFee;
  const serviceFee = rule.serviceFee;
  const grandTotal = tripFare + appFee + serviceFee;

  return {
    serviceName: rule.name,
    distanceKm: parseFloat(distanceKm.toFixed(2)),
    tripFare,
    driverShare,
    platformFee,
    taxPph,
    appFee,
    serviceFee,
    grandTotal,
  };
}

async function fetchOsrmRoute(originLat, originLng, destLat, destLng) {
  const osrmUrl = `https://router.project-osrm.org/route/v1/driving/${originLng},${originLat};${destLng},${destLat}?overview=full&geometries=geojson&steps=true`;
  
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
