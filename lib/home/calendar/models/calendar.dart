import 'package:better_hm/home/calendar/models/calendar_link.dart';
import 'package:isar/isar.dart';

part 'calendar.g.dart';

@collection
class Calendar extends CalendarLink {
  Id? id;
  bool isActive;
  int numOfFails;

  Calendar({
    required this.id,
    required this.isActive,
    required this.numOfFails,
    required super.name,
    required super.url,
  });
}
