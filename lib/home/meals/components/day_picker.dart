import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/exceptions/illegal_arguments_exception.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:better_hm/shared/models/range.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DayPickerDay extends DateTime {
  final bool isActive;

  DayPickerDay({required DateTime date, this.isActive = false})
      : super(date.year, date.month, date.day);

  @override
  String toString() =>
      "DayPickerDay(date: ${super.toString()}, isActive: $isActive)";

  @override
  bool operator ==(covariant DayPickerDay other) =>
      hashCode == other.hashCode ||
      (year == other.year &&
          month == other.month &&
          day == other.day &&
          isActive == other.isActive);

  @override
  int get hashCode => Object.hash(year, month, day, isActive);
}

class DayPickerWeek {
  late final List<DayPickerDay> days;

  bool hasDay(DateTime day) {
    return days.any((d) => d.sameDayAs(day));
  }

  DayPickerWeek({required this.days});

  factory DayPickerWeek.fromDay(DayPickerDay day) {
    final monday = day.monday();
    final days = List.generate(
      7,
      (index) {
        final d = monday.add(Duration(days: index));
        return DayPickerDay(
          date: d,
          isActive: d.sameDayAs(day) ? day.isActive : false,
        );
      },
    );

    return DayPickerWeek(
      days: days,
    );
  }

  setDay(DayPickerDay day) {
    for (int i = 0; i < days.length; i++) {
      if (days[i].sameDayAs(day)) {
        days[i] = day;
        return;
      }
    }

    throw IllegalArgumentsException("Week must contain day");
  }

  DateRange get range => DateRange(days.first, days.last);

  bool isDayActive(DateTime date) {
    for (final day in days) {
      if (day.isActive && day.sameDayAs(date)) {
        return true;
      }
    }
    return false;
  }

  DayPickerDay? getFirstActive() =>
      days.firstWhereOrNull((day) => day.isActive);

  int compareTo(DayPickerWeek other) => days.first.compareTo(other.days.first);

  @override
  String toString() => "DayPickerWeek(days: $days)";
}

class DayPickerWeeksWrapper {
  final List<DayPickerWeek> _weeks = [];

  List<DayPickerWeek> toList() => _weeks;

  void addDay(DayPickerDay day) {
    if (_weeks.none((week) => week.range.dateInRange(day))) {
      _weeks.add(DayPickerWeek.fromDay(day));
    } else {
      for (final week in _weeks) {
        if (week.range.dateInRange(day)) {
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

  DayPickerDay? getNextActive(DateTime date) {
    date = date.withoutTime;
    bool found = false;
    for (final week in _weeks) {
      if (!found && !week.range.dateInRange(date)) continue;

      if (week.range.dateInRange(date)) {
        found = true;
        final next = week.days.firstWhereOrNull((day) {
          return day.isActive && day >= date;
        });

        if (next != null) {
          return next;
        }
        continue;
      }

      // Not found in same week, take next
      final next = week.getFirstActive();
      if (next != null) return next;
    }
    return null;
  }

  DayPickerDay? getFirstActiveDay() {
    for (final week in _weeks) {
      final active = week.getFirstActive();
      if (active != null) return active;
    }
    return null;
  }
}

class DayPicker extends StatefulWidget {
  DayPicker({super.key, List<DateTime>? dates, this.onSelect})
      : dates = dates ?? [];

  final List<DateTime> dates;
  final void Function(DateTime)? onSelect;

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  DateTime? selectedDay;
  late DayPickerWeeksWrapper weeks;
  final pageController = PageController();

  updateWeeks() {
    final sorted = widget.dates.sorted((a, b) => a.compareTo(b));

    if (sorted.isEmpty) {
      weeks = DayPickerWeeksWrapper()
        ..addDay(DayPickerDay(date: DateTime.now(), isActive: false));
    }

    weeks = DayPickerWeeksWrapper();

    for (final date in widget.dates) {
      weeks.addDay(DayPickerDay(date: date, isActive: true));
    }

    weeks.sort();

    selectedDay = weeks.getNextActive(DateTime.now());
    selectedDay ??= weeks.getFirstActiveDay();
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
      selectedDay = day;
    });
    HapticFeedback.selectionClick();
    widget.onSelect?.call(day);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedDay != null) {
        final index = weeks.indexOfDate(selectedDay!);
        pageController.jumpToPage(index);
      }
    });

    return SizedBox(
      height: 100,
      child: PageView(
        controller: pageController,
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
  const _Day({
    super.key,
    required this.day,
    required this.onTap,
    this.selectedDay,
  });

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
              color: day.isActive && day.sameDayAs(DateTime.now())
                  ? context.theme.colorScheme.primaryContainer.withAlpha(80)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  constraints.maxWidth >= 64
                      ? t.general.date.weekdays_abbr[day.weekday - 1]
                      : t.general.date.weekdays_letter[day.weekday - 1],
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
                        color: selectedDay?.sameDayAs(day) ?? false
                            ? context.theme.colorScheme.primaryContainer
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          day.day.toString(),
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
