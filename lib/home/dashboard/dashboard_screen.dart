import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/manage_cards.dart';
import 'package:better_hm/home/dashboard/mvg/next_departures.dart';
import 'package:better_hm/home/dashboard/semester_status/semester_status.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final dashboardCards = <DashboardCard>{
  DashboardCard(
    title: t.dashboard.statusCard.title,
    cardId: "SEMESTER_STATUS",
    card: () => const SemesterStatus(),
  ),
  DashboardCard(
    title: t.dashboard.mvg.title,
    cardId: "NEXT_DEPARTURES",
    card: () => const NextDepartures(),
  )
};

DashboardCard? getCardFromId(String cardId) =>
    dashboardCards.where((element) => element.cardId == cardId).firstOrNull;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> cardsToDisplay = Prefs.cardsToDisplay.value;

  @override
  void initState() {
    super.initState();
    Prefs.cardsToDisplay.addListener(onCardsChange);
  }

  onCardsChange() {
    print("CHANGE");
    setState(() {
      cardsToDisplay = Prefs.cardsToDisplay.value;
    });
  }

  @override
  void dispose() {
    Prefs.cardsToDisplay.removeListener(onCardsChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = cardsToDisplay
        .map((e) => getCardFromId(e)?.card())
        .where((e) => e != null)
        .cast<Widget>()
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          ...cards,
          ManageCardsButton(),
        ],
      ),
    );
  }
}

class ManageCardsButton extends StatelessWidget {
  ManageCardsButton({super.key});

  final List<String> cardsToDisplay = Prefs.cardsToDisplay.value;

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
                  cardsToDisplay
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
                    if (kDebugMode) print("SAVING: $cardsToDisplay");
                    Prefs.cardsToDisplay.value = cardsToDisplay;
                    Prefs.cardsToDisplay.notifyListeners();
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
