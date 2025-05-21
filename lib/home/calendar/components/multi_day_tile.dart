import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:redcube_campus/home/calendar/calendar_service.dart';
import 'package:redcube_campus/home/calendar/detail_screen.dart';
import 'package:redcube_campus/shared/extensions/extensions_context.dart';

class MultiDayTile extends StatelessWidget {
  const MultiDayTile({
    super.key,
    required this.event,
    required this.configuration,
    required this.colors,
  });

  final CustomCalendarEvent event;
  final MultiDayTileConfiguration configuration;

  final (Color, Color) colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, right: 4),
      child: OpenContainer(
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        closedColor: colors.$1,
        openColor: context.theme.colorScheme.surface,
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
            color:
                configuration.tileType == TileType.ghost
                    ? colors.$1.withAlpha(100)
                    : colors.$1,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child:
                    configuration.tileType != TileType.ghost
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
}
