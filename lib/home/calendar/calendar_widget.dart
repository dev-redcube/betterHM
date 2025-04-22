import 'package:better_hm/home/calendar/calendar_configuration.dart';
import 'package:better_hm/home/calendar/components/event_tiles.dart';
import 'package:better_hm/home/calendar/models/event_data.dart';
import 'package:better_hm/main.dart';
import 'package:better_hm/shared/service/event_service.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.controller,
    required this.eventsController,
  });

  final CalendarController<EventData> controller;
  final EventsController<EventData> eventsController;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final _configuration = CalendarConfiguration();

  Offset _dragAnchorStrategy(
    Draggable draggable,
    BuildContext context,
    Offset position,
  ) {
    final renderObject = context.findRenderObject()! as RenderBox;
    return Offset(20, renderObject.size.height / 2);
  }

  TileComponents<EventData> get _tileComponents {
    return TileComponents<EventData>(
      tileBuilder: EventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: _dragAnchorStrategy,
    );
  }

  TileComponents<EventData> get _multiDayTileComponents {
    return TileComponents<EventData>(
      tileBuilder: MultiDayEventTile.builder,
      overlayTileBuilder: OverlayEventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: _dragAnchorStrategy,
    );
  }

  CalendarCallbacks<EventData> get _callbacks {
    return CalendarCallbacks<EventData>(
      onEventTapped: (event, renderBox) => {},
      onEventCreate:
          (event) => event.copyWith(
            data: EventData(
              title: 'New Event',
              start: event.start,
              end: event.end,
            ),
          ),
      onEventCreated: (event) => getIt<EventService>().addEvent(event),
      onEventChanged:
          (event, updatedEvent) =>
              getIt<EventService>().updateEvent(event, updatedEvent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView<EventData>(
      calendarController: widget.controller,
      eventsController: widget.eventsController,
      viewConfiguration: _configuration.viewConfiguration,
      callbacks: _callbacks,
      header: CalendarHeader<EventData>(
        multiDayTileComponents: _multiDayTileComponents,
        multiDayHeaderConfiguration: _configuration.multiDayHeaderConfiguration,
        interaction: _configuration.interactionHeader,
      ),
      body: CalendarBody<EventData>(
        multiDayTileComponents: _tileComponents,
        monthTileComponents: _multiDayTileComponents,
        multiDayBodyConfiguration: _configuration.multiDayBodyConfiguration,
        monthBodyConfiguration: _configuration.monthBodyConfiguration,
        interaction: _configuration.interactionBody,
        snapping: _configuration.snapping,
      ),
    );
  }
}
