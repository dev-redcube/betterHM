import 'package:better_hm/home/dashboard/add_card_popup.dart';
import 'package:better_hm/home/dashboard/card_service.dart';
import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'card_list_tile.dart';

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  static const routeName = "dashboard.manageCards";

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
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

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) =>
      AnimatedBuilder(
        animation: animation,
        builder: (context, Widget? child) {
          return Material(
            child: child,
          );
        },
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.dashboard.manage.title)),
      body: ReorderableListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return CardListTile(
            key: ObjectKey(card),
            index: index,
            card: card,
            onDelete: () => _cardService.removeCardAt(index),
          );
        },
        buildDefaultDragHandles: false,
        proxyDecorator: proxyDecorator,
        onReorder: _cardService.moveCard,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final CardType? type = await showDialog<CardType>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(t.dashboard.manage.add.title),
              content: const AddCardPopup(),
              scrollable: false,
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(t.dashboard.manage.add.cancel),
                ),
              ],
            ),
          );
          if (type != null) {
            final CardWithType card = CardService.getCardFromType(type);
            _cardService.addCard(card);
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
