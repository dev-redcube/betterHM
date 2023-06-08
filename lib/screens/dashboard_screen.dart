import 'package:better_hm/components/dashboard/dashboard_card.dart';
import 'package:better_hm/components/dashboard/manage_cards.dart';
import 'package:better_hm/components/dashboard/semester_status/semester_status.dart';
import 'package:better_hm/dashboard/mvg/next_departures.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/models/string_with_state.dart';
import 'package:better_hm/providers/prefs/prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final dashboardCards = <DashboardCard>[
  DashboardCard(
    title: t.dashboard.statusCard.title,
    cardId: "SEMESTER_STATUS",
    card: const SemesterStatus(),
  ),
  DashboardCard(
    title: t.dashboard.mvg.title,
    cardId: "NEXT_DEPARTURES",
    card: const NextDepartures(),
  )
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Prefs.cardsToDisplay.addListener(onChange);
  }

  onChange() {
    setState(() {});
  }

  @override
  void dispose() {
    Prefs.cardsToDisplay.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          ...Prefs.cardsToDisplay.value.withState
              .where((element) => element.state)
              .map((e) => dashboardCards
                  .firstWhere((element) => element.cardId == e.string)
                  .card)
              .toList(),
          ManageCardsButton(),
        ],
      ),
    );
  }
}

class ManageCardsButton extends StatelessWidget {
  ManageCardsButton({super.key});

  final List<StringWithState> cardPrefs = Prefs.cardsToDisplay.value.withState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(t.dashboard.cards.manage.title),
              scrollable: false,
              content: ManageCardsPopup(
                onModify: (cards) {
                  cardPrefs
                    ..clear()
                    ..addAll(cards);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(t.dashboard.cards.manage.cancel),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                    Prefs.cardsToDisplay.delete();
                    if (kDebugMode) print("SAVING: ${cardPrefs.withoutState}");
                    Prefs.cardsToDisplay.value = cardPrefs.withoutState;
                  },
                  child: Text(t.dashboard.cards.manage.save),
                ),
              ],
            ),
          );
        },
        child: Text(t.dashboard.cards.manage.title),
      ),
    );
  }
}
