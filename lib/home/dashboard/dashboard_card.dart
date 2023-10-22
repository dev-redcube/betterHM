import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const DashboardCard({
    super.key,
    required this.child,
    this.onTap,
  });

  Widget buildChild(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.primaryContainer,
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: onTap == null
          ? buildChild(context)
          : InkWell(
              onTap: onTap,
              splashColor: context.theme.colorScheme.primary.withOpacity(0.5),
              child: buildChild(context),
            ),
    );
  }
}
