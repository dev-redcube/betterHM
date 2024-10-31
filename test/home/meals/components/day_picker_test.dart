import 'package:better_hm/canteenComponent/widgets/day_picker.dart';
import 'package:better_hm/shared/exceptions/illegal_arguments_exception.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("DayPickerDay", () {
    final day = DayPickerDay(date: DateTime(2024, 09, 20), isActive: true);
    final same = DayPickerDay(date: DateTime(2024, 09, 20), isActive: true);
    final other1 = DayPickerDay(date: DateTime(2024, 09, 20), isActive: false);
    final other2 = DayPickerDay(date: DateTime(2024, 09, 21), isActive: true);

    expect(day == day, true);
    expect(day == same, true);
    expect(day == other1, false);
    expect(day == other2, false);
  });

  test("DayPickerWeek", () {
    final day = DayPickerDay(date: DateTime(2024, 09, 20), isActive: true);
    final week = DayPickerWeek.fromDay(day);

    expect(week.days, hasLength(7));
    expect(week.days.where((day) => day.isActive), hasLength(1));
    expect(week.days.first, day.monday());
    expect(week.days[4], day);
    expect(week.getFirstActive(), day);

    final day19 = DayPickerDay(date: DateTime(2024, 09, 19), isActive: true);
    week.setDay(day19);

    expect(week.days.where((day) => day.isActive), hasLength(2));
    expect(week.getFirstActive(), day19);
    expect(week.isDayActive(day19), true);

    final dayOnNextWeek = DayPickerDay(date: DateTime(2024, 09, 23));
    expect(
      () {
        // Not the same Week
        week.setDay(dayOnNextWeek);
      },
      throwsA(isA<IllegalArgumentsException>()),
    );

    final otherWeek = DayPickerWeek.fromDay(dayOnNextWeek);
    expect(week.compareTo(otherWeek), -1);
  });

  test("DayPickerWeeksWrapper", () {
    final wrapper = DayPickerWeeksWrapper();
    final firstDay = DayPickerDay(date: DateTime(2024, 09, 20), isActive: true);
    wrapper.addDay(firstDay);
    expect(wrapper.toList(), hasLength(1));

    final secondDay =
        DayPickerDay(date: DateTime(2024, 09, 19), isActive: true);
    wrapper.addDay(secondDay);
    expect(wrapper.toList(), hasLength(1));

    final thirdDayPreviousWeek =
        DayPickerDay(date: DateTime(2024, 09, 10), isActive: true);
    wrapper.addDay(thirdDayPreviousWeek);
    expect(wrapper.toList(), hasLength(2));

    wrapper.sort();
    expect(
      wrapper
          .toList()
          .first
          .days
          .first
          .isBefore(wrapper.toList().last.days.last),
      true,
    );

    final indexOfSecondDay = wrapper.indexOfDate(secondDay);
    expect(indexOfSecondDay, 1);

    DayPickerDay? nextActive = wrapper.getNextActive(firstDay);
    expect(nextActive, firstDay);
    final inactiveDay =
        DayPickerDay(date: DateTime(2024, 09, 18), isActive: false);
    wrapper.addDay(inactiveDay);
    nextActive = wrapper.getNextActive(inactiveDay);
    expect(nextActive, secondDay);
    final inactiveDayLast =
        DayPickerDay(date: DateTime(2024, 09, 21), isActive: false);
    nextActive = wrapper.getNextActive(inactiveDayLast);
    expect(nextActive, isNull);

    final firstActiveDay = wrapper.getFirstActiveDay();
    expect(firstActiveDay, thirdDayPreviousWeek);
  });
}
