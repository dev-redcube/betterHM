import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app_name),
        backgroundColor: context.theme.colorScheme.secondaryContainer.withAlpha(
          100,
        ),
        scrolledUnderElevation: 0.0,
      ),
      body: SizedBox.shrink(),
    );
  }
}
