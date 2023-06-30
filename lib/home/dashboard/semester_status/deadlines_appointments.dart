import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/semester_status/event_widget.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/home/dashboard/semester_status/models/semester_event_with_single_date.dart';
import 'package:better_hm/home/dashboard/semester_status/tags.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class DeadlinesAppointments extends StatelessWidget {
  const DeadlinesAppointments({Key? key, required this.events})
      : super(key: key);

  final List<SemesterEventWithSingleDate> events;

  List<SemesterEventWithSingleDate> sortedEvents() {
    final e = events
      ..sort((a, b) => (a.end ?? a.start).compareTo(b.end ?? b.start));
    final filtered = e
        .where((element) => !element.isFinished)
        .where((element) => !tagsToFilterOut.contains(element.tag))
        .toList();
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.dashboard.cards.semesterStatus.deadlines_appointments,
            style: context.theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Expanded(
          child: SelectionArea(
            child: ListView(
              shrinkWrap: true,
              children:
                  sortedEvents().map((e) => EventWidget(event: e)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
