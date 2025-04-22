import 'package:better_hm/home/calendar/calendar_widget.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/service/calendar_service.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarService = getIt<CalendarService>();
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
        ],
      ),
      body: CalendarWidget(
        controller: calendarService.controller,
        eventsController: calendarService.eventsController,
      ),
    );
  }
}
