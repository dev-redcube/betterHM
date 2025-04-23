import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class CalendarAddScreen extends StatelessWidget {
  const CalendarAddScreen({super.key});

  static const routeName = "calendars.add";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.calendar.add.title)),
      body: Column(children: [Expanded(child: AddExistingCalendarWidget())]),
    );
  }
}

class AddExistingCalendarWidget extends StatelessWidget {
  const AddExistingCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder(
        future: CalendarService.getAvailableCalendars(filterAdded: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();

          // TODO error and ifEmpty widgets

          final calendars = snapshot.data!;
          return ListView.separated(
            itemCount: calendars.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final calendar = calendars[index];

              return ListTile(
                title: Text(calendar.name),
                onTap: () async {
                  final isar = getIt<Isar>();

                  await isar.writeTxn(() async {
                    await isar.calendars.put(
                      Calendar(
                        externalId: calendar.id,
                        name: calendar.name,
                        url: calendar.url,
                        type: CalendarType.PREDEFINED,
                      ),
                    );
                  });

                  if (context.mounted) context.pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
