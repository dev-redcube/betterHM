import 'package:better_hm/extensions/extensions_date_time.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/models/dashboard/semester_event_with_single_date.dart';
import 'package:flutter/material.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({Key? key, required this.event}) : super(key: key);

  final SemesterEventWithSingleDate event;

  String generateText() {
    if (event.end != null) {
      return "${event.start.day}.${event.start.month}. - ${event.end!.day}.${event.end!.month}.";
    }

    // Only one date
    if (event.start.onlyDate == today()) {
      return t.dashboard.statusCard.today;
    } else if (event.start.onlyDate ==
        today().subtract(const Duration(days: 1))) {
      return t.dashboard.statusCard.tomorrow;
    } else {
      return "${event.start.day}.${event.start.month}.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(generateText()),
          Text(event.title),
        ],
      ),
    );
  }
}
