import 'package:better_hm/home/dashboard/card_config.dart';
import 'package:flutter/material.dart';

class SemesterStatusCard extends CardConfig {
  SemesterStatusCard(super.config);

  @override
  Widget render(data) => const Text("Semester Status");

  static const Map<String, String> defaultConfig = {};
}
