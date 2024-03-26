class EventData {
  final String title;
  final String? description;
  final String calendarId;
  final String? location;

  EventData({
    required this.title,
    this.description,
    required this.calendarId,
    this.location,
  });

  @override
  String toString() =>
      "EventData(title: $title, description: $description, calendarId: $calendarId, location: $location)";
}
