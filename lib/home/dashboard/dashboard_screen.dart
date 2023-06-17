import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/manage_cards.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

DashboardCard? getCardFromId(String cardId) =>
    cards.where((element) => element.cardId == cardId).firstOrNull;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<DashboardCard> cardsToDisplay;

  @override
  void initState() {
    super.initState();
    onCardsChange();
    Prefs.cardsToDisplay.addListener(onCardsChange);
  }

  onCardsChange() {
    setState(() {
      cardsToDisplay = Prefs.cardsToDisplay.value
          .map((e) => getCardFromId(e))
          .where((e) => e != null)
          .cast<DashboardCard>()
          .toList();
    });
  }

  @override
  void dispose() {
    Prefs.cardsToDisplay.removeListener(onCardsChange);
    super.dispose();
  }

  List<Widget> resultsToWidgets(List<dynamic> results) {
    if (results.isEmpty) {
      return [];
    }
    final List<Widget> widgets = [];
    int index = 0;
    try {
      for (var element in cardsToDisplay) {
        if (element.future == null) {
          widgets.add(element.card(null));
        } else {
          final widget = element.card(results[index]);
          index++;
          widgets.add(widget);
        }
      }
    } catch (e) {
      return [];
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final futures = cardsToDisplay
        .where((e) => e.future != null)
        .map((e) => e.future!())
        .cast<Future<dynamic>>();

    return FutureBuilder(
        future: Future.wait(futures),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.topLeft,
              child: LinearProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: [
                ...resultsToWidgets(snapshot.data!),
                ManageCardsButton(),
              ],
            ),
          );
        });
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
                    Logger("dashboard").debug("saving cards $cardsToDisplay");
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
