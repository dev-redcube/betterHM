import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/shared/models/serializable.dart';
import 'package:flutter/material.dart';

class CardConfig implements Serializable {
  final CardType cardType;
  final Map<String, dynamic>? settings;

  CardConfig({
    required this.cardType,
    this.settings,
  });

  @override
  fromJson(Map<String, dynamic> json) => CardConfig(
        cardType: CardType.values.firstWhere(
          (element) => element.name == json["cardType"],
          orElse: () => CardType.unknown,
        ),
        settings: json["settings"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "cardType": cardType.name,
        "settings": settings,
      };
}
