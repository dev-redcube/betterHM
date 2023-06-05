import 'package:better_hm/components/dashboard/dashboard_card.dart';
import 'package:better_hm/components/dashboard/semester_status/deadlines_appointments.dart';
import 'package:better_hm/components/dashboard/semester_status/semester_progress.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/models/dashboard/semester_event.dart';
import 'package:better_hm/models/dashboard/semester_event_with_single_date.dart';
import 'package:better_hm/services/api/api_semester_status.dart';
import 'package:flutter/material.dart';

// TODO dynamic data
class SemesterStatus extends StatelessWidget {
  const SemesterStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCardWidget(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 150),
          child: FutureBuilder<List<SemesterEvent>>(
            future: ApiSemesterStatus().getEvents(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<SemesterEventWithSingleDate> events =
                  convertSemesterEvents(snapshot.data!);

              final SemesterEventWithSingleDate? lectureTime = events
                  .where((element) => element.tag == "LECTURE_TIME")
                  .firstOrNull;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${t.dashboard.statusCard.summer_semester} 2023",
                      style: context.theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  if (lectureTime != null) ...[
                    SemesterProgress(date: lectureTime),
                    const Divider()
                  ],
                  DeadlinesAppointments(events: events),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
