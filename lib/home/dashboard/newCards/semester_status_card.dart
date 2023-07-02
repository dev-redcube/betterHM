import 'package:better_hm/home/dashboard/icard.dart';
import 'package:flutter/material.dart';

class SemesterStatusCard extends ICard {
  SemesterStatusCard(super.config);

  @override
  Widget render(data) => const Text("Semester Status");

  static const Map<String, String> defaultConfig = {};
}
