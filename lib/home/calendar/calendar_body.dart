import 'package:animations/animations.dart';
import 'package:better_hm/home/calendar/detail_screen.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icalendar/icalendar.dart';
import 'package:kalender/kalender.dart';

final calendarController = CalendarController<EventComponent>();
final eventsController = CalendarEventsController<EventComponent>();

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
    CalendarEvent<EventComponent> event,
    BuildContext context,
  ) {
    final color = context.theme.colorScheme.primaryContainer;
    final Color textColor = context.theme.colorScheme.onPrimaryContainer;
    return (color, textColor);
  }

  Widget _tileBuilder(
    CalendarEvent<EventComponent> event,
    TileConfiguration configuration,
    BuildContext context,
  ) {
    final colors = getColors(event, context);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: OpenContainer(
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
        closedColor: colors.$1,
        closedElevation: 0,
        useRootNavigator: true,
        openBuilder: (context, action) {
          return CalendarDetailScreen(event: event);
        },
        closedBuilder: (context, action) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.zero,
            elevation: 0,
            color: configuration.tileType != TileType.ghost
                ? colors.$1
                : colors.$1.withAlpha(100),
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: configuration.tileType != TileType.ghost
                  ? Text(
                      event.eventData?.summary?.value.value ?? "No title",
                      style: TextStyle(color: colors.$2),
                      softWrap: true,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<EventComponent> event,
    MultiDayTileConfiguration configuration,
    BuildContext context,
  ) {
    final colors = getColors(event, context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: OpenContainer(
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        closedColor: colors.$1,
        closedElevation: 0,
        useRootNavigator: true,
        openBuilder: (context, action) {
          return CalendarDetailScreen(event: event);
        },
        closedBuilder: (context, action) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: colors.$1),
            ),
            margin: EdgeInsets.zero,
            elevation: configuration.tileType == TileType.selected ? 8 : 0,
            color: configuration.tileType == TileType.ghost
                ? colors.$1.withAlpha(100)
                : colors.$1,
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: configuration.tileType != TileType.ghost
                    ? Text(
                        event.eventData?.summary?.value.value ?? "No title",
                        // style: TextStyle(color: colors.$2),
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: colors.$2,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _scheduleTileBuilder(
      CalendarEvent<EventComponent> event, DateTime date) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(event.eventData?.summary?.value.value ?? 'No title'),
    );
  }
}
