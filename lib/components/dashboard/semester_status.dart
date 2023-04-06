import 'dart:ui' as ui;

import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/extensions/extensions_date_time.dart';
import 'package:flutter/material.dart';

class SemesterStatus extends StatelessWidget {
  const SemesterStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sommersemester 2023",
            style: context.theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        SemesterProgress(),
      ],
    );
  }
}

class SemesterProgress extends StatelessWidget {
  SemesterProgress({Key? key}) : super(key: key);

  final start = DateTime(2023, 03, 15);
  final end = DateTime(2023, 7, 7);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SemesterProgressBar(
        start: start,
        end: end,
      ),
    );
  }
}

class SemesterProgressBar extends StatelessWidget {
  SemesterProgressBar({
    Key? key,
    required this.start,
    required this.end,
  }) : super(key: key);

  final DateTime start;
  final DateTime end;
  final DateTime now = today();

  @override
  Widget build(BuildContext context) {
    final daysOfSemester = end.difference(start).inDays.abs();
    final daysSinceStart = now.difference(start).inDays.abs();
    final percentage = daysSinceStart / daysOfSemester;

    return SizedBox(
      height: 100,
      child: CustomPaint(
        painter: SemesterProgressPainter(
          start: start,
          end: end,
          today: now,
          percentage: percentage,
        ),
      ),
    );
  }
}

class SemesterProgressPainter extends CustomPainter {
  final double percentage;
  final DateTime start;
  final DateTime end;
  final DateTime today;
  final double barHeight;

  SemesterProgressPainter({
    required this.start,
    required this.end,
    required this.today,
    required this.percentage,
    this.barHeight = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barOffsetLeft = size.width * percentage;

    canvas.drawRect(
      Rect.fromPoints(Offset.zero, Offset(size.width, barHeight)),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(size.width, 0),
          [Colors.green, Colors.red],
        ),
    );
    final linePaint = Paint()
      ..strokeWidth = 4
      ..color = Colors.white;

    canvas.drawLine(
      Offset.zero,
      Offset(0, barHeight),
      linePaint,
    );
    canvas.drawLine(
      Offset(barOffsetLeft, -5),
      Offset(barOffsetLeft, barHeight + 5),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, barHeight),
      linePaint,
    );

    final label = TextPainter(
      text: TextSpan(text: today.formatDayMonth),
      textDirection: ui.TextDirection.ltr,
    );
    label.layout(minWidth: 0, maxWidth: size.width);
    label.paint(
        canvas, Offset(barOffsetLeft - label.width / 2, barHeight + 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
