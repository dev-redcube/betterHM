import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class IcalSyncService {
  final httpClient = http.Client();
  final Isar _db;
  final Logger _log = Logger("IcalSyncService");

  IcalSyncService() : _db = Isar.getInstance()!;

  Future<bool> sync({
    void Function(int synced, int total)? onSyncProgress,
    void Function()? onSyncDone,
  }) async {
    final activeCalendars =
        await _db.calendars.filter().isActiveEqualTo(true).findAll();
    final path =
        Directory("${(await getApplicationSupportDirectory()).path}/calendars");

    if (!await path.exists()) {
      await path.create();
    }

    int synced = 0;

    for (final calendar in activeCalendars) {
      final file = File("${path.path}/${calendar.id}.ics");
      _log.info("Downloading calendar ${calendar.name}");
      final response = await httpClient.get(
        Uri.parse(calendar.url),
      );
      await file.writeAsBytes(response.bodyBytes);

      synced++;
      onSyncProgress?.call(synced, activeCalendars.length);
    }

    return true;
  }

  void cleanupOldCalendars(Directory path, Iterable<Calendar> calendars) {
    path.list().forEach((element) {
      final filename = element.path.split(Platform.pathSeparator).last;
      final calendarId = filename.split(".").first;

      if (!calendars.any((element) => element.id == calendarId)) {
        element.delete();
      }
    });
  }
}
