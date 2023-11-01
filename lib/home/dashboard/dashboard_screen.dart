import 'package:better_hm/home/dashboard/sections/kino/kino_section.dart';
import 'package:better_hm/home/dashboard/sections/mvg/mvg_section.dart';
import 'package:better_hm/home/dashboard/student_information.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ListView(
        children: const [
          TopInformation(),
          Divider(),
          MvgSection(),
          KinoSection(),
        ],
      ),
    );
  }
}
