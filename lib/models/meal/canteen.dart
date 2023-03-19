import 'package:hm_app/models/location.dart';

class Canteen {
  final String enumName;
  final String name;
  final String canteenId;
  final Location? location;

  Canteen(this.enumName, this.name, this.canteenId, this.location);
}
