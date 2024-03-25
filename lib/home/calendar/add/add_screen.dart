import 'package:better_hm/home/calendar/add/add_existing_calendar.dart';
import 'package:better_hm/home/calendar/add/add_new_calendar.dart';
import 'package:better_hm/home/calendar/calendar_body.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/parse_events.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class AddCalendarScreen extends StatelessWidget {
  AddCalendarScreen({super.key});

  static const String routeName = "calendar.add";
  final db = Isar.getInstance()!;

  void add(BuildContext context, Calendar calendar) async {
    await db.writeTxn(() async {
      await db.calendars.put(calendar);
    });
    if (context.mounted) {
      context.pop();
    }
    final icalService = ICalService();
    icalService.syncSingle(calendar).then((_) async {
      final events = await parseEvents(calendar);
      eventsController.addEvents(events.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.calendar.edit.add.title),
      ),
      body: FutureBuilder(
        future: db.calendars.where().findAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final calendars = (snapshot.data ?? []).toSet();
          return Column(
            children: [
              AddNewCalendarWidget(
                calendars: calendars,
                add: (c) => {add(context, c)},
              ),
              Expanded(
                child: AddExistingCalendarWidget(
                  calendars: calendars,
                  add: (c) => {add(context, c)},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
