import 'package:better_hm/home/dashboard/cards/card_config.dart';
import 'package:better_hm/home/dashboard/cards/card_service.dart';
import 'package:better_hm/home/dashboard/cards/manage_cards_screen.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/logger/logger.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<CardConfig> cards;
  final logger = Logger("dashboard");

  @override
  void initState() {
    super.initState();
    onCardsChange();
    Prefs.cards.addListener(onCardsChange);
  }

  onCardsChange() {
    setState(() {
      cards = CardService.getCards(Prefs.cards.value);
    });
  }

  @override
  void dispose() {
    Prefs.cards.removeListener(onCardsChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ...cards.map((e) => e.widget.call()),
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
