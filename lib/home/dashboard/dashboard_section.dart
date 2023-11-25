import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardSection extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final Widget? right;

  const DashboardSection({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (right != null) right!,
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class DashboardSectionShimmer extends StatelessWidget {
  final Widget child;

  const DashboardSectionShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        period: const Duration(seconds: 2),
        baseColor:
            context.theme.colorScheme.secondaryContainer.withOpacity(0.5),
        highlightColor: context.theme.colorScheme.primary.withOpacity(0.25),
        child: child,
      );
}
