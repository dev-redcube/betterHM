import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:redcube_campus/home/calendar/service/ical_sync_service.dart';
import 'package:redcube_campus/main.dart';
import 'package:redcube_campus/shared/logger/logger.dart';
import 'package:workmanager/workmanager.dart';

const calendarSyncKey = "de.moritzhuber.betterHm.syncCalendars";

@pragma("vm:entry-point")
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((taskName, inputData) async {
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
