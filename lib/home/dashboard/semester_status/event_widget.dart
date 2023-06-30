import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/home/dashboard/semester_status/models/semester_event_with_single_date.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
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
      return t.dashboard.cards.semesterStatus.today;
    } else if (event.start.onlyDate == tomorrow()) {
      return t.dashboard.cards.semesterStatus.tomorrow;
    } else {
      return "${event.start.day}.${event.start.month}.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.surfaceVariant,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectionContainer.disabled(
                child: Text(generateText(),
                    style: context.theme.textTheme.labelMedium)),
            Text(event.title, style: context.theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
