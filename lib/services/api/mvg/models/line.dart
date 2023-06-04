class Line {
  final String id;
  final String number;
  final String imagePath;
  final String direction;
  final TransportType type;

  Line({
    required this.number,
    required this.imagePath,
    required this.direction,
    required this.id,
    required this.type,
  });
}

enum TransportType {
  bus,
  tram,
  uBahn,
  sBahn,
}
