import 'dart:io';

import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:cancellation_token_http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class IcalSyncService {
  final httpClient = http.Client();
  final Isar _db;
  final Logger _log = Logger("IcalSyncService");

  IcalSyncService(this._db);

  Future<bool> syncIcal(
    Iterable<Calendar> allCalendars,
    http.CancellationToken cancelToken,
    void Function() onSyncDone,
    void Function(int synced, int total) onSyncProgress,
  ) async {
    final path =
        Directory("${(await getApplicationSupportDirectory()).path}/calendars");
    // Delete old files
    if (await path.exists()) {
      await path.delete(recursive: true);
    }
    await path.create();

    for (final calendar in allCalendars) {}
  }
}
