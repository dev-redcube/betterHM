import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/exceptions/illegal_arguments_exception.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:better_hm/shared/models/range.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

// Future: extend DateTime
class DayPickerDay {
  final DateTime date;
  final bool isActive;

  DayPickerDay({required DateTime date, this.isActive = false})
      : date = date.withoutTime;

  @override
  String toString() => "DayPickerDay(date: $date, isActive: $isActive)";
}

class DayPickerWeek {
  late final List<DayPickerDay> days;

  bool hasDay(DateTime day) {
    return days.any((d) => d.date == day);
  }

  DayPickerWeek({required this.days});

  factory DayPickerWeek.fromDay(DayPickerDay day) {
    final monday = day.date.monday();
    final days = List.generate(
      7,
      (index) {
        final d = monday.add(Duration(days: index));
        return DayPickerDay(
          date: d,
          isActive: d == day.date ? day.isActive : false,
        );
      },
    );

    return DayPickerWeek(
      days: days,
    );
  }

  setDay(DayPickerDay day) {
    for (int i = 0; i < days.length; i++) {
      if (days[i].date == day.date) {
        days[i] = day;
        return;
      }
    }

    throw IllegalArgumentsException("Week must contain day");
  }

  DateRange get range => DateRange(days.first.date, days.last.date);

  bool isDayActive(DateTime date) {
    for (final day in days) {
      if (day.isActive && day.date.sameDayAs(date)) {
        return true;
      }
    }
    return false;
  }

  DayPickerDay? getFirstActive() =>
      days.firstWhereOrNull((day) => day.isActive);

  int compareTo(DayPickerWeek other) =>
      days.first.date.compareTo(other.days.first.date);

  @override
  String toString() => "DayPickerWeek(days: $days)";
}

class DayPickerWeeksWrapper {
  final List<DayPickerWeek> _weeks = [];

  List<DayPickerWeek> toList() => _weeks;

  void addDay(DayPickerDay day) {
    if (_weeks.none((week) => week.range.dateInRange(day.date))) {
      _weeks.add(DayPickerWeek.fromDay(day));
    } else {
      for (final week in _weeks) {
        if (week.range.dateInRange(day.date)) {
          week.setDay(day);
          return;
        }
      }
    }
  }

  void sort() {
    _weeks.sort((a, b) => a.compareTo(b));
  }

  int indexOfDate(DateTime date) {
    for (int i = 0; i < _weeks.length; i++) {
      if (_weeks[i].range.dateInRange(date.withoutTime)) {
        return i;
      }
    }
    return -1;
  }

  DateTime? getNextActiveAfter(DateTime date) {
    date = date.withoutTime;
    bool found = false;
    for (final week in _weeks) {
      if (!found && !week.range.dateInRange(date)) continue;

      if (week.range.dateInRange(date)) {
        found = true;
        final next = week.days.firstWhereOrNull((day) {
          return day.isActive && day.date >= date;
        });

        if (next != null) {
          return next.date;
        }
        continue;
      }

      // Not found in same week, take next
      final next = week.getFirstActive();
      if (next != null) return next.date;
    }
    return null;
  }

  DateTime? getFirstActiveDay() {
    for (final week in _weeks) {
      final active = week.getFirstActive();
      if (active != null) return active.date;
    }
    return null;
  }
}

class DayPicker extends StatefulWidget {
  const DayPicker({super.key, required this.dates, required this.onSelect});

  final List<DateTime> dates;
  final void Function(DateTime) onSelect;

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  DateTime? selectedDay;
  late DayPickerWeeksWrapper weeks;

  updateWeeks() {
    final sorted = widget.dates.sorted((a, b) => a.compareTo(b));

    if (sorted.isEmpty) {
      return DayPickerWeeksWrapper()
        ..addDay(DayPickerDay(date: DateTime.now(), isActive: false));
    }

    weeks = DayPickerWeeksWrapper();

    for (final date in widget.dates) {
      weeks.addDay(DayPickerDay(date: date, isActive: true));
    }

    weeks.sort();

    selectedDay = weeks.getNextActiveAfter(DateTime.now());
    if (selectedDay == null) selectedDay = weeks.getFirstActiveDay();
  }

  @override
  void initState() {
    updateWeeks();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DayPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dates.length != widget.dates.length) {
      updateWeeks();
      return;
    }

    // If one Date is different, recalculate weeks
    for (int i = 0; i < widget.dates.length; i++) {
      if (!widget.dates[i].sameDayAs(oldWidget.dates[i])) {
        updateWeeks();
        return;
      }
    }
  }

  void onDaySelected(DayPickerDay day) {
    setState(() {
      selectedDay = day.date;
    });
    widget.onSelect.call(day.date);
  }

  PageController? getPageController() {
    if (selectedDay == null) return null;

    return PageController(initialPage: weeks.indexOfDate(selectedDay!));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PageView(
        controller: getPageController(),
        children: weeks
            .toList()
            .map(
              (week) => _DaysRow(
                week: week,
                selectedDay: selectedDay,
                onDaySelected: onDaySelected,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DaysRow extends StatelessWidget {
  const _DaysRow({
    super.key,
    required this.week,
    required this.onDaySelected,
    this.selectedDay,
  });

  final DayPickerWeek week;
  final DateTime? selectedDay;
  final void Function(DayPickerDay) onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: week.days
          .map(
            (day) => Expanded(
              child: _Day(
                key: ValueKey(day),
                day: day,
                selectedDay: selectedDay,
                onTap: () => onDaySelected(day),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Day extends StatelessWidget {
  const _Day(
      {super.key, required this.day, required this.onTap, this.selectedDay});

  final DayPickerDay day;
  final void Function() onTap;
  final DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InkWell(
          onTap: day.isActive ? onTap : null,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: day.isActive && day.date.sameDayAs(DateTime.now())
                  ? context.theme.colorScheme.primaryContainer.withAlpha(80)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  constraints.maxWidth >= 64
                      ? t.general.date.weekdays_abbr[day.date.weekday - 1]
                      : t.general.date.weekdays_letter[day.date.weekday - 1],
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 48,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedDay?.sameDayAs(day.date) ?? false
                            ? context.theme.colorScheme.primaryContainer
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          day.date.day.toString(),
                          style: TextStyle(
                            color: day.isActive
                                ? null
                                : context.theme.colorScheme.onSurface
                                    .withAlpha(120),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
