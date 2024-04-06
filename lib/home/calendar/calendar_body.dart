import 'package:animations/animations.dart';
import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/detail_screen.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/models/event_data.dart';
import 'package:better_hm/shared/prefs.dart';
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

final List<ViewConfiguration> calendarViewConfigurations = [
  DayConfiguration(),
  WorkWeekConfiguration(),
  MonthConfiguration(),
];

class _CalendarBodyState extends ConsumerState<CalendarBody> {
  @override
  void initState() {
    super.initState();
    Prefs.calendarViewConfiguration.addListener(_setViewConfiguration);
  }

  late ViewConfiguration currentViewConfiguration =
      calendarViewConfigurations[Prefs.calendarViewConfiguration.value];

  _setViewConfiguration() {
    setState(() {
      currentViewConfiguration =
          calendarViewConfigurations[Prefs.calendarViewConfiguration.value];
    });
  }

  @override
  void dispose() {
    Prefs.calendarViewConfiguration.removeListener(_setViewConfiguration);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      controller: calendarController,
      eventsController: eventsController,
      viewConfiguration: currentViewConfiguration,
      tileBuilder: (event, config) => _tileBuilder(event, config, context),
      multiDayTileBuilder: (event, config) =>
          _multiDayTileBuilder(event, config, context),
      scheduleTileBuilder: _scheduleTileBuilder,
    );
  }

  (Color, Color) getColors(
    CustomCalendarEvent event,
    BuildContext context,
  ) {
    final color =
        event.eventData?.color ?? context.theme.colorScheme.primaryContainer;

    late final Color textColor;
    if (event.eventData?.color != null) {
      textColor = event.eventData!.color!.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
    } else {
      textColor = context.theme.colorScheme.onPrimaryContainer;
    }
    return (color, textColor);
  }

  Widget _tileBuilder(
    CustomCalendarEvent event,
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
        openColor: context.theme.colorScheme.background,
        closedElevation: 0,
        useRootNavigator: true,
        openBuilder: (context, action) {
          return CalendarDetailScreen(
            key: ObjectKey(event),
            event: event,
          );
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
                      event.eventData?.component.summary?.value.value ??
                          "No title",
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
    CustomCalendarEvent event,
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
        openColor: context.theme.colorScheme.background,
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
                        event.eventData?.component.summary?.value.value ??
                            "No title",
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
    CustomCalendarEvent event,
    DateTime date,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          Text(event.eventData?.component.summary?.value.value ?? 'No title'),
    );
  }
}
