import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsLauncherHelper {
  /// Membuka aplikasi Google Maps langsung dengan rute navigasi ke titik koordinat tujuan
  static Future<void> openDirections({
    required double lat,
    required double lng,
    String? destinationLabel,
  }) async {
    final String urlString = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
    final Uri uri = Uri.parse(urlString);

    try {
      if (kIsWeb) {
        await launchUrl(uri, webOnlyWindowName: '_blank');
      } else {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (e) {
      debugPrint('Error launching Google Maps: $e');
    }
  }
}
