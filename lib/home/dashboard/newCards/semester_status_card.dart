import 'package:better_hm/home/dashboard/icard.dart';
import 'package:flutter/material.dart';

class SemesterStatusCard extends ICard {
  @override
  Widget render(data) => const Text("Semester Status");

  @override
  Widget? renderConfig(int cardIndex) => null;
}
