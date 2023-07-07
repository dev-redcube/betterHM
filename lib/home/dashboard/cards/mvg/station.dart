class Station {
  final String id;
  final String name;

  Station({
    required this.id,
    required this.name,
  });

  Map<String, String> toJson() => {
        "id": id,
        "name": name,
      };

  Station.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
