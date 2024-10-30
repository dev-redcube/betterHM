import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_link.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_existing_calendar.g.dart';

class AddExistingCalendarWidget extends StatelessWidget {
  const AddExistingCalendarWidget({
    super.key,
    required this.calendars,
    required this.add,
  });

  final Set<Calendar> calendars;
  final void Function(Calendar) add;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              t.calendar.edit.add.existingCalendar,
              style: context.theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _AddExistingCalendarWrapper(calendars: calendars, add: add),
          ),
        ],
      ),
    );
  }
}

@riverpod
Future<List<CalendarLink>> availableCalendars(Ref ref) async {
  return CalendarService().getAvailableCalendars();
}

class _AddExistingCalendarWrapper extends ConsumerWidget {
  const _AddExistingCalendarWrapper({
    required this.calendars,
    required this.add,
  });

  final Set<Calendar> calendars;
  final void Function(Calendar) add;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCalendars = ref.watch(availableCalendarsProvider);

    return switch (availableCalendars) {
      AsyncData(:final value) => _ExistingCalendars(
          calendarLinks: value,
          calendars: calendars,
          add: add,
        ),
      AsyncError(:final error) => Text("Error: $error"),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ExistingCalendars extends StatelessWidget {
  const _ExistingCalendars({
    required this.calendarLinks,
    required this.calendars,
    required this.add,
  });

  final List<CalendarLink> calendarLinks;
  final Iterable<Calendar> calendars;
  final void Function(Calendar) add;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: calendarLinks.length,
      separatorBuilder: (context, index) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final link = calendarLinks[index];
        final disabled = calendars.any((element) => element.id == link.id) ||
            calendars.any((element) => element.url == link.url);
        return ListTile(
          title: Text(link.name),
          enabled: !disabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () async {
            final calendar = Calendar(
              id: link.id,
              isActive: true,
              numOfFails: 0,
              name: link.name,
              url: link.url,
            );
            add(calendar);
          },
        );
      },
    );
  }
}
