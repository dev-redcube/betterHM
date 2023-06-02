import 'package:better_hm/models/dashboard/semester_event.dart';
import 'package:better_hm/models/date_tuple.dart';

class SemesterEventWithSingleDate extends DateTuple {
  final String title;
  final String? tag;

  SemesterEventWithSingleDate({
    required this.title,
    required DateTime start,
    DateTime? end,
    this.tag,
  }) : super(start, end);
}

/// This function converts a list of [SemesterEvent]s to a list of [SemesterEventWithSingleDate]s.
/// After that, all events with more than one date are split into multiple events with only one date.
List<SemesterEventWithSingleDate> convertSemesterEvents(
    List<SemesterEvent> semesterEvents) {
  final List<SemesterEventWithSingleDate> newEvents = [];

  for (final event in semesterEvents) {
    for (final date in event.dates) {
      newEvents.add(SemesterEventWithSingleDate(
        title: event.title,
        start: date.start,
        end: date.end,
        tag: event.tag,
      ));
    }
  }
  return newEvents;
}
