import 'package:better_hm/components/dashboard/semester_status/event.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/models/dashboard/semester_event_with_single_date.dart';
import 'package:flutter/material.dart';

class DeadlinesAppointments extends StatelessWidget {
  const DeadlinesAppointments({Key? key, required this.events})
      : super(key: key);

  final List<SemesterEventWithSingleDate> events;

  List<SemesterEventWithSingleDate> sortedEvents() {
    return events
      ..sort((a, b) => (a.end ?? a.start).compareTo(b.end ?? b.start));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.dashboard.statusCard.deadlines_appointments,
            style: context.theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        ListView(
          shrinkWrap: true,
          children:
              sortedEvents().map((e) => EventWidget(event: e)).take(4).toList(),
        )
      ],
    );
  }
}
