import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/i18n/strings.g.dart';
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
      ],
    );
  }
}
