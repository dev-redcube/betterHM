import 'package:better_hm/shared/models/event_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalender/kalender.dart';

final calendarController = CalendarController<EventData>();
final eventsController = CalendarEventsController<EventData>();

class CalendarBody extends ConsumerStatefulWidget {
  const CalendarBody({super.key});

  @override
  ConsumerState<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends ConsumerState<CalendarBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      controller: calendarController,
      eventsController: eventsController,
      viewConfiguration: WorkWeekConfiguration(),
      tileBuilder: _tileBuilder,
      multiDayTileBuilder: _multiDayTileBuilder,
      scheduleTileBuilder: _scheduleTileBuilder,
    );
  }

  Widget _tileBuilder(
    CalendarEvent<EventData> event,
    TileConfiguration configuration,
  ) {
    const color = Colors.blue;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: configuration.tileType == TileType.ghost ? 0 : 8,
      color: configuration.tileType != TileType.ghost
          ? color
          : color.withAlpha(100),
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(
                event.eventData?.title ?? "No data",
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              )
            : null,
      ),
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<EventData> event,
    MultiDayTileConfiguration configuration,
  ) {
    const color = Colors.blue;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: configuration.tileType == TileType.selected ? 8 : 0,
      color: configuration.tileType == TileType.ghost
          ? color.withAlpha(100)
          : color,
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(
                event.eventData?.title ?? 'No data',
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              )
            : null,
      ),
    );
  }

  Widget _scheduleTileBuilder(CalendarEvent<EventData> event, DateTime date) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(event.eventData?.title ?? 'No data'),
    );
  }
}
