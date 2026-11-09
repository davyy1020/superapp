import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

const POPULAR_LOCATIONS = [
  { name: 'Simpang Lima Semarang', address: 'Pusat Kota, Jl. Simpang Lima, Semarang', lat: -6.9903, lng: 110.4229, category: 'Landmark' },
  { name: 'Stasiun Semarang Tawang (Bank Jateng)', address: 'Jl. Taman Tawang No. 1, Tj. Mas, Semarang', lat: -6.9644, lng: 110.4281, category: 'Stasiun Kereta' },
  { name: 'Stasiun Poncol Semarang', address: 'Jl. Imam Bonjol, Purwosari, Semarang', lat: -6.9734, lng: 110.4147, category: 'Stasiun Kereta' },
  { name: 'Bandara Internasional Jenderal Ahmad Yani', address: 'Tambakharjo, Semarang Barat, Semarang', lat: -6.9744, lng: 110.3744, category: 'Bandara' },
  { name: 'RSUP Dr. Kariadi Semarang', address: 'Jl. Dr. Sutomo No. 16, Randusari, Semarang', lat: -6.9944, lng: 110.4082, category: 'Rumah Sakit' },
  { name: 'Universitas Diponegoro (Undip Tembalang)', address: 'Jl. Prof. Soedarto, Tembalang, Semarang', lat: -7.0505, lng: 110.4378, category: 'Kampus' },
  { name: 'Universitas Negeri Semarang (Unnes Sekaran)', address: 'Sekaran, Gunungpati, Semarang', lat: -7.0494, lng: 110.3854, category: 'Kampus' },
  { name: 'Kawasan Kota Lama Semarang', address: 'Jl. Letjen Suprapto, Tj. Mas, Semarang', lat: -6.9681, lng: 110.4277, category: 'Wisata' },
  { name: 'Masjid Agung Jawa Tengah (MAJT)', address: 'Jl. Gajah Raya, Sambirejo, Gayamsari, Semarang', lat: -6.9833, lng: 110.4455, category: 'Tempat Ibadah' },
  { name: 'Mall Ciputra Semarang', address: 'Simpang Lima No. 1, Pekunden, Semarang', lat: -6.9892, lng: 110.4242, category: 'Pusat Belanja' },
  { name: 'Pollux Mall Paragon Semarang', address: 'Jl. Pemuda No. 118, Sekayu, Semarang', lat: -6.9818, lng: 110.4144, category: 'Pusat Belanja' },
  { name: 'Kawasan Industri Genuk / Terboyo', address: 'Jl. Raya Kaligawe KM 5, Genuk, Semarang', lat: -6.9536, lng: 110.4682, category: 'Kawasan Industri' },
];

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const query = (searchParams.get('q') || '').trim().toLowerCase();

    if (!query) {
      return successResponse(POPULAR_LOCATIONS.slice(0, 6), 'Rekomendasi lokasi populer');
    }

    // 1. Filter local popular points of interest
    const localMatches = POPULAR_LOCATIONS.filter(
      loc => loc.name.toLowerCase().includes(query) || loc.address.toLowerCase().includes(query)
    );

    if (localMatches.length >= 3) {
      return successResponse(localMatches, 'Hasil pencarian lokasi lokal');
    }

    // 2. Fallback to OpenStreetMap Photon Geocoder for arbitrary addresses
    try {
      const photonUrl = `https://photon.komoot.io/api/?q=${encodeURIComponent(query)}&limit=5&lat=-6.99&lon=110.42`;
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 3500);

      const res = await fetch(photonUrl, { signal: controller.signal });
      clearTimeout(timeoutId);

      if (res.ok) {
        const data = await res.json();
        const photonResults = (data.features || []).map(f => {
          const props = f.properties || {};
          const [lng, lat] = f.geometry.coordinates;
          const addressParts = [props.street, props.district, props.city, props.state].filter(Boolean);
          return {
            name: props.name || props.street || query,
            address: addressParts.length > 0 ? addressParts.join(', ') : 'Semarang & Sekitarnya',
            lat: parseFloat(lat.toFixed(6)),
            lng: parseFloat(lng.toFixed(6)),
            category: props.osm_value || 'Lokasi',
          };
        });

        // Combine unique results
        const combined = [...localMatches, ...photonResults];
        return successResponse(combined.slice(0, 8), 'Hasil pencarian lokasi terintegrasi');
      }
    } catch (_) {}

    return successResponse(localMatches, 'Hasil pencarian lokasi');
  } catch (err) {
    return errorResponse(err.message, 500);
  }
}

