import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_list.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'card_service.dart';
import 'manage_cards_screen.dart';

// TODO loading external with provider
// TODO errors on card reorder
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final logger = Logger("dashboard");

  late CardsList cards;
  final _cardService = CardService();

  late Future<List<dynamic>> cardsLoading;

  @override
  void initState() {
    super.initState();
    _cardService.addListener(cardsChanged);
    cardsChanged();
  }

  void cardsChanged() {
    setState(() {
      cards = _cardService.value;
      cardsLoading = Future.wait(cards.map((e) => e.item2.future()));
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
          if (!snapshot.hasData) {
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
                ...futures.mapIndexed((e, i) => cards[i].item2.render(e)),
                const ManageCardsButton(),
              ],
            ),
          );
        });
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
