import 'package:better_hm/components/dashboard/dashboard_card.dart';
import 'package:better_hm/components/dashboard/semester_status/semester_status.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: const [
          DashboardCard(child: SemesterStatus()),
        ],
      ),
    );
  }
}
