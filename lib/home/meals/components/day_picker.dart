import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';

class DatePickerController with ChangeNotifier {
  List<DateTime> _days = [];

  DateTime? _activeDay;

  List<DateTime> get days => _days;

  void _sort() {
    _days.sort((a, b) => a.compareTo(b));
  }

  set days(List<DateTime> days) {
    _days = days.map((e) => e.withoutTime).toList();
    _sort();
    notifyListeners();
  }

  addDay(DateTime day) {
    _days.add(day.withoutTime);
    _sort();
    notifyListeners();
  }

  set activeDay(DateTime? day) {
    if (day == null) return;
    _activeDay = day.withoutTime;
    notifyListeners();
  }

  DateTime? get activeDay => _activeDay;
}

class DayPicker extends StatefulWidget {
  const DayPicker({super.key, required this.controller});

  final DatePickerController controller;

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  late int weekOfFirstDay;
  int numOfWeeks = 1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onChange);
    weekOfFirstDay = DateTime.now().weekNumber;
  }

  @override
  void dispose() {
    widget.controller.removeListener(onChange);
    super.dispose();
  }

  void onChange() {
    final first = widget.controller.days.first;
    final last = widget.controller.days.last;

    final firstMonday =
        first.subtract(Duration(days: first.weekday - DateTime.monday));

    final lastSunday = last.add(Duration(days: DateTime.sunday - last.weekday));

    weekOfFirstDay = first.weekNumber;
    numOfWeeks = last.weekNumber - weekOfFirstDay + 1;
  }

  @override
  Widget build(BuildContext context) {
    return PageView();
  }
}

class _Week extends StatelessWidget {
  _Week({super.key, required this.days, required this.weekNumber})
      // All Days must be in specified week
      : assert(days.every((e) => e.weekNumber == weekNumber));

  final List<DateTime> days;
  final int weekNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({
    super.key,
    required this.day,
    required this.isActive,
    required this.onTap,
  });

  final DateTime day;
  final bool isActive;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(t.general.date.weekdays[day.weekday - 1].substring(0, 2)),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? context.theme.colorScheme.primaryContainer : null,
          ),
          child: Text(day.day.toString()),
        ),
      ],
    );
  }
}
