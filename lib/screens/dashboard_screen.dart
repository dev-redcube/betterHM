import 'package:better_hm/components/dashboard/dashboard_card.dart';
import 'package:better_hm/components/dashboard/manage_cards.dart';
import 'package:better_hm/components/dashboard/semester_status/semester_status.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: const [
          DashboardCard(child: SemesterStatus()),
          ManageCardsButton(),
        ],
      ),
    );
  }
}

class ManageCardsButton extends StatelessWidget {
  const ManageCardsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(t.dashboard.cards.manage.title),
              scrollable: false,
              content: const ManageCardsPopup(),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(t.dashboard.cards.manage.cancel),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(t.dashboard.cards.manage.save),
                ),
              ],
            ),
          );
        },
        child: Text(t.dashboard.cards.manage.title),
      ),
    );
  }
}
