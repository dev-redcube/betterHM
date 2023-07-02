import 'package:better_hm/home/dashboard/icard.dart';
import 'package:flutter/material.dart';

class NextDeparturesCard extends ICard {
  NextDeparturesCard(super.config);

  @override
  Widget render(data) => const Text("Next Departures");

  static const Map<String, String> defaultConfig = {};
}
