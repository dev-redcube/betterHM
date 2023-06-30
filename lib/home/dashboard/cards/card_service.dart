import 'dart:convert';

import 'package:better_hm/home/dashboard/cards/card_config.dart';
import 'package:better_hm/home/dashboard/cards/saved_card.dart';
import 'package:better_hm/shared/prefs.dart';

abstract class CardService {
  static List<CardConfig> getCards(List<String> cards) {
    return cards
        .map((e) => jsonDecode(e))
        .map((e) => CardConfig.fromJson(e))
        .toList();
  }

  static saveCards(List<SavedCard> cards) {
    Prefs.cards.value =
        cards.map((e) => e.toJson()).map((e) => jsonEncode(e)).toList();
  }
}
