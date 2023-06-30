import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/cards/saved_card.dart';
import 'package:flutter/widgets.dart';

class CardConfig extends SavedCard {
  final Widget Function() widget;

  SavedCard get savable => this;

  CardConfig({
    required super.cardType,
    required this.widget,
  });

  factory CardConfig.fromSaved(SavedCard saved) => CardConfig(
        cardType: saved.cardType,
        widget: cards[saved.cardType]!.widget,
      );

  factory CardConfig.fromJson(Map<String, dynamic> json) =>
      CardConfig.fromSaved(SavedCard.fromJson(json));
}
