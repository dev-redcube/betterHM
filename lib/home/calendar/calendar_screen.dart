import 'package:better_hm/home/calendar/calendar_widget.dart';
import 'package:better_hm/home/calendar/models/event.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});

  final _controller = CalendarController<Event>();
  final _eventsController = DefaultEventsController<Event>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_name),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              _controller.animateToDate(DateTime.now());
            },
          ),
        ],
      ),
      body: CalendarWidget(controller: _controller, eventsController: _eventsController),
    );
  }
}
