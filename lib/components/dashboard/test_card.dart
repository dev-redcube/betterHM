import 'package:better_hm/components/dashboard/dashboard_card.dart';
import 'package:flutter/material.dart';

class TestCard extends StatelessWidget {
  const TestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCardWidget(
      child: Text("TESTCARD"),
    );
  }
}
