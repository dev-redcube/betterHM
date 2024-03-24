class EventData {
  final String title;
  final String? description;
  final String? calendarId;

  EventData({
    required this.title,
    this.description,
    this.calendarId,
  });

  @override
  String toString() => "EventData(title: $title, description: $description)";
}
