import 'package:better_hm/home/dashboard/cards/semester_status/models/semester_event.dart';
import 'package:better_hm/home/dashboard/cards/semester_status/models/semester_event_with_single_date.dart';
import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

import 'api_semester_status.dart';
import 'deadlines_appointments.dart';
import 'semester_progress.dart';

class SemesterStatusCard extends ICard<List<SemesterEvent>> {
  @override
  Widget render(data) => _CardRender(data);

  @override
  Future<List<SemesterEvent>> future() => ApiSemesterStatus().getEvents();

  @override
  Widget? renderConfig(int cardIndex) => null;
}

class _CardRender extends StatelessWidget {
  const _CardRender(this.events);

  final List<SemesterEvent> events;

  @override
  Widget build(BuildContext context) {
    final List<SemesterEventWithSingleDate> eventsC =
        convertSemesterEvents(events);

    final SemesterEventWithSingleDate? lectureTime =
        eventsC.where((element) => element.tag == "lecture_period").firstOrNull;

    return DashboardCard(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 450),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${t.dashboard.cards.semesterStatus.summer_semester} 2023",
                style: context.theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            if (lectureTime != null) ...[
              SemesterProgress(date: lectureTime),
              const Divider()
            ],
            Expanded(child: DeadlinesAppointments(events: eventsC)),
          ],
        ),
      ),
    );
  }
}
