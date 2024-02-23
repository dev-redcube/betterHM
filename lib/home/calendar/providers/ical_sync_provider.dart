import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:better_hm/home/calendar/models/ical_sync_state.dart';
import 'package:better_hm/home/calendar/service/ical_sync_service.dart';
import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:state_notifier/state_notifier.dart';

class IcalSyncNotifier extends StateNotifier<IcalSyncState> {
  IcalSyncNotifier(
    this._syncService,
  ) : super(
          IcalSyncState(
            syncProgress: SyncProgressEnum.idle,
            progressInPercentage: 0,
            cancelToken: CancellationToken(),
            calendars: {},
          ),
        );

  final log = Logger("IcalSyncNotifier");
  final IcalSyncService _syncService;
  final Isar _db = Isar.getInstance()!;

  Future<void> startSyncProcess() async {
    debugPrint("Start sync process");
    assert(state.syncProgress == SyncProgressEnum.idle);

    state = state.copyWith(
      syncProgress: SyncProgressEnum.inProgress,
      cancelToken: CancellationToken(),
    );
    final allCalendars =
        await _db.calendars.filter().isActiveEqualTo(true).findAll();

    await _syncService.syncIcal(
      allCalendars,
      state.cancelToken,
      _onSyncDone,
      _onSyncProgress,
    );
  }

  void _onSyncDone() {
    state = state.copyWith(
      syncProgress: SyncProgressEnum.done,
      progressInPercentage: 0.0,
    );
  }

  void _onSyncProgress(int synced, int total) {
    state = state.copyWith(
      progressInPercentage: (synced.toDouble() / total.toDouble()) * 100,
    );
  }

  SyncProgressEnum get syncProgress => state.syncProgress;

  void updateSyncProgress(SyncProgressEnum syncProgress) {
    state = state.copyWith(syncProgress: syncProgress);
  }
}
