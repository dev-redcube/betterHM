import 'package:json_annotation/json_annotation.dart';

part 'calendar_link.g.dart';

@JsonSerializable()
class CalendarLink {
  String name;
  String url;

  CalendarLink({
    required this.name,
    required this.url,
  });

  factory CalendarLink.fromJson(Map<String, dynamic> json) =>
      _$CalendarLinkFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarLinkToJson(this);
}

@JsonSerializable()
class CalendarLinksWrapper {
  @JsonKey(name: "data")
  final List<CalendarLink> links;

  CalendarLinksWrapper({
    required this.links,
  });

  factory CalendarLinksWrapper.fromJson(Map<String, dynamic> json) =>
      _$CalendarLinksWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarLinksWrapperToJson(this);
}
