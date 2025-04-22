import 'package:better_hm/shared/service/event_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:kalender/kalender.dart';

part 'event_data.g.dart';

@Collection(accessor: "events")
class EventData {
  Id? id;
  final String title;
  final String? description;
  final String? room;

  @ignore
  final Color? color;

  /// Start of the event
  /// Do not modify directly. Modify the [CalendarEvent] and save using [EventService]
  DateTime start;

  /// End of the Event
  /// Do not modify directly. Modify the [CalendarEvent] and save using [EventService]
  DateTime end;

  @ignore
  DateTimeRange get dateTimeRange => DateTimeRange(start: start, end: end);
  set dateTimeRange(DateTimeRange value) {
    start = value.start;
    end = value.end;
  }

  EventData({
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.room,
    this.color,
  });

  EventData copyWith({
    String? title,
    DateTime? start,
    DateTime? end,
    String? description,
    String? room,
    Color? color,
  }) => EventData(
    title: title ?? this.title,
    start: start ?? this.start,
    end: end ?? this.end,
    description: description ?? this.description,
    room: room ?? this.room,
    color: color ?? this.color,
  );

  factory EventData.fromCalendarEvent(CalendarEvent<EventData> event) {
    assert(event.data != null, "EventData must not be null");

    return event.data!
      ..start = event.start
      ..end = event.end;
  }

  CalendarEvent<EventData> toCalendarEvent() => CalendarEvent(
    data: this,
    dateTimeRange: DateTimeRange(start: start, end: end),
  );
}
