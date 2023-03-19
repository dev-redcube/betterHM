import 'package:isar/isar.dart';

class Location {
  /// Readable Adress
  final String? address;

  final float? latitude;
  final float? longitude;

  Location(this.address, this.latitude, this.longitude);
}
