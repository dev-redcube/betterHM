import 'dart:collection';

// TODO read https://pub.dev/packages/flutter_background_service
// TODO read https://medium.com/flutter/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124

class CalendarSyncTask {}

class CalendarSyncService {
  final Queue<CalendarSyncTask> queue = ListQueue();
}
