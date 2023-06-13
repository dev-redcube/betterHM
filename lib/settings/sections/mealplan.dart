import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/settings_screen.dart';
import 'package:better_hm/settings/settings_switch.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';

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
        )
      ],
    );
  }
}
