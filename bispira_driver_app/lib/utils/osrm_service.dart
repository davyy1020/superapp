import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsrmRoutingService {
  static const String backendUrl = 'http://localhost:3000/api/v1/routing';

  static Future<Map<String, dynamic>> fetchRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String serviceType = 'motor',
  }) async {
    // 1. Try Next.js Backend OSRM Endpoint
    try {
      final uri = Uri.parse(backendUrl).replace(queryParameters: {
        'originLat': originLat.toString(),
        'originLng': originLng.toString(),
        'destLat': destLat.toString(),
        'destLng': destLng.toString(),
        'serviceType': serviceType,
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'SUCCESS' && resData['data'] != null) {
          final data = resData['data'];
          final route = data['route'] as Map<String, dynamic>;
          final rawPolyline = route['polylinePoints'] as List;
          
          final List<LatLng> points = rawPolyline.map((pt) {
            return LatLng((pt[0] as num).toDouble(), (pt[1] as num).toDouble());
          }).toList();

          return {
            'source': route['source'] ?? 'OSRM_BACKEND',
            'distanceKm': (route['distanceKm'] as num).toDouble(),
            'durationMinutes': (route['durationMinutes'] as num).toInt(),
            'points': points,
            'steps': route['steps'] ?? [],
            'fare': data['fare'],
          };
        }
      }
    } catch (_) {}

    // 2. Direct OSRM Fallback
    try {
      final osrmUri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/$originLng,$originLat;$destLng,$destLat?overview=full&geometries=geojson&steps=true',
      );
      final osrmRes = await http.get(osrmUri).timeout(const Duration(seconds: 5));
      if (osrmRes.statusCode == 200) {
        final data = jsonDecode(osrmRes.body);
        if (data['code'] == 'Ok' && (data['routes'] as List).isNotEmpty) {
          final primary = data['routes'][0];
          final double distKm = (primary['distance'] as num) / 1000.0;
          final int durMin = ((primary['duration'] as num) / 60.0).ceil();
          final List coords = primary['geometry']['coordinates'] as List;

          final List<LatLng> points = coords.map((c) {
            return LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble());
          }).toList();

          return {
            'source': 'OSRM_DIRECT',
            'distanceKm': double.parse(distKm.toStringAsFixed(2)),
            'durationMinutes': durMin,
            'points': points,
            'steps': primary['legs'][0]['steps'] ?? [],
          };
        }
      }
    } catch (_) {}

    // 3. Fallback Interpolation
    return {
      'source': 'FALLBACK_GEO',
      'distanceKm': 8.5,
      'durationMinutes': 18,
      'points': [
        LatLng(originLat, originLng),
        LatLng((originLat + destLat) / 2 + 0.002, (originLng + destLng) / 2 + 0.002),
        LatLng(destLat, destLng),
      ],
      'steps': [],
    };
  }
}
