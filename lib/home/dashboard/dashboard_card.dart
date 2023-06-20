import 'package:flutter/material.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({
    Key? key,
    required this.child,
    this.allowHide = true,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);
  final bool allowHide;

  final EdgeInsetsGeometry padding;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class DashboardCard<T> {
  final String title;
  final String cardId;
  final Widget Function(dynamic) card;
  final Future<T> Function() future;

  DashboardCard({
    required this.title,
    required this.cardId,
    required this.card,
    required this.future,
  });
}
