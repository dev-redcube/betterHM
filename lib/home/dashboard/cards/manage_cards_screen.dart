import 'package:better_hm/home/dashboard/cards/add_card_popup.dart';
import 'package:better_hm/home/dashboard/cards/card_config.dart';
import 'package:better_hm/home/dashboard/cards/card_list_tile.dart';
import 'package:better_hm/home/dashboard/cards/card_service.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  static const routeName = "dashboard.manageCards";

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  List<CardConfig> cards = CardService.getCards(Prefs.cards.value);

  @override
  void initState() {
    super.initState();
    Prefs.cards.addListener(cardsChanged);
  }

  void cardsChanged() {
    setState(() {
      cards = CardService.getCards(Prefs.cards.value);
    });
  }

  @override
  void dispose() {
    Prefs.cards.removeListener(cardsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.dashboard.manage.title)),
      body: cards.isEmpty
          ? const Center(
              child: Text("No Items"),
            )
          : ReorderableListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return CardListTile(
                  index: index,
                  config: cards[index],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final CardConfig? config = await showDialog<CardConfig>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(t.dashboard.manage.add.title),
              content: const AddCardPopup(),
              scrollable: false,
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(t.dashboard.manage.add.cancel),
                ),
              ],
            ),
          );
          if(config != null) {
            final c = cards..add(config);
            Prefs.cards.value = CardService.saveCards(c);
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
