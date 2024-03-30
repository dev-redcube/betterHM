import 'package:icalendar/icalendar.dart';

extension CalendarId on EventComponent {
  static final _idValueExpando = Expando<String>();

  String? get calendarId => _idValueExpando[this];

  set calendarId(String? value) => _idValueExpando[this] = value;
}
