import 'dart:developer';

import 'package:isar/isar.dart';

part 'canteen.g.dart';

@collection
class Canteen {
  Id id = Isar.autoIncrement;

  final String enumName;

  final String name;
  final String canteenId;

  // final Location? location;
  final OpenHoursWeek? openHours;

  Canteen(this.enumName, this.name, this.canteenId, this.openHours);

  factory Canteen.fromJson(Map<String, dynamic> json) {
    final c = Canteen(
      json["enum_name"],
      json["name"],
      json["canteen_id"],
      // Location.fromJson(json["location"]),
      json["open_hours"] == null
          ? null
          : OpenHoursWeek.fromJson(json["open_hours"]),
    );
    log(c.toString());
    return c;
  }
}

@embedded
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

@embedded
class OpenHoursDay {
  final String? start;
  final String? end;

  OpenHoursDay({this.start, this.end});

  static OpenHoursDay fromJson(Map<String, dynamic> json) => OpenHoursDay(
        start: json["start"],
        end: json["end"],
      );
}
