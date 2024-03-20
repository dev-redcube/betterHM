import 'package:better_hm/home/calendar/calendar_body.dart';
import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_link.dart';
import 'package:better_hm/home/calendar/parse_events.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

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
        title: const Text("Add Calendar"),
      ),
      body: FutureBuilder(
        future: db.calendars.where().findAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final calendars = (snapshot.data ?? []).toSet();
          return Column(
            children: [
              _AddNewCalendarWidget(
                calendars: calendars,
                add: (c) => {add(context, c)},
              ),
              Expanded(
                child: _AddExistingCalendarWidget(
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

class _AddNewCalendarWidget extends StatelessWidget {
  _AddNewCalendarWidget({required this.calendars, required this.add});

  final Set<Calendar> calendars;
  final void Function(Calendar) add;

  final formKey = GlobalKey<FormState>();
  final urlController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final urls = calendars.map((e) => e.url);
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Calendar URL",
              hintText: "https://example.com/calendar.ics",
            ),
            controller: urlController,
            validator: (value) {
              if (urls.contains(value)) {
                return "Calendar already exists";
              }

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
            controller: nameController,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "Name cannot be empty";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                const uuid = Uuid();
                final calendar = Calendar(
                  id: uuid.v1(),
                  isActive: true,
                  numOfFails: 0,
                  name: nameController.text,
                  url: urlController.text,
                );
                add(calendar);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

class _AddExistingCalendarWidget extends StatelessWidget {
  const _AddExistingCalendarWidget({
    required this.calendars,
    required this.add,
  });

  final Set<Calendar> calendars;
  final void Function(Calendar) add;

  @override
  Widget build(BuildContext context) {
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

        final onlineCalendars = snapshot.data;

        return ListView.separated(
          itemCount: onlineCalendars!.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final link = onlineCalendars[index];
            final disabled =
                calendars.any((element) => element.id == link.id) ||
                    calendars.any((element) => element.url == link.url);
            return ListTile(
              title: Text(link.name),
              enabled: !disabled,
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
      },
    );
  }
}
