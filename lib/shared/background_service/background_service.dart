import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void setupWorkmanager() async {
  final workmanager = Workmanager();
  workmanager.initialize(callbackDispatcher, isInDebugMode: true);

  // TODO Check if calendar task already registered, probably available in workmanager 0.5.3
}

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    Prefs.init();
    await loadDb();
    await Prefs.logLevel.waitUntilLoaded();
    HMLogger();

    Logger("Background Service").info("Executing Task $taskName");

    final res = func(taskName, inputData);
    HMLogger().flush();
    return res;
  });
}

const calendarSyncKey = "de.moritzhuber.betterHm.syncCalendars";

Future<bool> func(String taskName, Map<String, dynamic>? inputData) async {
  final prefs = await SharedPreferences.getInstance();
  switch (taskName) {
    case calendarSyncKey:
      final res = await ICalService().sync();
      await prefs.setString(
        "workmanager.$calendarSyncKey.lastSync",
        DateTime.now().toIso8601String(),
      );
      return res;
    default:
      print("Task $taskName not implemented");
      return true;
    // throw Exception('Task not implemented');
  }
}
