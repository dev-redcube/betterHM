import 'package:better_hm/home/dashboard/cards/card_config.dart';
import 'package:flutter/material.dart';

final cards = <CardType, CardConfig>{
  CardType.semesterStatus: CardConfig(
    cardType: CardType.semesterStatus,
    widget: () => const Text("SEMESTER STATUS"),
  ),
  CardType.nextDepartures: CardConfig(
    cardType: CardType.nextDepartures,
    widget: () => const Text("NEXT_DEPARTURES"),
  ),
};

enum CardType {
  semesterStatus,
  nextDepartures;

  String serialize() => name;

  static CardType deserialize(String string) => values.byName(string);
}
