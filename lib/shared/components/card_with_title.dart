import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class CardWithTitle extends StatelessWidget {
  const CardWithTitle({
    super.key,
    required this.title,
    required this.child,
    this.cardPadding = const EdgeInsets.all(8.0),
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry cardPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(title, style: context.theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Card(child: Padding(padding: cardPadding, child: child)),
          ),
        ],
      ),
    );
  }
}
