import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'card_service.dart';
import 'manage_cards_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final logger = Logger("dashboard");

  late CardsList cards;
  final _cardService = CardService();

  @override
  void initState() {
    super.initState();
    _cardService.addListener(cardsChanged);
    cards = _cardService.value;
  }

  void cardsChanged() {
    setState(() {
      cards = _cardService.value;
    });
  }

  @override
  void dispose() {
    _cardService.removeListener(cardsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ...cards.map((e) => e.item2.render(null)),
          const ManageCardsButton(),
        ],
      ),
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
