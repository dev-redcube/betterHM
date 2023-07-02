import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/shared/models/tuple.dart';

typedef CardWithType = Tuple<CardType, ICard>;
typedef CardsList = List<CardWithType>;

enum CardType {
  semesterStatus,
  nextDepartures;

  @override
  String toString() => name;

  static CardType fromString(String string) => values.byName(string);
}
