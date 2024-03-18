import 'package:better_hm/home/calendar/calendar_body.dart';
import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_link.dart';
import 'package:better_hm/home/calendar/parse_events.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class AddCalendarScreen extends StatelessWidget {
  const AddCalendarScreen({super.key});

  static const String routeName = "calendar.add";

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = context.theme.textTheme.headlineSmall;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Calendar"),
      ),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const SizedBox(height: 16.0),
      //     Text("Add Own Calendar", style: textStyle),
      //     const Padding(
      //       padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
      //       child: _AddNewCalendarWidget(),
      //     ),
      //     Text("Or add existing", style: textStyle),
      //     const Expanded(
      //       child: Padding(
      //         padding: EdgeInsets.only(top: 8.0),
      //         child: _AddExistingCalendarWidget(),
      //       ),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          const _AddExistingCalendarWidget(),
        ],
      ),
    );
  }
}

class _AddNewCalendarWidget extends StatefulWidget {
  const _AddNewCalendarWidget();

  @override
  State<_AddNewCalendarWidget> createState() => _AddNewCalendarWidgetState();
}

class _AddNewCalendarWidgetState extends State<_AddNewCalendarWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Calendar URL",
              hintText: "https://example.com/calendar.ics",
            ),
            validator: (value) {
              if (Uri.tryParse(value ?? "")?.hasAbsolutePath ?? false) {
                return null;
              }
              return "Invalid url";
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Calendar Name",
              hintText: "My Calendar",
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "Name cannot be empty";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // add
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

class _AddExistingCalendarWidget extends ConsumerWidget {
  const _AddExistingCalendarWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<CalendarLink>>(
      future: CalendarService().getAvailableCalendars(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Align(
            alignment: Alignment.topLeft,
            child: LinearProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        final calendars = snapshot.data;

        return ListView.separated(
          itemCount: calendars!.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final link = calendars[index];
            return ListTile(
              title: Text(link.name),
              onTap: () async {
                final db = Isar.getInstance()!;
                // TODO check if already exists
                // Add the calendar to the database
                final calendar = Calendar(
                  id: link.id,
                  isActive: true,
                  numOfFails: 0,
                  name: link.name,
                  url: link.url,
                );
                await db.writeTxn(() async {
                  await db.calendars.put(calendar);
                });
                final icalService = ICalService();
                icalService.syncSingle(calendar).then((_) async {
                  final events = await parseEvents(calendar);
                  eventsController.addEvents(events.toList());
                });
                if (context.mounted) {
                  context.pop();
                }
              },
            );
          },
        );
      },
    );
  }
}
