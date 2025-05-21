import 'package:flutter/material.dart';
import 'package:redcube_campus/shared/extensions/extensions_context.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final bool usePrimaryColor;
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  const DashboardCard({
    super.key,
    required this.child,
    this.onTap,
    this.usePrimaryColor = false,
    this.height,
    this.width,
    this.padding,
  });

  Widget buildChild(BuildContext context) =>
      Padding(padding: padding ?? const EdgeInsets.all(16), child: child);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        color:
            usePrimaryColor
                ? context.theme.colorScheme.primaryContainer.withAlpha(128)
                : context.theme.colorScheme.secondaryContainer.withAlpha(128),
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        child:
            onTap == null
                ? buildChild(context)
                : InkWell(
                  onTap: onTap,
                  splashColor: context.theme.colorScheme.primary.withAlpha(128),
                  child: buildChild(context),
                ),
      ),
    );
  }
}
