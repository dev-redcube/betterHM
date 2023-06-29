import 'dart:async';

import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/manage_cards.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/logs/logs_screen.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

DashboardCard? getCardFromId(String cardId) =>
    cards.where((element) => element.cardType == cardId).firstOrNull;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<DashboardCard> cardsToDisplay;
  final logger = Logger("dashboard");

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
        if (errorWidgets.contains(element.cardType)) {
          index++;
          continue;
        }
        final widget = element.card(results[index]);
        widgets.add(widget);
        index++;
      }
    } catch (e) {
      logger.e(
          "error in resultsToWidgets: $e. THIS CATCH SHOULD NEVER BE TRIGGERED");
      return [];
    }

    return widgets;
  }

  final errorWidgets = <dynamic>{};

  @override
  Widget build(BuildContext context) {
    final futures = cardsToDisplay
        .map(
          (e) => e.future().timeout(const Duration(milliseconds: 2500)).onError(
            (error, stackTrace) {
              errorWidgets.add(e.cardType);
              logger.e(
                  "Card ${e.cardType} failed to load in 2.5 seconds. Skipping this one");
            },
          ),
        )
        // .cast<Future<dynamic>>()
        .toList();
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
                if (errorWidgets.isNotEmpty) errorWidget(),
                ...resultsToWidgets(snapshot.data!),
                ManageCardsButton(),
              ],
            ),
          );
        });
  }

  Widget errorWidget() => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.error,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                t.dashboard.error.text,
                style: TextStyle(color: context.theme.colorScheme.onError),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pushNamed(LogsScreen.routeName, extra: {
                  LogLevel.error,
                  LogLevel.debug,
                });
              },
              child: Text(
                t.dashboard.error.logs,
                style: TextStyle(color: context.theme.colorScheme.onError),
              ),
            ),
          ],
        ),
      );
}

class ManageCardsButton extends StatelessWidget {
  ManageCardsButton({super.key});

  final List<String> cardsToDisplay = Prefs.cardsToDisplay.value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          context.push(location);
        },
        child: Text(t.dashboard.cards.manage.title),
      ),
    );
  }
}
