import 'package:geolocator/geolocator.dart';

class SessionLocation {
  const SessionLocation({
    required this.latitude,
    required this.longitude,
    required this.isVerified,
    this.fallbackCity,
  });

  final double? latitude;
  final double? longitude;
  final bool isVerified;
  final String? fallbackCity;
}

class LocationService {
  Future<SessionLocation> captureSessionLocation({String? fallbackCity}) async {
    final permission = await Geolocator.checkPermission();
    var granted = permission == LocationPermission.always || permission == LocationPermission.whileInUse;

    if (!granted) {
      final requested = await Geolocator.requestPermission();
      granted = requested == LocationPermission.always || requested == LocationPermission.whileInUse;
    }

    if (!granted) {
      return SessionLocation(latitude: null, longitude: null, isVerified: false, fallbackCity: fallbackCity);
    }

    final pos = await Geolocator.getCurrentPosition();
    return SessionLocation(latitude: pos.latitude, longitude: pos.longitude, isVerified: true);
  }
}
