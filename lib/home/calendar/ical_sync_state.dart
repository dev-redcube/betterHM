import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ical_sync_state.g.dart';

enum ICalSyncProgressEnum { idle, inProgress, done }

class ICalSyncState {
  final ICalSyncProgressEnum syncProgress;
  final double progressInPercent;

  ICalSyncState({required this.syncProgress, this.progressInPercent = 0});
}

@riverpod
class ICalSyncStateNotifier extends _$ICalSyncStateNotifier {
  @override
  Future<ICalSyncState> build() async {
    final syncState = ICalSyncState(syncProgress: ICalSyncProgressEnum.idle);
    return Future.value(syncState);
  }

  // TODO queue

  Future<void> sync([Calendar? calendar]) async {
    // Prevent multiple simultaneous syncs
    if (state.value?.syncProgress == ICalSyncProgressEnum.inProgress) {
      return;
    }
    state = AsyncValue.data(
      ICalSyncState(syncProgress: ICalSyncProgressEnum.inProgress),
    );

    final icalSyncService = ICalService(updateCalendarController: true);

    if (calendar == null) {
      await icalSyncService.sync(
        onSyncProgress: (synced, total) {
          state = AsyncValue.data(
            ICalSyncState(
              syncProgress: ICalSyncProgressEnum.inProgress,
              progressInPercent: synced / total,
            ),
          );
        },
      );
    } else {
      await icalSyncService.syncSingle(calendar);
    }
    state = AsyncValue.data(
      ICalSyncState(
        syncProgress: ICalSyncProgressEnum.done,
        progressInPercent: 1,
      ),
    );
  }
}
