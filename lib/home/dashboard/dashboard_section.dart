import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const DashboardSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: context.theme.colorScheme.primary,
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
