import 'dart:async';

import 'package:better_hm/models/dashboard/event.dart';
import 'package:better_hm/services/isar_service.dart';
import 'package:isar/isar.dart';

class CacheSemesterStatus extends IsarService {
  final _streamController = StreamController<List<Event>?>();

  CacheSemesterStatus() {
    events.then((events) => _streamController.sink.add(events));
  }

  Stream<List<Event>?> get stream => _streamController.stream;

  Future<List<Event>> get events async {
    final isar = await db;
    final events = await isar.events
        .where()
        .contextEqualTo("STATUS_CARD")
        .sortByStart()
        .findAll();
    // if empty fetch from server

    return events;
  }
}
