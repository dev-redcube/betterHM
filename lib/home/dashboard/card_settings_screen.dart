import 'package:flutter/material.dart';

class CardSettingsScreen extends StatelessWidget {
  const CardSettingsScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  static const routeName = "cardSettings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure Card"),
      ),
      body: child,
    );
  }
}

class CardConfigScreenWrapper {
  final Widget child;
  final void Function() onSave;

  const CardConfigScreenWrapper({
    required this.child,
    required this.onSave,
  });
}
