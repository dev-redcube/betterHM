import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/models/event_data.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});

  final calendarController = CalendarController<EventData>();
  final eventsController = CalendarEventsController<EventData>();

  final List<ViewConfiguration> viewConfigurations = [
    DayConfiguration(),
    WeekConfiguration(),
    MonthConfiguration(),
    ScheduleConfiguration(),
  ];

  @override
  Widget build(BuildContext context) {
    return CalendarView<EventData>(
      controller: calendarController,
      eventsController: eventsController,
      tileBuilder:
          (CalendarEvent<EventData> event, TileConfiguration tileConfig) =>
              _tileBuilder(event, tileConfig, context),
      viewConfiguration: WorkWeekConfiguration(),
      multiDayTileBuilder: (
        CalendarEvent<EventData> event,
        MultiDayTileConfiguration configuration,
      ) =>
          _multiDayTileBuilder(event, configuration, context),
      scheduleTileBuilder: (CalendarEvent<EventData> event, DateTime date) =>
          _scheduleTileBuilder(event, date, context),
    );
  }

  (Color, Color) getColors(
    CalendarEvent<EventData> event,
    BuildContext context,
  ) {
    final color = event.eventData?.color ?? context.theme.colorScheme.primary;
    late final Color textColor;
    if (event.eventData != null && event.eventData?.color != null) {
      textColor =
          ThemeData.estimateBrightnessForColor(event.eventData!.color!) ==
                  Brightness.light
              ? Colors.black
              : Colors.white;
    } else {
      textColor = context.theme.colorScheme.onPrimary;
    }

    return (color, textColor);
  }

  Widget _tileBuilder(
    CalendarEvent<EventData> event,
    TileConfiguration tileConfig,
    BuildContext context,
  ) {
    final colors = getColors(event, context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: tileConfig.tileType == TileType.selected ? 8 : 0,
      color: tileConfig.tileType == TileType.ghost
          ? colors.$1.withAlpha(100)
          : colors.$1,
      child: Center(
        child: tileConfig.tileType != TileType.ghost
            ? Text(
                event.eventData?.title ?? "No data",
                style: TextStyle(color: colors.$2),
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
          ? colors.$2.withAlpha(100)
          : colors.$2,
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(
                event.eventData?.title ?? 'No data',
                style: TextStyle(color: colors.$2),
              )
            : null,
      ),
    );
  }

  Widget _scheduleTileBuilder(
    CalendarEvent<EventData> event,
    DateTime date,
    BuildContext context,
  ) {
    final colors = getColors(event, context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        event.eventData?.title ?? 'No data',
        style: TextStyle(color: colors.$2),
      ),
    );
  }
}
