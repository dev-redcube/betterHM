import 'package:better_hm/home/calendar/detail_screen.dart';
import 'package:better_hm/shared/models/range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("inRange", () {
    final start = DateTime(2024,09,16);
    final end = DateTime(2024,09,22);
    final range = DateRange(start, end);

    final middle = DateTime(2024, 09, 20);

    final inRange = range.dateInRange(middle);

    expect(inRange, true);
  });

  test("On Start", () {
    final start = DateTime(2024,09,16);
    final end = DateTime(2024,09,22);
    final range = DateRange(start, end);

    final middle = DateTime(2024, 09, 16);

    final inRange = range.dateInRange(middle);

    expect(inRange, true);
  });

  test("Outside", () {
    final start = DateTime(2024,09,16);
    final end = DateTime(2024,09,22);
    final range = DateRange(start, end);

    final middle = DateTime(2024, 09, 23);

    final inRange = range.dateInRange(middle);

    expect(inRange, false);
  });
}
