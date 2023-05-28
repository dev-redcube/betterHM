import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/services/cache/cache_semester_status.dart';
import 'package:flutter/material.dart';

class DeadlinesAppointments extends StatelessWidget {
  const DeadlinesAppointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.dashboard.statusCard.deadlines_appointments,
            style: context.theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        StreamBuilder(
          stream: CacheSemesterStatus().stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LinearProgressIndicator();
            } else if (snapshot.data!.isEmpty) {
              return Text(t.dashboard.statusCard.no_data);
            }
            return const SizedBox(height: 16);
          },
        ),
      ],
    );
  }
}
