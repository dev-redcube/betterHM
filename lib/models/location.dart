class Location {
  /// Readable Adress
  final String? address;

  final double? latitude;
  final double? longitude;

  Location(
    this.address, {
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        json["address"] as String?,
        latitude: json["latitude"] as double?,
        longitude: json["longitude"] as double?,
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}
