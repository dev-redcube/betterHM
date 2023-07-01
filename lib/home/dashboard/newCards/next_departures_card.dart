import 'package:better_hm/home/dashboard/card_config.dart';
import 'package:flutter/material.dart';

class NextDeparturesCard extends CardConfig {
  NextDeparturesCard(super.config);

  @override
  Widget render(data) => const Text("Next Departures");

  static const Map<String, String> defaultConfig = {};
}
