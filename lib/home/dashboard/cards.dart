import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/mvg/departure.dart';
import 'package:better_hm/home/dashboard/mvg/next_departures.dart';
import 'package:better_hm/home/dashboard/mvg/service/api_mvg.dart';
import 'package:better_hm/home/dashboard/semester_status/api_semester_status.dart';
import 'package:better_hm/home/dashboard/semester_status/models/semester_event.dart';
import 'package:better_hm/home/dashboard/semester_status/semester_status.dart';
import 'package:better_hm/i18n/strings.g.dart';

final cards = <DashboardCard>{
  DashboardCard<List<SemesterEvent>>(
    title: t.dashboard.statusCard.title,
    cardType: CardType.semesterStatus,
    card: (events) => SemesterStatus(events: events),
    future: () => ApiSemesterStatus().getEvents(),
  ),
  DashboardCard<List<Departure>>(
    title: t.dashboard.mvg.title,
    cardType: CardType.nextDepartures,
    card: (departures) => NextDepartures(departures: departures),
    future: () =>
        ApiMvg().getDepartures(stopId: stopIdLothstr, lineIds: lineIdsLothstr),
  ),
};

enum CardType {
  unknown,
  semesterStatus,
  nextDepartures,
}
