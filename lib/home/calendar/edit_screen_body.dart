import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class CalendarEditScreenBody extends StatefulWidget {
  const CalendarEditScreenBody({super.key});

  @override
  State<CalendarEditScreenBody> createState() => _CalendarEditScreenBodyState();
}

class _CalendarEditScreenBodyState extends State<CalendarEditScreenBody> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _CalendarEditScreenInner extends StatelessWidget {
  const _CalendarEditScreenInner({required this.calendars});

  final List<Calendar> calendars;

  @override
  Widget build(BuildContext context) {
    if (calendars.isNotEmpty) {
      return ListView.builder(
        itemCount: calendars.length,
        itemBuilder: (context, index) {
          final item = calendars[index];
          return _CalendarRow(
            key: ValueKey("calendar-${item.id}"),
            calendar: item,
          );
        },
      );
    }
    return Center(
      child: Text(t.calendar.edit.noCalendars),
    );
  }
}

class _CalendarRow extends StatefulWidget {
  const _CalendarRow({
    super.key,
    required this.calendar,
    required this.onDelete,
    required this.onChange,
  });

  final Calendar calendar;
  final void Function() onDelete;
  final void Function(Calendar) onChange;

  @override
  State<_CalendarRow> createState() => _CalendarRowState();
}

class _CalendarRowState extends State<_CalendarRow> {
  late final Calendar calendar;

  @override
  void initState() {
    super.initState();
    calendar = widget.calendar;
  }

  void _delete() {
    // TODO confirm popup
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      elevation: 0,
      child: ListTile(
        leading: Checkbox(
          value: calendar.isActive,
          onChanged: (state) {
            setState(() {
              calendar.isActive = state!;
            });
            widget.onChange.call(calendar);
          },
        ),
        title: Text(widget.calendar.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (calendar.numOfFails > 0)
              IconButton(
                icon: const Icon(
                  Icons.warning_rounded,
                  color: Colors.orange,
                ),
                onPressed: () => _warningPopup(context),
              ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: _delete,
            ),
          ],
        ),
      ),
    );
  }
}
