import 'package:better_hm/models/period.dart';

class SemesterInformation {
  final String name;
  final Period? smesterDuration;
  final Period? lecturePeriod;
  final List<Period>? lectureFreeTimes;
  final Period? examRegistration;
  final DateTime? examPeriodStart;
  final DateTime? gradeRelease;

  // Re-Registration for next semester
  final Period? reRegistration;

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
