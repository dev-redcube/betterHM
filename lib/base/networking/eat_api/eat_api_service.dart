import 'package:better_hm/canteenComponent/models/canteen.dart';

sealed class EatApiService {}

class EatApiServiceCanteens extends EatApiService {}

class EatApiServiceCombinedMenu extends EatApiService {
  final Canteen canteen;

  EatApiServiceCombinedMenu({required this.canteen});
}
