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

@JsonSerializable()
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

  factory OpenHoursWeek.fromJson(Map<String, dynamic> json) =>
      _$OpenHoursWeekFromJson(json);

  Map<String, dynamic> toJson() => _$OpenHoursWeekToJson(this);

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
  final String start;
  final String end;

  OpenHoursDay({required this.start, required this.end});

  factory OpenHoursDay.fromJson(Map<String, dynamic> json) =>
      _$OpenHoursDayFromJson(json);

  Map<String, dynamic> toJson() => _$OpenHoursDayToJson(this);
}
