import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/components/card_with_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class AddExistingCalendarWidget extends StatelessWidget {
  const AddExistingCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      title: "Add Existing Calendar",
      child: FutureBuilder(
        future: CalendarService.getAvailableCalendars(filterAdded: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.expand();

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
