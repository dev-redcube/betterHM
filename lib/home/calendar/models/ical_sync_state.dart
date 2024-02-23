import 'package:better_hm/home/calendar/models/calendar.dart';
import 'package:cancellation_token/cancellation_token.dart';

enum SyncProgressEnum {
  idle,
  inProgress,
  done,
}

class IcalSyncState {
  final SyncProgressEnum syncProgress;
  final double progressInPercentage;
  final CancellationToken cancelToken;

  final Set<Calendar> calendars;

  const IcalSyncState({
    required this.syncProgress,
    required this.progressInPercentage,
    required this.cancelToken,
    required this.calendars,
  });

  IcalSyncState copyWith({
    SyncProgressEnum? syncProgress,
    double? progressInPercentage,
    CancellationToken? cancelToken,
    Set<Calendar>? calendars,
  }) {
    return IcalSyncState(
      syncProgress: syncProgress ?? this.syncProgress,
      progressInPercentage: progressInPercentage ?? this.progressInPercentage,
      cancelToken: cancelToken ?? this.cancelToken,
      calendars: calendars ?? this.calendars,
    );
  }
}
