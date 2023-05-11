import 'package:better_hm/models/meal/canteen.dart';
import 'package:flutter/foundation.dart';

class SelectedCanteenProvider with ChangeNotifier {
  Canteen? _canteen;

  Canteen? get canteen => _canteen;

  set canteen(Canteen? canteen) {
    _canteen = canteen;
    notifyListeners();
  }
}
