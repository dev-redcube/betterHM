import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hm_app/models/meal/canteen.dart';

class CanteenCubit extends Cubit<Canteen?> {
  CanteenCubit({Canteen? canteen}) : super(canteen);
  void setCanteen(Canteen canteen) => emit(canteen);
}
