import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final double latitude;
  final double longitude;
  final String? address;

  Location(this.latitude, this.longitude, {this.address});

  double distanceToLocation(
    Location other, [
    LengthUnit unit = LengthUnit.Meter,
  ]) {
    const distance = Distance();
    return distance.as(unit, asLatLng, other.asLatLng);
  }

  double distanceTo(
    double lat,
    double lon, [
    LengthUnit unit = LengthUnit.Meter,
  ]) {
    const distance = Distance();
    return distance.as(unit, asLatLng, LatLng(lat, lon));
  }

  LatLng get asLatLng => LatLng(latitude, longitude);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() =>
      "Location(latitude: $latitude, longitude: $longitude, address: $address)";
}
