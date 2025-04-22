import 'package:better_hm/home/calendar/models/event_data.dart';
import 'package:better_hm/main.dart';
import 'package:isar/isar.dart';
import 'package:kalender/kalender.dart';

class EventService {
  final _controller = CalendarController<EventData>();
  final _eventsController = DefaultEventsController<EventData>();
  final _isar = getIt<Isar>();

  CalendarController<EventData> get controller => _controller;
  EventsController<EventData> get eventsController => _eventsController;

  /// Loads all events from the database and adds them to the controller
  Future<void> loadAllEvents() async {
    final events = await _isar.events.where().findAll();
    final mapped = events.map((e) => e.toCalendarEvent());
    _eventsController.addEvents(mapped.toList());
  }

  /// Add a [CalendarEvent] to both the database and controller
  /// Do not add to them directly, use this method instead
  void addEvent(CalendarEvent<EventData> event) {
    event.data ??= EventData(
      start: event.start,
      end: event.end,
      title: "New Event",
    );

    _isar.writeTxnSync(() {
      _isar.events.putSync(event.data!);
    });

    _eventsController.addEvent(event);
  }

  /// Update database-entry of a [CalendarEvent]
  void updateEvent(
    CalendarEvent<EventData> event,
    CalendarEvent<EventData> updatedEvent,
  ) {
    // Set date values of EventData, as they don't get updated automatically
    updatedEvent.data!.start = updatedEvent.start;
    updatedEvent.data!.end = updatedEvent.end;

    _isar.writeTxnSync(() {
      _isar.events.putSync(updatedEvent.data!);
    });
  }

  /// Delete [CalendarEvent] from both the controller and the database
  /// Do not modify either of them directly, use this method instead
  void deleteEvent(CalendarEvent<EventData> event) {
    _isar.writeTxnSync(() {
      _isar.events.deleteSync(event.data!.id!);
    });
    _eventsController.removeEvent(event);
  }
}
