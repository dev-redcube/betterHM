import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final bool usePrimaryColor;

  const DashboardCard({
    super.key,
    required this.child,
    this.onTap,
    this.usePrimaryColor = false,
  });

  Widget buildChild(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: usePrimaryColor
          ? context.theme.colorScheme.primaryContainer.withOpacity(0.5)
          : context.theme.colorScheme.secondaryContainer.withOpacity(0.5),
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
