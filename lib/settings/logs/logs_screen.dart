import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.advanced.logs.title),
      ),
      body: const Placeholder(),
    );
  }
}
