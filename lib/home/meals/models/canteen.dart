import 'package:better_hm/shared/models/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'canteen.g.dart';

@JsonSerializable()
class Canteens {
  @JsonKey(name: "data")
  final List<Canteen> canteens;

  Canteens({required this.canteens});

  factory Canteens.fromJson(Map<String, dynamic> json) =>
      _$CanteensFromJson(json);

  Map<String, dynamic> toJson() => _$CanteensToJson(this);
}

@JsonSerializable()
class Canteen {
  @JsonKey(name: "enum_name")
  final String enumName;

  final String name;

  @JsonKey(name: "canteen_id")
  final String canteenId;

  final Location location;
  final OpenHoursWeek? openHours;

  Canteen({
    required this.enumName,
    required this.name,
    required this.canteenId,
    required this.location,
    this.openHours,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) =>
      _$CanteenFromJson(json);

  Map<String, dynamic> toJson() => _$CanteenToJson(this);

  @override
  String toString() =>
      "Canteen(enumName: $enumName, name: $name, canteenId: $canteenId, location: $location)";
}

class OpenHoursWeek {
  final OpenHoursDay? mon;
  final OpenHoursDay? tue;
  final OpenHoursDay? wed;
  final OpenHoursDay? thu;
  final OpenHoursDay? fri;
  final OpenHoursDay? sat;
  final OpenHoursDay? sun;

  OpenHoursWeek({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
  });

  factory OpenHoursWeek.fromJson(Map<String, dynamic> json) {
    return OpenHoursWeek(
      mon: json.containsKey("mon") ? OpenHoursDay.fromJson(json["mon"]) : null,
      tue: json.containsKey("tue") ? OpenHoursDay.fromJson(json["tue"]) : null,
      wed: json.containsKey("wed") ? OpenHoursDay.fromJson(json["wed"]) : null,
      thu: json.containsKey("thu") ? OpenHoursDay.fromJson(json["thu"]) : null,
      fri: json.containsKey("fri") ? OpenHoursDay.fromJson(json["fri"]) : null,
      sat: json.containsKey("sat") ? OpenHoursDay.fromJson(json["sat"]) : null,
      sun: json.containsKey("sun") ? OpenHoursDay.fromJson(json["sun"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "mon": mon?.toJson(),
        "tue": tue?.toJson(),
        "wed": wed?.toJson(),
        "thu": thu?.toJson(),
        "fri": fri?.toJson(),
        "sat": sat?.toJson(),
        "sun": sun?.toJson(),
      };

  OpenHoursDay? operator [](int day) {
    switch (day) {
      case 1:
        return mon;
      case 2:
        return tue;
      case 3:
        return wed;
      case 4:
        return thu;
      case 5:
        return fri;
      case 6:
        return sat;
      case 7:
        return sun;
      default:
        return null;
    }
  }
}

@JsonSerializable()
class OpenHoursDay {
  final String? start;
  final String? end;

  OpenHoursDay({this.start, this.end});

  factory OpenHoursDay.fromJson(Map<String, dynamic> json) =>
      _$OpenHoursDayFromJson(json);

  Map<String, dynamic> toJson() => _$OpenHoursDayToJson(this);
}
