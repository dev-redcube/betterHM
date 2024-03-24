import 'package:better_hm/home/calendar/calendar_body.dart';
import 'package:better_hm/home/calendar/edit_screen.dart';
import 'package:better_hm/home/calendar/ical_sync_state.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_name),
        backgroundColor:
            context.theme.colorScheme.secondaryContainer.withAlpha(100),
        scrolledUnderElevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            onPressed: () {
              calendarController.animateToDate(DateTime.now());
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded),
            onPressed: () {
              context.pushNamed(CalendarEditScreen.routeName);
            },
            tooltip: t.navigation.settings,
          ),
        ],
      ),
      body: const Stack(
        alignment: Alignment.topCenter,
        children: [
          CalendarBody(),
          SyncProgress(),
          // SButton(),
        ],
      ),
    );
  }
}

// Sync Button
class SButton extends ConsumerWidget {
  const SButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: const Text("Sync"),
      onPressed: () {
        ref.read(iCalSyncStateNotifierProvider.notifier).sync();
      },
    );
  }
}

class SyncProgress extends ConsumerWidget {
  const SyncProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(iCalSyncStateNotifierProvider).value;
    return SizedBox(
      height: value?.syncProgress == ICalSyncProgressEnum.inProgress ? null : 0,
      child: LinearProgressIndicator(
        value: value?.progressInPercent,
      ),
    );
  }
}
