import 'package:better_hm/home/dashboard/cards/card_config.dart';
import 'package:better_hm/home/dashboard/cards/card_list_tile.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class ManageCardsScreen extends StatelessWidget {
  const ManageCardsScreen({super.key});

  static const routeName = "dashboard.manageCards";

  @override
  Widget build(BuildContext context) {
    final cards = [];

    return Scaffold(
      appBar: AppBar(title: Text(t.dashboard.cards.manage.title)),
      body: ReorderableListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return CardListTile(
            index: index,
            config: cards[index] as CardConfig,
          );
        },
        buildDefaultDragHandles: false,
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = cards.removeAt(oldIndex);
          cards.insert(newIndex, item);
        },
      ),
    );
  }
}
