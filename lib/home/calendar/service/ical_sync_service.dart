import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class ICalService {
  final httpClient = http.Client();
  final Isar _db;
  final Logger _log = Logger("IcalSyncService");

  ICalService() : _db = Isar.getInstance()!;

  static Future<Directory> getPath() async =>
      Directory("${(await getApplicationSupportDirectory()).path}/calendars");

  Future<bool> sync({
    void Function(int synced, int total)? onSyncProgress,
  }) async {
    final activeCalendars =
        await _db.calendars.filter().isActiveEqualTo(true).findAll();
    final path = await getPath();

    if (!await path.exists()) {
      await path.create();
    }

    int synced = 0;

    for (final calendar in activeCalendars) {
      await syncSingle(calendar);

      synced++;
      onSyncProgress?.call(synced, activeCalendars.length);
    }

    return true;
  }

  Future<void> syncSingle(Calendar calendar) async {
    final path = await getPath();
    final file = File("${path.path}/${calendar.id}.ics");
    _log.info("Downloading calendar ${calendar.name}");
    final response = await httpClient.get(
      Uri.parse(calendar.url),
    );
    await file.writeAsBytes(response.bodyBytes);

    await _db.writeTxn(() async {
      calendar.lastUpdate = DateTime.now();
      await _db.calendars.put(calendar);
    });
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

  Future<List<Calendar>> getActiveCalendars() async =>
      _db.calendars.filter().isActiveEqualTo(true).findAll();
}
