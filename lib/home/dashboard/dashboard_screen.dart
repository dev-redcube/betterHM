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
        ],
      ),
    );
  }
}
