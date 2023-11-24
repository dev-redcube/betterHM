import 'dart:async';

import 'package:better_hm/home/calendar/event_provider.dart';
import 'package:better_hm/shared/models/event_data.dart';
import 'package:kalender/kalender.dart';

class CalendarService {
  // Future<List<CalendarEvent>> fetchEvents() {
  //   final mainApi = getIt<MainApi>();
  //
  // }

  Stream<List<CalendarEvent<EventData>>> fetchEventproviders(
    List<EventProvider> providers,
  ) {
    final stream = StreamController<List<CalendarEvent<EventData>>>();

    for (final provider in providers) {
      provider.getEvents().then((value) => stream.sink.add(value));
    }

    return stream.stream;
  }
}
