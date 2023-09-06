import 'package:better_hm/home/calendar/service/calendar_service.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CalendarService.fetchEvents(false),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Align(
            alignment: Alignment.topLeft,
            child: LinearProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.$2
              .map((e) => ListTile(
                    title: Text(
                        "${e.start.day}.${e.start.month}.${e.start.year}: ${e.title}"),
                  ))
              .toList(),
        );
      },
    );
  }
}
