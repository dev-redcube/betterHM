import 'package:better_hm/home/calendar/models/event_data.dart';
import 'package:flutter/foundation.dart';
import 'package:kalender/kalender.dart';

class CalendarConfiguration extends ChangeNotifier {
  /// The view configuration of the calendar.
  late final viewConfigurationNotifier = ValueNotifier(viewConfigurations[1]);
  ViewConfiguration get viewConfiguration => viewConfigurationNotifier.value;
  set viewConfiguration(ViewConfiguration value) {
    if (viewConfigurationNotifier.value == value) return;
    viewConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The available view configurations of the calendar.
  final viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MonthViewConfiguration.singleMonth(),
  ];

  /// The body configuration of the calendar.
  final multiDayBodyConfigurationNotifier = ValueNotifier(
    MultiDayBodyConfiguration(),
  );
  MultiDayBodyConfiguration get multiDayBodyConfiguration =>
      multiDayBodyConfigurationNotifier.value;
  set multiDayBodyConfiguration(MultiDayBodyConfiguration value) {
    if (multiDayBodyConfigurationNotifier.value == value) return;
    multiDayBodyConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The header configuration of the calendar.
  final multiDayHeaderConfigurationNotifier = ValueNotifier(
    MultiDayHeaderConfiguration<EventData>(),
  );
  MultiDayHeaderConfiguration<EventData> get multiDayHeaderConfiguration =>
      multiDayHeaderConfigurationNotifier.value;
  set multiDayHeaderConfiguration(
    MultiDayHeaderConfiguration<EventData> value,
  ) {
    if (multiDayHeaderConfigurationNotifier.value == value) return;
    multiDayHeaderConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The month body configuration of the calendar.
  final monthBodyConfigurationNotifier = ValueNotifier(
    MultiDayHeaderConfiguration<EventData>(),
  );
  MultiDayHeaderConfiguration<EventData> get monthBodyConfiguration =>
      monthBodyConfigurationNotifier.value;
  set monthBodyConfiguration(MultiDayHeaderConfiguration<EventData> value) {
    if (monthBodyConfigurationNotifier.value == value) return;
    monthBodyConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The header interaction of the calendar.
  late final ValueNotifier<CalendarInteraction> interactionHeader =
      ValueNotifier(
        CalendarInteraction(
          createEventGesture:
              isMobile ? CreateEventGesture.longPress : CreateEventGesture.tap,
        ),
      );

  /// The body interaction of the calendar.
  late final ValueNotifier<CalendarInteraction> interactionBody = ValueNotifier(
    CalendarInteraction(
      createEventGesture:
          isMobile ? CreateEventGesture.longPress : CreateEventGesture.tap,
    ),
  );

  /// The snapping configuration of the calendar.
  final ValueNotifier<CalendarSnapping> snapping = ValueNotifier(
    const CalendarSnapping(),
  );

  /// Whether to show the header of the calendar.
  ValueNotifier<bool> showHeaderNotifier = ValueNotifier(true);
  bool get showHeader => showHeaderNotifier.value;
  set showHeader(bool value) {
    if (showHeaderNotifier.value == value) return;
    showHeaderNotifier.value = value;
    notifyListeners();
  }

  bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CalendarConfiguration) return false;
    return viewConfiguration == other.viewConfiguration &&
        multiDayBodyConfiguration == other.multiDayBodyConfiguration &&
        multiDayHeaderConfiguration == other.multiDayHeaderConfiguration &&
        monthBodyConfiguration == other.monthBodyConfiguration &&
        interactionHeader == other.interactionHeader &&
        interactionBody == other.interactionBody &&
        snapping == other.snapping &&
        showHeader == other.showHeader;
  }

  @override
  int get hashCode => Object.hash(
    viewConfiguration,
    multiDayBodyConfiguration,
    multiDayHeaderConfiguration,
    monthBodyConfiguration,
    interactionHeader,
    interactionBody,
    snapping,
    showHeader,
  );
}
