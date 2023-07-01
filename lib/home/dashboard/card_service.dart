import 'dart:convert';

import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/newCards/next_departures_card.dart';
import 'package:better_hm/home/dashboard/newCards/semester_status_card.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:flutter/cupertino.dart';

// TODO real save and load
class CardService extends ValueNotifier<CardsList> {
  static final CardService _instance = CardService._internal();

  CardService._internal() : super(loadCards());

  factory CardService() => _instance;

  static CardsList loadCards() =>
      tempCards.map((e) => getCardFromType(e.item1)).toList();

  addCard(CardWithType card) {
    value.add(card);
    notifyListeners();
  }

  removeCardAt(int index) {
    value.removeAt(index);
    notifyListeners();
  }

  moveCard(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = value.removeAt(oldIndex);
    value.insert(newIndex, item);
    notifyListeners();
  }

  saveCards(CardsList cards) {
    List<String> c = cards
        .map((e) =>
            {"type": e.item1.toString(), "config": jsonEncode(e.item2.config)})
        .map((e) => jsonEncode(e))
        .toList();
  }

  static CardWithType getCardFromType(CardType type,
      [Map<String, String>? config]) {
    return switch (type) {
      CardType.semesterStatus => Tuple(
          type, SemesterStatusCard(config ?? SemesterStatusCard.defaultConfig)),
      CardType.nextDepartures => Tuple(
          type, NextDeparturesCard(config ?? NextDeparturesCard.defaultConfig)),
    };
  }
}

final List<Tuple<CardType, Map<String, String>>> tempCards = [
  const Tuple(CardType.nextDepartures, {}),
  const Tuple(CardType.semesterStatus, {}),
];
