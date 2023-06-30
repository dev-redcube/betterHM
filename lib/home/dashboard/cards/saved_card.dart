import 'package:better_hm/home/dashboard/cards.dart';

class SavedCard {
  final CardType cardType;

  SavedCard({
    required this.cardType,
  });

  factory SavedCard.fromJson(Map<String, dynamic> json) => SavedCard(
        cardType: CardType.deserialize(json["cardType"]),
      );

  Map<String, dynamic> toJson() => {
        "cardType": cardType.serialize(),
      };
}
