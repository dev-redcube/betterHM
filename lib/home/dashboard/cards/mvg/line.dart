class Line {
  final String id;
  final String number;
  final String direction;
  final String? symbol;
  final LineType? type;

  const Line({
    required this.id,
    required this.number,
    required this.direction,
    this.symbol,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        "stateless": id,
        "number": number,
        "direction": direction,
        "symbol": symbol,
        "name": type?.toString(),
      };

  Line.fromJson(Map<String, dynamic> json)
      : id = json["stateless"],
        number = json["number"],
        direction = json["direction"],
        symbol = json["symbol"],
        type = json["name"] != null ? LineType.fromString(json["name"]) : null;
}

enum LineType {
  bus,
  tram;

  @override
  toString() => name;

  static LineType fromString(String string) =>
      values.byName(string.toLowerCase());
}
