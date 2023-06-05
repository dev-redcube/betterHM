import 'package:flutter/material.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({
    Key? key,
    required this.child,
    this.allowHide = true,
  }) : super(key: key);
  final bool allowHide;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}

class DashboardCard {
  final String title;
  final String cardId;
  final Widget card;

  DashboardCard({
    required this.title,
    required this.cardId,
    required this.card,
  });
}
