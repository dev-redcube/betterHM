import 'dart:collection';

import 'package:logging/logging.dart';

// TODO read https://pub.dev/packages/flutter_background_service
// TODO read https://medium.com/flutter/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124

/// Task
abstract class CalendarTask {
  Future<void> run();

  Future<void> onError(Exception e);
}

class CalendarSyncService {
  final _logger = Logger("CalendarSyncService");
  final Queue<CalendarTask> _queue = ListQueue();

  void add(CalendarTask task) => _queue.add(task);

  Future<void> work() async {
    _logger.info("Started working Calendar-Tasks");
    while (_queue.isNotEmpty) {
      final task = _queue.removeFirst();
      try {
        await task.run();
      } on Exception catch (e, stacktrace) {
        _logger.severe(
          "Task ${task.runtimeType} failed with ${e.runtimeType}",
          e,
          stacktrace,
        );
        await task.onError(e);
      }
    }
    _logger.info("Finished working Calendar-Tasks");
  }
}
