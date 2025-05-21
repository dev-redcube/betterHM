import 'package:flutter/material.dart';
import 'package:redcube_campus/i18n/strings.g.dart';
import 'package:redcube_campus/settings/settings_screen.dart';
import 'package:redcube_campus/settings/settings_switch.dart';
import 'package:redcube_campus/shared/prefs.dart';

class MealplanSettingsSection extends StatelessWidget {
  const MealplanSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: SettingsScreen.initiallyExpanded,
      leading: const Icon(Icons.restaurant_rounded),
      title: Text(t.settings.mealplan.title),
      shape: Border.all(color: Colors.transparent),
      children: [
        SettingsSwitch(
          title: t.settings.mealplan.showFoodLabels,
          pref: Prefs.showFoodLabels,
        ),
      ],
    );
  }
}
