import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';

const calendarSyncKey = "de.moritzhuber.betterHm.syncCalendars";

@pragma("vm:entry-point")
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger("BackgroundService");
  Workmanager().executeTask((taskName, inputData) async {
    Logger("BackgroundService").info("Executing task $taskName", inputData);
    switch (taskName) {
      case calendarSyncKey:
        logger.info("Syncing calendars");
        final res = await ICalService().sync();
        return res;
      default:
        throw Exception('Task not implemented');
    }
  });
}
