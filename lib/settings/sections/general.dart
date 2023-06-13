import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_dropdown.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: SettingsScreen.initiallyExpanded,
      leading: const Icon(Icons.app_settings_alt_rounded),
      title: Text(t.settings.general.title),
      shape: Border.all(color: Colors.transparent),
      children: [
        SettingsDropdown(
          title: t.settings.general.initialLocation.title,
          pref: Prefs.initialLocation,
          options: [
            DropdownItem(t.settings.general.initialLocation.dashboard, "/"),
            DropdownItem(t.settings.general.initialLocation.mealplan, "/meals"),
          ],
        ),
      ],
    );
  }
}
