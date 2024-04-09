import 'package:better_hm/shared/background_service/background_service.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

Future<void> calendarSyncTask() async {
  final prefs = await SharedPreferences.getInstance();
  final registeredOn =
      prefs.getString("workmanager.$calendarSyncKey.registeredOn");
  final lastSync = prefs.getString("workmanager.$calendarSyncKey.lastSync");

  // Not registered, register
  if (DateTime.tryParse(registeredOn ?? "") == null) {
    _register(prefs);
    return;
  }

  final lastSyncDate = DateTime.tryParse(lastSync ?? "");
  // Task registered, but unknown if it was executed
  // Need time to decide if it should be registered again
  if (lastSyncDate == null) return;

  /// Last sync was more than 12 hours ago,
  /// assume the task was not registered
  if (lastSyncDate.difference(DateTime.now()) > const Duration(hours: 12)) {
    _register(prefs);
    return;
  }
}

Future<void> _register(SharedPreferences prefs) async {
  await Workmanager().registerPeriodicTask(
    calendarSyncKey,
    calendarSyncKey,
    frequency: const Duration(hours: 6),
    initialDelay: const Duration(hours: 6),
  );

  Logger("BackgroundService").info("Registered task $calendarSyncKey");

  prefs.setString(
    "workmanager.$calendarSyncKey.lastSync",
    DateTime.now().toIso8601String(),
  );
}
