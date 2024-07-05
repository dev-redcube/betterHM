import 'package:animations/animations.dart';
import 'package:better_hm/home/calendar/calendar_service.dart';
import 'package:better_hm/home/calendar/detail_screen.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.event,
    required this.configuration,
    required this.colors,
  });

  final CustomCalendarEvent event;
  final TileConfiguration configuration;

  final (Color, Color) colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: OpenContainer(
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
        closedColor: colors.$1,
        openColor: context.theme.colorScheme.surface,
        closedElevation: 0,
        useRootNavigator: true,
        openBuilder: (context, action) {
          return CalendarDetailScreen(
            key: ObjectKey(event),
            event: event,
          );
        },
        closedBuilder: (context, action) {
          return Container(
            padding: const EdgeInsets.only(left: 6, top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: configuration.tileType != TileType.ghost
                  ? colors.$1
                  : colors.$1.withAlpha(100),
              border: configuration.drawOutline
                  ? Border.all(
                      color: context.theme.colorScheme.surface,
                      width: 2,
                    )
                  : null,
            ),
            margin: EdgeInsets.zero,
            child: configuration.tileType != TileType.ghost
                ? Text(
                    event.eventData?.component.summary?.value.value ??
                        "No title",
                    style: context.theme.textTheme.bodySmall
                        ?.copyWith(color: colors.$2),
                    softWrap: true,
                  )
                : null,
          );
        },
      ),
    );
  }
}
