import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/exceptions/illegal_arguments_exception.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

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

  bool containsDay(DateTime date) {
    // days length is always 7
    final monday = days.first.date;
    final sunday = days.last.date;
    // >= monday && <= sunday
    return !date.isBefore(monday) && !date.isAfter(sunday);
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

  DayPickerWeek? setOrCreateNew(DayPickerDay day) {
    if (containsDay(day.date)) {
      setDay(day);
      return null;
    }

    return DayPickerWeek.fromDay(day);
  }

  @override
  String toString() => "DayPickerWeek(days: $days)";
}

class DayPicker extends StatefulWidget {
  const DayPicker({super.key, required this.dates, required this.onSelect});

  final List<DateTime> dates;
  final void Function(DateTime) onSelect;

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  DateTime? selectedDay = DateTime.now();
  late final List<DayPickerWeek> weeks;

  List<DayPickerWeek> getWeeks() {
    final sorted = widget.dates.sorted((a, b) => a.compareTo(b));

    if (sorted.isEmpty) {
      return [
        DayPickerWeek.fromDay(
          DayPickerDay(date: DateTime.now(), isActive: false),
        ),
      ];
    }

    List<DayPickerWeek> weeks = [];

    weeks.add(
      DayPickerWeek.fromDay(
        DayPickerDay(date: sorted.first, isActive: true),
      ),
    );

    for (final day in sorted.skip(1)) {
      for (final week in weeks) {
        final newWeek =
            week.setOrCreateNew(DayPickerDay(date: day, isActive: true));
        if (newWeek != null) weeks.add(newWeek);
        break;
      }
    }

    return weeks;
  }

  @override
  void initState() {
    weeks = getWeeks();
    super.initState();
  }

  void onDaySelected(DayPickerDay day) {
    setState(() {
      selectedDay = day.date;
    });
    widget.onSelect.call(day.date);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PageView(
        children: weeks
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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.0),
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
                      child: Center(child: Text(day.date.day.toString())),
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
