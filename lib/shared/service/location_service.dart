import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationPermission? _permission;

  LocationService() {
    setPermission();
  }

  Future<void> setPermission() async {
    _permission = await Geolocator.checkPermission();
  }

  LocationPermission? get permission => _permission;

  Future<Position> determinePosition() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are not enabled");
    }
    _permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Location permissions are permanently denied");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future<Position?> getLastKnown() async {
    return await Geolocator.getLastKnownPosition();
  }
}
