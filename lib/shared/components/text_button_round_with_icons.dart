import 'package:flutter/material.dart';

class TextButtonRoundWithIcons extends StatelessWidget {
  const TextButtonRoundWithIcons({
    super.key,
    required this.onPressed,
    this.left,
    required this.text,
    this.right,
  });

  final void Function() onPressed;
  final Widget? left;
  final String text;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(12, 2, 2, 2),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Row(
        children: [
          if (left != null) left!,
          if (left != null) const SizedBox(width: 6),
          Text(
            text,
            overflow: TextOverflow.clip,
          ),
          if (right != null) const SizedBox(width: 4),
          if (right != null) right!,
        ],
      ),
    );
  }
}
