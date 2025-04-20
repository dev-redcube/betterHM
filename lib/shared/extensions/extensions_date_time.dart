import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/models/range.dart';
import 'package:intl/intl.dart';

abstract class _DateHelper {
  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int numberOfWeeks(int year) {
    double helper(int num) =>
        (num + (num / 4).floor() - (num / 100).floor() + (num / 400).floor()) %
        7;

    if (helper(year) == 4 || helper(year - 1) == 3) {
      return 53;
    }
    return 52;
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculating_the_week_number_from_an_ordinal_date
  static int weekOfYear(DateTime date) {
    int w =
        ((int.parse(DateFormat("D").format(date)) - date.weekday + 10) / 7)
            .floor();

    if (w < 1) {
      return numberOfWeeks(date.year - 1);
    } else if (w > numberOfWeeks(date.year)) {
      return 1;
    } else {
      return w;
    }
  }
}

extension DateTimeExtensions on DateTime {
  /// Calendar Week of year
  int get weekNumber => _DateHelper.weekOfYear(this);

  DateTime get onlyDate => DateTime(year, month, day);

  // 5. April
  String get formatdMonth => DateFormat("d. MMMM").format(this);

  // 5. Apr
  String get formatdMonthAbbr =>
      "$day. ${t.general.date.months[month - 1].substring(0, 3)}";

  DateTime get withoutTime => DateTime(year, month, day);

  String get formatTime => DateFormat("HH:mm").format(toLocal());

  bool sameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool isMidnight() => hour == 0 && minute == 0 && second == 0;

  DateTime monday() => DateTime(year, month, day - (weekday - 1) % 7);

  DateTime sunday() => DateTime(year, month, day + (7 - weekday) % 7);

  bool inRange(DateRange range) => range.dateInRange(this);

  bool operator >(DateTime other) => isAfter(other);

  bool operator >=(DateTime other) => !isBefore(other);

  bool operator <(DateTime other) => isBefore(other);

  bool operator <=(DateTime other) => !isAfter(other);
}

DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

DateTime now() => DateTime.now();

DateTime tomorrow() => today().add(const Duration(days: 1));
