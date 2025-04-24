import 'package:better_hm/home/calendar/view/component/add_custom_calendar.dart';
import 'package:better_hm/home/calendar/view/component/add_predefined_calendar.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class CalendarAddScreen extends StatelessWidget {
  const CalendarAddScreen({super.key});

  static const routeName = "calendars.add";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.calendar.add.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddCustomCalendarWidget(),
          // Expanded(child: Placeholder()),
          // Container(height: double.infinity, child: Card()),
          // Expanded(
          // child: Column(
          // children: [
          // Container(color: Colors.yellow, height: 20),
          // Expanded(child: Placeholder()),
          // ],
          // ),
          // ),
          Expanded(child: AddPredefinedCalendarWidget()),
        ],
      ),
    );
  }
}
