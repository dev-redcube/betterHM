import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:isar/isar.dart';

part 'calendar_event_save.g.dart';

@collection
class CalendarEventSave {
  Id? id;

  final calendar = IsarLink<Calendar>();

  final String? summary;
  final String? description;
  final String? location;
  final DateTime start;
  final DateTime end;

  CalendarEventSave({
    required this.summary,
    required this.description,
    required this.location,
    required this.start,
    required this.end,
  });
}
