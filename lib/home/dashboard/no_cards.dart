import 'dart:math';

import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class NoCardsPlaceholder extends StatelessWidget {
  const NoCardsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("HELLO"),
        const SizedBox(height: 20),
        SizedBox(
          height: 60,
          width: 300,
          child: CustomPaint(painter: _ArrowPainter(context.theme)),
        ),
      ],
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final ThemeData theme;

  _ArrowPainter(this.theme);

  get color => theme.colorScheme.onSurface;

  double middle(Size size) => size.width / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      // middle arrow
      ..moveTo(middle(size), 0)
      ..lineTo(middle(size), size.height)
      ..moveTo(middle(size) - 10, size.height - 10)
      ..lineTo(middle(size), size.height)
      ..moveTo(middle(size) + 10, size.height - 10)
      ..lineTo(middle(size), size.height);
    // left arrow
    // ..moveTo(0, 10)
    // ..lineTo(20, size.height)
    // ..moveTo(x, y)
    // ..lineTo(20, size.height);

    drawArrow(Point(middle(size), 0), Point(middle(size), size.height), canvas);

    drawArrow(const Point(0, 10), Point(20, size.height), canvas);
  }

  drawArrow(Point<double> p1, Point<double> p2, Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(p1.x, p1.y)
      ..lineTo(p2.x, p2.y);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
