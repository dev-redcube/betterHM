class Range {
  final double min;
  final double max;

  Range(this.min, this.max);
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);

  bool dateInRange(DateTime date) {
    return !date.isBefore(start) && !date.isAfter(end);
  }
}
