import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';

class LocationServicePermissionException implements Exception {
  final LocationPermission? permission;

  LocationServicePermissionException(this.permission);

  @override
  String toString() => "LocationPermissionException(permission: $permission)";
}

/// Use getIt<LocationService>()
class LocationService {
  LocationPermission? _permission;

  LocationService() {
    if (checkPlatform()) setPermission();
  }

  bool checkPlatform() => Platform.isAndroid || Platform.isIOS;

  Future<void> setPermission() async {
    _permission = await Geolocator.checkPermission();
  }

  LocationPermission? get permission => _permission;

  Future<bool> _checkRequirements() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    _permission = await Geolocator.checkPermission();

    switch (_permission) {
      case LocationPermission.denied:
        _permission = await Geolocator.requestPermission();
        if ([LocationPermission.denied, LocationPermission.deniedForever]
            .contains(_permission)) {
          return false;
        }
        break;
      case LocationPermission.deniedForever:
        return false;
      default:
    }

    return true;
  }

  /// Get the current position
  /// Can throw: [LocationServicePermissionException], [LocationServiceDisabledException], [TimeoutException]
  Future<Position> determinePosition({
    LocationAccuracy? desiredAccuracy,
  }) async {
    assert(checkPlatform());

    desiredAccuracy ??= LocationAccuracy.best;
    final req = await _checkRequirements();
    if (req == false) {
      if (_permission
          case LocationPermission.denied ||
              LocationPermission.deniedForever ||
              LocationPermission.unableToDetermine) {
        throw LocationServicePermissionException(_permission);
      }
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: desiredAccuracy);
  }

  Future<Position?> getLastKnown() async {
    assert(checkPlatform());

    return await Geolocator.getLastKnownPosition();
  }

  Future<Position> getLastKnownOrNew(LocationAccuracy? desiredAccuracy) async {
    assert(checkPlatform());

    return await getLastKnown() ??
        await determinePosition(desiredAccuracy: desiredAccuracy);
  }
}
