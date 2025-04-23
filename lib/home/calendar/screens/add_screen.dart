import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
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
      appBar: AppBar(title: Text("Add Calendar TODO replace")),
      body: Column(children: [Expanded(child: AddExistingCalendarWidget())]),
    );
  }
}

class AddExistingCalendarWidget extends StatelessWidget {
  const AddExistingCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CalendarService.getAvailableCalendars(filterAdded: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        final calendars = snapshot.data!;
        return ListView.builder(
          itemCount: calendars.length,
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
                    ),
                  );
                });

                if (context.mounted) context.pop();
              },
            );
          },
        );
      },
    );
  }
}
