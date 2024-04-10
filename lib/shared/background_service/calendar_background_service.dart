import 'package:better_hm/shared/prefs.dart';
import 'package:workmanager/workmanager.dart';

const calendarSyncKey = "de.moritzhuber.betterHm.syncCalendars";

/// Sets up the calendar backround Syncing.
/// Checks if already setup before actually registering the task.
/// Registering can be forced by using [force] = true
Future<void> setupCalendarBackgroundService({bool force = false}) async {
  // TODO Check if calendar task already registered, probably available in workmanager 0.5.3

  await Prefs.calendarOnlySyncOnWifi.waitUntilLoaded();
  final wifiOnly = Prefs.calendarOnlySyncOnWifi.value;

  Workmanager().registerPeriodicTask(
    calendarSyncKey,
    calendarSyncKey,
    constraints: Constraints(
      networkType: wifiOnly ? NetworkType.unmetered : NetworkType.connected,
    ),
    backoffPolicy: BackoffPolicy.exponential,
    existingWorkPolicy: ExistingWorkPolicy.replace,
    frequency: const Duration(hours: 6),
  );
}
