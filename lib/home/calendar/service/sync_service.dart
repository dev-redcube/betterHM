import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/calendar_event_save.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar/icalendar.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class SyncService {
  final Logger _log = Logger("SyncService");
  final Isar _db;
  final httpClient = http.Client();
  final bool isBackground;

  SyncService({this.isBackground = false}) : _db = Isar.getInstance()!;

  static Future<Directory> getPath() async =>
      Directory("${(await getTemporaryDirectory()).path}/calendars");

  void getEventsForCalendar(Calendar calendar) async {
    final path = await getPath();
    if (!await path.exists()) await path.create();

    final icalFile = File("${path.path}/${calendar.id}.ics");
    _log.fine("Syncing calendar ${calendar.name}");

    try {
      final response = await httpClient.get(Uri.parse(calendar.url));

      if (200 != response.statusCode) {
        _log.warning(
          "Failed to download calendar ${calendar.name} with status code ${response.statusCode}",
          response.body,
        );
        await _db.writeTxn(() async {
          calendar.numOfFails++;
          await _db.calendars.put(calendar);
        });
        return;
      }

      await icalFile.writeAsBytes(response.bodyBytes);

      await _db.writeTxn(() async {
        calendar.lastUpdate = DateTime.now();
        calendar.numOfFails = 0;
        await _db.calendars.put(calendar);
      });
    } catch (e) {
      _log.warning("Failed to sync Calendar ${calendar.name}", e);

      await _db.writeTxn(() async {
        calendar.numOfFails++;
        await _db.calendars.put(calendar);
      });
    }
  }
}
