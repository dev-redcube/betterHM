import 'package:better_hm/shared/extensions/extensions_context.dart';
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
      tileBuilder: (event, config) => _tileBuilder(event, config, context),
      multiDayTileBuilder: (event, config) =>
          _multiDayTileBuilder(event, config, context),
      scheduleTileBuilder: _scheduleTileBuilder,
    );
  }

  (Color, Color) getColors(
    CalendarEvent<EventData> event,
    BuildContext context,
  ) {
    final color = context.theme.colorScheme.primaryContainer;
    final Color textColor = context.theme.colorScheme.onPrimaryContainer;
    return (color, textColor);
  }

  Widget _tileBuilder(
    CalendarEvent<EventData> event,
    TileConfiguration configuration,
    BuildContext context,
  ) {
    final colors = getColors(event, context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: configuration.tileType == TileType.ghost ? 0 : 8,
      color: configuration.tileType != TileType.ghost
          ? colors.$1
          : colors.$1.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: configuration.tileType != TileType.ghost
            ? Text(
                event.eventData?.title ?? "No data",
                style: TextStyle(color: colors.$2),
                softWrap: true,
              )
            : null,
      ),
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<EventData> event,
    MultiDayTileConfiguration configuration,
    BuildContext context,
  ) {
    final colors = getColors(event, context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: configuration.tileType == TileType.selected ? 8 : 0,
      color: configuration.tileType == TileType.ghost
          ? colors.$1.withAlpha(100)
          : colors.$1,
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(
                event.eventData?.title ?? "No data",
                style: TextStyle(color: colors.$2),
                softWrap: true,
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
