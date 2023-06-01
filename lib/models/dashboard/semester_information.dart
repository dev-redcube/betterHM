import 'package:better_hm/models/date_tuple.dart';

class SemesterInformation {
  final String name;
  final DateTuple? smesterDuration;
  final DateTuple? lecturePeriod;
  final List<DateTuple>? lectureFreeTimes;
  final DateTuple? examRegistration;
  final DateTime? examPeriodStart;
  final DateTime? gradeRelease;

  // Re-Registration for next semester
  final DateTuple? reRegistration;

  SemesterInformation({
    required this.name,
    this.smesterDuration,
    this.lecturePeriod,
    this.lectureFreeTimes,
    this.examRegistration,
    this.examPeriodStart,
    this.gradeRelease,
    this.reRegistration,
  });
}
