import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:better_hm/models/meal/canteen.dart';

class SelectedCanteenCubit extends Cubit<Canteen?> {
  SelectedCanteenCubit({Canteen? canteen}) : super(canteen);
  void setCanteen(Canteen? canteen) => emit(canteen);
}
