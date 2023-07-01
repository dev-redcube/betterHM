import 'package:better_hm/home/dashboard/card_config.dart';
import 'package:better_hm/shared/models/tuple.dart';

typedef CardWithType = Tuple<CardType, CardConfig>;
typedef CardsList = List<CardWithType>;

enum CardType {
  semesterStatus,
  nextDepartures;

  @override
  String toString() => name;

  static CardType fromString(String string) => values.byName(string);
}
