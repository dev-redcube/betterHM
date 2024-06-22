import 'dart:async';
import 'dart:isolate';

import 'package:better_hm/home/calendar/calendar_update_service.dart';
import 'package:better_hm/home/calendar/models/calendar.dart';

class UpdateCalendarWorker {
  static final UpdateCalendarWorker _instance =
      UpdateCalendarWorker._internal();

  factory UpdateCalendarWorker() => _instance;

  UpdateCalendarWorker._internal();

  bool _isSpawned = false;

  late SendPort _sendPort;
  late ReceivePort _receivePort;

  final List<Calendar> _queue = [];

  void spawn() async {
    if (_isSpawned) return;

    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete(
        (
          ReceivePort.fromRawReceivePort(initPort),
          commandPort,
        ),
      );
    };

    // Spawn isolate
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      _isSpawned = false;
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    _receivePort = receivePort;
    _sendPort = sendPort;
  }

  void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandToIsolate(receivePort, sendPort);
  }

  void _handleCommandToIsolate(ReceivePort receivePort, SendPort sendPort) {
    receivePort.listen((message) {
      if (message == "shutdown") {
        receivePort.close();
        return;
      }
      final Calendar calendar = message as Calendar;
      try {
        CalendarUpdateService.updateCalendar(calendar);
        sendPort.send(true);
      } catch (e) {
        _sendPort.send((calendar, RemoteError(e.toString(), "")));
      }
    });
  }
}
