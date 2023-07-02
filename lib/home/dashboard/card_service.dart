import 'dart:convert';

import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/home/dashboard/newCards/next_departures_card.dart';
import 'package:better_hm/home/dashboard/newCards/semester_status_card.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/cupertino.dart';

class CardService extends ValueNotifier<CardsList> {
  static final CardService _instance = CardService._internal();

  CardService._internal() : super(_loadCards());

  factory CardService() => _instance;

  static CardsList _loadCards() {
    final List<String> raw = Prefs.cards.value;

    return raw.map((e) => jsonDecode(e)).cast<Map<String, dynamic>>().map((e) {
      final config = e["config"];
      return getCardFromType(CardType.fromString(e["type"]),
          config == null ? null : CardConfig.from(e["config"]));
    }).toList();
  }

  _saveCards() {
    List<String> c = value
        .map((e) => {"type": e.item1.toString(), "config": e.item2.config})
        .map((e) => jsonEncode(e))
        .toList();
    Prefs.cards.value = c;
  }

  addCard(CardWithType card) {
    value.add(card);
    notifyListeners();
    _saveCards();
  }

  removeCardAt(int index) {
    value.removeAt(index);
    notifyListeners();
    _saveCards();
  }

  replaceCardAt(int index, CardWithType card) {
    value[index] = card;
    notifyListeners();
    _saveCards();
  }

  moveCard(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = value.removeAt(oldIndex);
    value.insert(newIndex, item);
    notifyListeners();
    _saveCards();
  }

  static CardWithType getCardFromType(CardType type, [CardConfig? config]) {
    return switch (type) {
      CardType.semesterStatus => Tuple(type, SemesterStatusCard()),
      CardType.nextDepartures =>
        Tuple(type, NextDeparturesCard()..config = config),
    };
  }
}
