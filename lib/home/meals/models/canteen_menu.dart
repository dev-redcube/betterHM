import 'package:better_hm/home/meals/models/week.dart';

class CanteenMenu {
  final String canteenId;
  final List<MealWeek> weeks;

  CanteenMenu(this.canteenId, this.weeks);
}
