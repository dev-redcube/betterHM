import 'package:better_hm/models/meal/week.dart';

class CanteenMenu {
  final String canteenId;
  final List<MealWeek> weeks;

  CanteenMenu(this.canteenId, this.weeks);
}
