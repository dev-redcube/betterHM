import 'package:better_hm/home/calendar/view/component/edit_popup.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/view/add_screen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class CalendarEditScreen extends StatelessWidget {
  const CalendarEditScreen({super.key});

  static const routeName = "calendar.edit";

  @override
  Widget build(BuildContext context) {
    final isar = getIt<Isar>();
    return Scaffold(
      appBar: AppBar(title: Text(t.calendar.edit.title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder(
          stream: isar.calendars.watchLazy(),
          builder: (context, snapshot) {
            return FutureBuilder(
              future: isar.calendars.where().findAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return SizedBox.shrink();

                final calendars = snapshot.data!;

                return ListView.separated(
                  itemCount: calendars.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = calendars[index];
                    return CalendarRow(
                      key: ValueKey("calendar-${item.id}"),
                      calendar: item,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_rounded),
        label: Text(t.calendar.add.label),
        onPressed: () {
          context.pushNamed(CalendarAddScreen.routeName);
        },
      ),
    );
  }
}

class CalendarRow extends StatelessWidget {
  const CalendarRow({super.key, required this.calendar});

  final Calendar calendar;

  void toggle(bool? value) async {
    if (value == calendar.isActive || value == null) return;

    final isar = getIt<Isar>();

    await isar.writeTxn(() async {
      calendar.isActive = value;
      await isar.calendars.put(calendar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: calendar.isActive,
            onChanged: (value) => toggle(value),
          ),
          SizedBox(width: 8),
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: calendar.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      title: Text(calendar.name),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => EditCalendarPopup(calendar: calendar),
        );
      },
    );
  }
}
