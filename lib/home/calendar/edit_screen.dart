import 'package:better_hm/home/calendar/add_screen.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class CalendarEditScreen extends StatelessWidget {
  CalendarEditScreen({super.key});

  static const routeName = "calendar.edit";

  final Isar _db = Isar.getInstance()!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Calendar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            context.pop();
            // TODO update here
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {},
          ),
        ],
      ),
      // Listen to any changes in the Calendars storage
      body: StreamBuilder(
        stream: _db.calendars.watchLazy(),
        builder: (context, snapshot) {
          // When changes occur, fire a FutureBuilder to rebuild the UI
          return FutureBuilder<List<Calendar>>(
            future: _db.calendars.where().findAll(),
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

              final calendars = snapshot.data!;

              return _CalendarEditScreenBody(calendars);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(AddCalendarScreen.routeName);
        },
        label: const Text("Add"),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _CalendarEditScreenBody extends StatelessWidget {
  const _CalendarEditScreenBody(this.calendars);

  final List<Calendar> calendars;

  @override
  Widget build(BuildContext context) {
    if (calendars.isNotEmpty) {
      return ListView.builder(
        itemCount: calendars.length,
        itemBuilder: (context, index) {
          final item = calendars[index];
          return _CalendarRow(
            key: ValueKey(item.id),
            calendar: item,
          );
        },
      );
    }
    return const Center(
      child: Text("No calendars found"),
    );
  }
}

class _CalendarRow extends StatelessWidget {
  _CalendarRow({super.key, required this.calendar});

  final Calendar calendar;

  final Isar _db = Isar.getInstance()!;

  Future<void> toggle(bool? state) async {
    await _db.writeTxn(() async {
      calendar.isActive = state!;
      await _db.calendars.put(calendar);
    });
  }

  Future<void> delete() async {
    await _db.writeTxn(() async {
      await _db.calendars.delete(calendar.isarId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox.adaptive(
        value: calendar.isActive,
        onChanged: toggle,
      ),
      title: Text(calendar.name),
      trailing: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: delete,
      ),
    );
  }
}
