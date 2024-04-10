import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/settings/settings_switch.dart';
import 'package:better_hm/shared/background_service/calendar_background_service.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';

class CalendarSettingsSection extends StatelessWidget {
  const CalendarSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: SettingsScreen.initiallyExpanded,
      leading: const Icon(Icons.event_rounded),
      title: Text(t.settings.calendar.title),
      shape: Border.all(color: Colors.transparent),
      children: [
        SettingsSwitch(
          title: t.settings.calendar.onlySyncOnWifi,
          pref: Prefs.calendarOnlySyncOnWifi,
          afterChange: (value) {
            setupCalendarBackgroundService(force: true);
          },
        ),
      ],
    );
  }
}
