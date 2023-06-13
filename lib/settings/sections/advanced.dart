import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdvancedSettingsSection extends StatelessWidget {
  const AdvancedSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      leading: const Icon(Icons.warning_rounded),
      title: Text(t.settings.advanced.title),
      shape: Border.all(color: Colors.transparent),
      children: [
        ListTile(
          title: Text(t.settings.advanced.logs.open),
          trailing: const Icon(Icons.open_in_new_rounded),
          onTap: () {
            context.pushNamed("logs");
          },
        ),
        ListTile(
          title: Text(t.settings.advanced.clearCaches.title),
          onTap: () async {
            await CanteenService().clearCanteens();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.settings.advanced.clearCaches.snackbar),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
