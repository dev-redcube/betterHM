import 'package:better_hm/blocs/canteen/canteen_event.dart';
import 'package:better_hm/blocs/canteen/canteen_state.dart';
import 'package:better_hm/exceptions/api/api_exception.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:better_hm/services/api/api_canteen.dart';
import 'package:better_hm/services/cache/cache_canteen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanteenBloc extends Bloc<CanteenEvent, CanteenState> {
  final ApiCanteen apiCanteen;
  final CacheCanteenService cacheService;

  CanteenBloc({required this.apiCanteen, required this.cacheService})
      : super(CanteensInitial()) {
    on<FetchCanteens>(_onFetchCanteens);
  }

  Future<void> _onFetchCanteens(
      FetchCanteens event, Emitter<CanteenState> emit) async {
    emit(CanteensLoading());
    try {
      List<Canteen>? cacheCanteens = cacheService.getCanteens();

      if (cacheCanteens != null && cacheCanteens.isNotEmpty) {
        emit(CanteensFetchedFromCache(canteens: cacheCanteens));
      }

      List<Canteen> canteens = await apiCanteen.getCanteens();
      emit(CanteensFetched(canteens: canteens));

      // TODO upsert canteens
    } on ApiException catch (e) {
      emit(CanteensError(error: "${e.statusCode}: ${e.message}"));
    } catch (e) {}
  }
}
