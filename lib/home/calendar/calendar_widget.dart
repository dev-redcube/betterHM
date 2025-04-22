import 'package:better_hm/home/calendar/calendar_configuration.dart';
import 'package:better_hm/home/calendar/components/event_tiles.dart';
import 'package:better_hm/home/calendar/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.controller,
    required this.eventsController,
  });

  final CalendarController<Event> controller;
  final EventsController<Event> eventsController;

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

  TileComponents<Event> get _tileComponents {
    return TileComponents<Event>(
      tileBuilder: EventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: _dragAnchorStrategy,
    );
  }

  TileComponents<Event> get _multiDayTileComponents {
    return TileComponents<Event>(
      tileBuilder: MultiDayEventTile.builder,
      overlayTileBuilder: OverlayEventTile.builder,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: _dragAnchorStrategy,
    );
  }

  CalendarCallbacks<Event> get _callbacks {
    return CalendarCallbacks<Event>(
      onEventTapped: (event, renderBox) => {},
      onEventCreate:
          (event) => event.copyWith(data: const Event(title: 'New Event')),
      onEventCreated: (event) => widget.eventsController.addEvent(event),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView<Event>(
      calendarController: widget.controller,
      eventsController: widget.eventsController,
      viewConfiguration: _configuration.viewConfiguration,
      callbacks: _callbacks,
      header: CalendarHeader<Event>(
        multiDayTileComponents: _multiDayTileComponents,
        multiDayHeaderConfiguration: _configuration.multiDayHeaderConfiguration,
        interaction: _configuration.interactionHeader,
      ),
      body: CalendarBody<Event>(
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
