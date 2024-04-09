import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/shared/background_service/calendar_background_service.g.dart',
  ),
)
class InitCalendarTaskMessage {}

@FlutterApi()
abstract class CalendarSyncFlutterApi {
  void syncCalendars();
}
