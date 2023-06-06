class Line {
  final String id;
  final String number;
  final String direction;
  final String? symbol;
  final String? name;

  Line({
    required this.id,
    required this.number,
    required this.direction,
    this.symbol,
    this.name,
  });

  Line.fromJson(Map<String, dynamic> json)
      : id = json["stateless"],
        number = json["number"],
        direction = json["direction"],
        symbol = json["symbol"],
        name = json["name"];
}
