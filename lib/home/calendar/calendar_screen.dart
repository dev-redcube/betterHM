import 'package:better_hm/home/calendar/calendar_widget.dart';
import 'package:better_hm/home/calendar/screens/edit_screen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/service/event_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarService = getIt<EventService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_name),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              calendarService.controller.animateToDate(DateTime.now());
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded),
            onPressed: () {
              context.pushNamed(CalendarEditScreen.routeName);
            },
            tooltip: t.calendar.edit.tooltip,
          ),
        ],
      ),
      body: CalendarWidget(
        controller: calendarService.controller,
        eventsController: calendarService.eventsController,
      ),
    );
  }
}
