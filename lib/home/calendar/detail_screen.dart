import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redcube_campus/home/calendar/calendar_service.dart';
import 'package:redcube_campus/i18n/strings.g.dart';
import 'package:redcube_campus/shared/extensions/extensions_context.dart';
import 'package:redcube_campus/shared/extensions/extensions_date_time.dart';

class CalendarDetailScreen extends StatelessWidget {
  const CalendarDetailScreen({super.key, required this.event});

  final CustomCalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final component = event.eventData!.component;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          _TitleRow(event: event),
          if (component.location != null &&
              component.location!.value.value.isNotEmpty)
            _PropertyRow(
              leading: const Icon(Icons.location_on_outlined),
              label: Text(component.location!.value.value),
              copy: component.location?.value.value,
            ),
          if (component.description != null)
            _PropertyRow(
              leading: const Icon(Icons.subject_rounded),
              label: Text(component.description!.value.value),
              copy: component.description?.value.value,
            ),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.event});

  final CustomCalendarEvent event;

  String dateNotation(DateTime day) {
    return "${t.general.date.weekdays[day.weekday - 1]}, ${day.formatdMonthAbbr}";
  }

  String generateWeekday() {
    final day = event.start.onlyDate;
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    if (day.sameDayAs(today)) {
      return t.general.date.today;
    } else if (day.sameDayAs(tomorrow)) {
      return t.general.date.tomorrow;
    } else {
      return dateNotation(day);
    }
  }

  // cases:
  // "Normal", single day, times
  // normal, spans multiple days
  // fullday, spans one day
  // fullday, spans multiple days
  Widget buildSubtitle() {
    // start and end single day
    if (!event.isSplitAcrossDays) {
      if (event.isMultiDayEvent) {
        return Text(generateWeekday());
      }
      return _DotWithWidget(
        leading: Text(generateWeekday()),
        trailing: Text(
          "${event.start.formatTime} \u2012 ${event.end.formatTime}",
        ),
      );
    }

    // Multi-Day
    if (event.isMultiDayEvent) {
      return Text(
        "${dateNotation(event.start)} \u2012 ${dateNotation(event.end)}",
      );
    }

    // Multi-Day, but not all day
    return Text(
      "${dateNotation(event.start)}, ${event.start.formatTime} \u2012 ${dateNotation(event.end)}, ${event.end.formatTime}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PropertyRow(
      leading: Container(
        margin: const EdgeInsets.all(4),
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color:
              event.eventData?.color ??
              context.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      label: Text(
        event.eventData?.component.summary?.value.value ?? "No title",
        style: context.theme.textTheme.headlineSmall,
      ),
      subtitle: buildSubtitle(),
    );
  }
}

class _DotWithWidget extends StatelessWidget {
  const _DotWithWidget({required this.leading, required this.trailing});

  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.colorScheme.onSurface,
          ),
          height: 4,
          width: 4,
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}

class _PropertyRow extends StatelessWidget {
  const _PropertyRow({
    required this.leading,
    required this.label,
    this.subtitle,
    this.copy,
  });

  final Widget leading;
  final Widget label;
  final Widget? subtitle;
  final String? copy;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: label,
      subtitle: subtitle,
      onLongPress:
          copy == null
              ? null
              : () {
                Clipboard.setData(ClipboardData(text: copy!));
              },
    );
  }
}
