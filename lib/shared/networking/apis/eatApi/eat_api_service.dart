import 'package:better_hm/shared/extensions/extensions_date_time.dart';

sealed class EatApiService {}

class EatApiServiceCanteens extends EatApiService {}

class EatApiServiceLanguages extends EatApiService {}

class EatApiServiceLabels extends EatApiService {}

class EatApiServiceAll extends EatApiService {}

class EatApiServiceAllRef extends EatApiService {}

class EatApiServiceMenu extends EatApiService {
  final String location;
  final int year;
  final int week;

  EatApiServiceMenu({required this.location, int? year, int? week})
      : year = year ?? DateTime.now().year,
        week = week ?? DateTime.now().weekNumber;
}
