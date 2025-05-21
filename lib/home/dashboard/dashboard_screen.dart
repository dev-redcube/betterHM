import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redcube_campus/home/dashboard/sections/kino/kino_section.dart';
import 'package:redcube_campus/home/dashboard/sections/mvg/mvg_section.dart';
import 'package:redcube_campus/home/dashboard/student_information.dart';
import 'package:redcube_campus/i18n/strings.g.dart';
import 'package:redcube_campus/settings/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              context.pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ListView(
          children: const [
            TopInformation(),
            Divider(),
            MvgSection(),
            KinoSection(),
          ],
        ),
      ),
    );
  }
}
