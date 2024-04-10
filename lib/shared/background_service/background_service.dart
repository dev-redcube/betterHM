import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/background_service/calendar_background_service.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';

void setupWorkmanager() async {
  await Prefs.showBackgroundJobNotification.waitUntilLoaded();
  final workmanager = Workmanager();
  workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: kDebugMode || Prefs.showBackgroundJobNotification.value,
  );

  await setupCalendarBackgroundService();
}

@pragma("vm:entry-point")
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((taskName, inputData) async {
    Prefs.init();
    await loadDb();
    HMLogger();
    final log = Logger("BackgroundService");
    log.info("Executing task $taskName", inputData);

    late final bool res;
    try {
      res = await func(taskName, inputData);
    } catch (e) {
      log.severe("Task $taskName threw an error", e);
      return false;
    }

    if (!res) {
      log.warning("Task $taskName returned with an error");
    } else {
      log.info("Task $taskName completed successfully");
    }

    return res;
  });
}

Future<bool> func(String taskName, Map<String, dynamic>? inputData) async {
  switch (taskName) {
    case calendarSyncKey:
      final res = await ICalService().sync();
      return res;
    default:
      throw Exception('Task not implemented');
  }
}
