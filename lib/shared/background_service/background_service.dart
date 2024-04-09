import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
