import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  const InputContainer({super.key, required this.child, this.color = true});

  final bool color;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color ? context.theme.colorScheme.secondaryContainer : null,
      ),
      child: child,
    );
  }
}
