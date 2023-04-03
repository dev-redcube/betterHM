import 'package:better_hm/models/meal/canteen.dart';

abstract class CanteenState {}

class CanteensLoading extends CanteenState {}

class CanteensInitial extends CanteenState {}

class CanteensFetched extends CanteenState {
  final List<Canteen> canteens;

  CanteensFetched({required this.canteens});
}

class CanteensFetchedFromCache extends CanteenState {
  final List<Canteen> canteens;

  CanteensFetchedFromCache({required this.canteens});
}

class CanteensError extends CanteenState {
  final String error;

  CanteensError({required this.error});
}
