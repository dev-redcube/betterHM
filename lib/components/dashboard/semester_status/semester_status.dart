import 'dart:math';
import 'dart:ui' as ui;

import 'package:better_hm/components/dashboard/semester_status/deadlines_appointments.dart';
import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/extensions/extensions_date_time.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/models/dashboard/semester_event.dart';
import 'package:better_hm/models/dashboard/semester_event_with_single_date.dart';
import 'package:better_hm/services/api/api_semester_status.dart';
import 'package:flutter/material.dart';

// TODO dynamic data
class SemesterStatus extends StatelessWidget {
  const SemesterStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${t.dashboard.statusCard.summer_semester} 2023",
            style: context.theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        SemesterProgress(),
        const Divider(),
        FutureBuilder<List<SemesterEvent>>(
          future: ApiSemesterStatus().getEvents(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LinearProgressIndicator();
            }
            return DeadlinesAppointments(
                events: convertSemesterEvents(snapshot.data!));
          },
        ),
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
      height: 70,
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
    final barOffsetX = size.width * percentage;

    // label start
    final labelStart = TextPainter(
      text: TextSpan(text: start.formatDayMonthAbbr),
      textDirection: ui.TextDirection.ltr,
    );
    labelStart.layout(minWidth: 0, maxWidth: size.width / 2);
    labelStart.paint(canvas, Offset.zero);
    // label end
    final labelEnd = TextPainter(
      text: TextSpan(text: end.formatDayMonthAbbr),
      textDirection: ui.TextDirection.ltr,
    );
    labelEnd.layout(minWidth: 0, maxWidth: size.width / 2);
    labelEnd.paint(canvas, Offset(size.width - labelEnd.width, 0));

    final rectOffsetY = max(labelStart.height, labelEnd.height) + 10;

    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, rectOffsetY),
        Offset(size.width, rectOffsetY + barHeight),
      ),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(size.width, 0),
          [Colors.green, Colors.red],
        ),
    );

    final linePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.white;

    canvas.drawLine(
      Offset(linePaint.strokeWidth / 2, rectOffsetY - 5),
      Offset(linePaint.strokeWidth / 2, rectOffsetY + barHeight),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width - linePaint.strokeWidth / 2, rectOffsetY - 5),
      Offset(size.width - linePaint.strokeWidth / 2, rectOffsetY + barHeight),
      linePaint,
    );
    canvas.drawLine(
      Offset(barOffsetX, rectOffsetY - 5),
      Offset(barOffsetX, rectOffsetY + barHeight + 5),
      linePaint..strokeWidth = 4,
    );

    final label = TextPainter(
      text: TextSpan(text: today.formatDayMonthAbbr),
      textDirection: ui.TextDirection.ltr,
    );
    label.layout(minWidth: 0, maxWidth: size.width);
    label.paint(canvas,
        Offset(barOffsetX - label.width / 2, rectOffsetY + barHeight + 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
