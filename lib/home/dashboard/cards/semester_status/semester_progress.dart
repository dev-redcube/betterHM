import 'dart:ui' as ui;

import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_date_time.dart';
import 'package:better_hm/shared/models/date_tuple.dart';
import 'package:better_hm/shared/models/range.dart';
import 'package:flutter/material.dart';

class SemesterProgress extends StatelessWidget {
  SemesterProgress({super.key, required this.date})
      : assert(date.end != null, "Needs a DateTuple with start and end");

  final DateTuple date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: CustomPaint(
        painter: SemesterProgressPainter(
          dateTuple: date,
          theme: context.theme,
        ),
      ),
    );
  }
}

class SemesterProgressPainter extends CustomPainter {
  final DateTuple dateTuple;
  final ThemeData theme;
  late final Color textColor;
  late double middleMarkerOffsetX;

  final double barHeight = 10;
  final barOffsetY = 20.0;

  SemesterProgressPainter({
    required this.dateTuple,
    required this.theme,
  })  : textColor = theme.textTheme.bodyMedium!.color!,
        assert(dateTuple.end != null,
            "Painter needs a DateTuple with start and end");

  setMiddleOffsetX(Size size) {
    final difference = dateTuple.end!.difference(dateTuple.start).inDays;
    final diffToday = today().difference(dateTuple.start).inDays;
    final offsetPercent = diffToday / difference;
    middleMarkerOffsetX = offsetPercent * size.width;
  }

  void drawBar(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, barOffsetY),
        Offset(size.width, barOffsetY + barHeight),
      ),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(size.width, 0),
          [Colors.green.shade400, Colors.red.shade400],
        ),
    );
  }

  void drawMarkers(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = textColor;
    const markerWidth = 2.0;
    canvas.drawRect(
      Rect.fromPoints(Offset(0, barOffsetY - 5),
          Offset(markerWidth, barOffsetY + barHeight)),
      paint,
    );

    canvas.drawRect(
        Rect.fromPoints(Offset(size.width - markerWidth, barOffsetY - 5),
            Offset(size.width, barOffsetY + barHeight)),
        paint);

    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(middleMarkerOffsetX, barOffsetY + barHeight / 2),
            width: markerWidth * 2,
            height: barHeight + 10),
        paint);
  }

  drawLabels(Canvas canvas, Size size) {
    final labelStart = TextPainter(
      text: TextSpan(
        text: dateTuple.start.formatdMonthAbbr,
        style: theme.textTheme.bodyMedium,
      ),
      textDirection: ui.TextDirection.ltr,
    );
    labelStart.layout(minWidth: 0, maxWidth: size.width / 2);
    labelStart.paint(
      canvas,
      Offset(0, barOffsetY - labelStart.height - 10),
    );

    final labelEnd = TextPainter(
      text: TextSpan(
        text: dateTuple.end!.formatdMonthAbbr,
        style: theme.textTheme.bodyMedium,
      ),
      textDirection: ui.TextDirection.ltr,
    );
    labelEnd.layout(minWidth: 0, maxWidth: size.width / 2);
    labelEnd.paint(
      canvas,
      Offset(size.width - labelEnd.width, barOffsetY - labelStart.height - 10),
    );

    final labelMiddle = TextPainter(
      text: TextSpan(
        text: today().formatdMonthAbbr,
        style: theme.textTheme.bodyMedium,
      ),
      textDirection: ui.TextDirection.ltr,
    );
    labelMiddle.layout(minWidth: 0, maxWidth: size.width / 2);
    double mo = middleMarkerOffsetX - labelMiddle.width / 2;
    mo = putInRange(mo, Range(0, size.width - labelMiddle.width));

    labelMiddle.paint(
      canvas,
      Offset(mo, barOffsetY + barHeight + 10),
    );
  }

  double putInRange(double value, Range range) {
    if (value < range.min) return range.min;
    if (value > range.max) return range.max;
    return value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    setMiddleOffsetX(size);

    drawBar(canvas, size);
    drawMarkers(canvas, size);
    drawLabels(canvas, size);
    // final barOffsetX = size.width * percentage;
    //
    // // label start
    // final labelStart = TextPainter(
    //   text: TextSpan(text: start.formatDayMonthAbbr),
    //   textDirection: ui.TextDirection.ltr,
    // );
    // labelStart.layout(minWidth: 0, maxWidth: size.width / 2);
    // labelStart.paint(canvas, Offset.zero);
    // // label end
    // final labelEnd = TextPainter(
    //   text: TextSpan(text: end.formatDayMonthAbbr),
    //   textDirection: ui.TextDirection.ltr,
    // );
    // labelEnd.layout(minWidth: 0, maxWidth: size.width / 2);
    // labelEnd.paint(canvas, Offset(size.width - labelEnd.width, 0));
    //
    // final rectOffsetY = max(labelStart.height, labelEnd.height) + 10;
    //
    // canvas.drawRect(
    //   Rect.fromPoints(
    //     Offset(0, rectOffsetY),
    //     Offset(size.width, rectOffsetY + barHeight),
    //   ),
    //   Paint()
    //     ..shader = ui.Gradient.linear(
    //       Offset.zero,
    //       Offset(size.width, 0),
    //       [Colors.green, Colors.red],
    //     ),
    // );
    //
    // final linePaint = Paint()
    //   ..strokeWidth = 2
    //   ..color = Colors.white;
    //
    // canvas.drawLine(
    //   Offset(linePaint.strokeWidth / 2, rectOffsetY - 5),
    //   Offset(linePaint.strokeWidth / 2, rectOffsetY + barHeight),
    //   linePaint,
    // );
    // canvas.drawLine(
    //   Offset(size.width - linePaint.strokeWidth / 2, rectOffsetY - 5),
    //   Offset(size.width - linePaint.strokeWidth / 2, rectOffsetY + barHeight),
    //   linePaint,
    // );
    // canvas.drawLine(
    //   Offset(barOffsetX, rectOffsetY - 5),
    //   Offset(barOffsetX, rectOffsetY + barHeight + 5),
    //   linePaint..strokeWidth = 4,
    // );
    //
    // final label = TextPainter(
    //   text: TextSpan(text: today.formatDayMonthAbbr),
    //   textDirection: ui.TextDirection.ltr,
    // );
    // label.layout(minWidth: 0, maxWidth: size.width);
    // label.paint(canvas,
    //     Offset(barOffsetX - label.width / 2, rectOffsetY + barHeight + 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// class SemesterProgressBar extends StatelessWidget {
//   SemesterProgressBar({
//     Key? key,
//     required this.start,
//     required this.end,
//   }) : super(key: key);
//
//   final DateTime start;
//   final DateTime end;
//   final DateTime now = today();
//
//   @override
//   Widget build(BuildContext context) {
//     final daysOfSemester = end.difference(start).inDays.abs();
//     final daysSinceStart = now.difference(start).inDays.abs();
//     final percentage = daysSinceStart / daysOfSemester;
//
//     return SizedBox(
//       height: 70,
//       child: CustomPaint(
//         painter: SemesterProgressPainter(
//           start: start,
//           end: end,
//           today: now,
//           percentage: percentage,
//         ),
//       ),
//     );
//   }
// }
