import 'package:better_hm/models/location.dart';

class Canteen {
  final String enumName;
  final String name;
  final String canteenId;
  final Location? location;
  final OpenHoursWeek? openHours;

  Canteen(
      this.enumName, this.name, this.canteenId, this.location, this.openHours);

  static Canteen fromJson(Map<String, dynamic> json) => Canteen(
        json["enum_name"],
        json["name"],
        json["canteen_id"],
        Location.fromJson(json["location"]),
        OpenHoursWeek.fromJson(json["open_hours"]),
      );
}

class OpenHoursWeek {
  final OpenHoursDay mon;
  final OpenHoursDay tue;
  final OpenHoursDay wed;
  final OpenHoursDay thu;
  final OpenHoursDay fri;

  OpenHoursWeek(this.mon, this.tue, this.wed, this.thu, this.fri);

  static OpenHoursWeek fromJson(Map<String, dynamic> json) => OpenHoursWeek(
        OpenHoursDay.fromJson(json["mon"]),
        OpenHoursDay.fromJson(json["tue"]),
        OpenHoursDay.fromJson(json["wed"]),
        OpenHoursDay.fromJson(json["thu"]),
        OpenHoursDay.fromJson(json["fri"]),
      );

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
      default:
        return null;
    }
  }
}

class OpenHoursDay {
  final String start;
  final String end;

  OpenHoursDay(this.start, this.end);

  static OpenHoursDay fromJson(Map<String, dynamic> json) => OpenHoursDay(
        json["start"],
        json["end"],
      );
}
