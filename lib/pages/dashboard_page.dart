import 'package:better_hm/components/dashboard/dashboard_card.dart';
import 'package:better_hm/components/dashboard/semester_status.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
