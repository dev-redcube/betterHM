import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/settings/logs/logs_screen.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/extensions/extensions_list.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'card_service.dart';
import 'manage_cards_screen.dart';

// TODO loading external with provider
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late CardsList cards;
  final _cardService = CardService();

  late Future<List<dynamic>> cardsLoading;

  Set<int> errors = {};

  @override
  void initState() {
    super.initState();
    _cardService.addListener(cardsChanged);
    cardsChanged();
  }

  void cardsChanged() {
    setState(() {
      cards = _cardService.value;
      cardsLoading = Future.wait(cards.mapIndexed(
        (e, index) => e.item2
            .future()
            .timeout(Duration(milliseconds: Prefs.cardTimeout.value))
            .onError((e, stackTrace) {
          errors.add(index);
          return Future.value();
        }),
      ));
    });
  }

  @override
  void dispose() {
    _cardService.removeListener(cardsChanged);
    cardsLoading.ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cardsLoading,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState != ConnectionState.done) {
          return const Align(
            alignment: Alignment.topLeft,
            child: LinearProgressIndicator(),
          );
        }
        final futures = snapshot.data as List<dynamic>;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              ...futures.mapIndexed((e, i) {
                if (errors.contains(i)) {
                  return _ErrorCard(cards[i].item1);
                }
                return cards[i].item2.render(e);
              }),
              const ManageCardsButton(),
            ],
          ),
        );
      },
    );
  }
}

class ManageCardsButton extends StatelessWidget {
  const ManageCardsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          context.pushNamed(ManageCardsScreen.routeName);
        },
        child: Text(t.dashboard.manage.title),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard(this.type);

  final CardType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: context.theme.colorScheme.error,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              t.dashboard.error.text(card: t.dashboard.cardTitles[type.name]!),
              style: context.theme.textTheme.titleMedium
                  ?.apply(color: context.theme.colorScheme.onError),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pushNamed(LogsScreen.routeName);
            },
            style: TextButton.styleFrom(
                foregroundColor: context.theme.colorScheme.onError),
            child: Text(t.dashboard.error.logs,
                style: TextStyle(color: context.theme.colorScheme.onError)),
          ),
        ],
      ),
    );
  }
}
