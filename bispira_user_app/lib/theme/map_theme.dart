import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BispiraMapTheme {
  // Grab / Gojek-grade crisp vector-raster tiles (CartoDB Voyager Retina)
  static TileLayer get cartoVoyagerTileLayer => TileLayer(
        urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
        subdomains: const ['a', 'b', 'c', 'd'],
        userAgentPackageName: 'com.bispira.userapp',
        retinaMode: true,
      );

  // Dual-Layer Polyline (Outer Dark Casing 8px + Inner Neon Navigation Core 4.8px)
  static List<Polyline> buildGrabGojekPolyline({
    required List<LatLng> points,
    Color coreColor = const Color(0xFF00C853), // Gojek neon emerald / Bispira brand
  }) {
    if (points.isEmpty) return [];
    return [
      // 1. Outer Road Casing (Highway 3D border)
      Polyline(
        points: points,
        strokeWidth: 8.0,
        color: const Color(0xFF0F172A),
      ),
      // 2. Inner Neon Navigation Core
      Polyline(
        points: points,
        strokeWidth: 4.8,
        color: coreColor,
      ),
    ];
  }
}

