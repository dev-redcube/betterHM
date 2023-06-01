import 'package:better_hm/models/dashboard/semester_event.dart';

class SemesterEventWithSingleDate {
  final String title;
  final DateTime start;
  final DateTime? end;

  SemesterEventWithSingleDate({
    required this.title,
    required this.start,
    this.end,
  });
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
      ));
    }
  }
  return newEvents;
}
