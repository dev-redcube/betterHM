import 'package:better_hm/home/dashboard/dashboard_card.dart';
import 'package:better_hm/home/dashboard/dashboard_screen.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';

class ManageCardsPopup extends StatefulWidget {
  const ManageCardsPopup({super.key, this.onModify});

  final void Function(List<String>)? onModify;

  @override
  State<ManageCardsPopup> createState() => _ManageCardsPopupState();
}

class _ManageCardsPopupState extends State<ManageCardsPopup> {
  late final List<ListItem> cards;

  @override
  initState() {
    super.initState();
    initCards();
  }

  initCards() {
    cards = Prefs.cardsToDisplay.value
        .map((e) => ListItem(card: getCardFromId(e)!, selected: true))
        .toList();
    for (var element in dashboardCards) {
      if (!cards.any((e) => e.card.cardId == element.cardId)) {
        cards.add(ListItem(card: element, selected: false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ReorderableListView.builder(
        itemCount: dashboardCards.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final c = cards[index];
          return ReorderableListTile(
            key: ValueKey(c.card),
            index: index,
            title: c.card.title,
            checked: c.selected,
            onToggle: (value) {
              c.selected = value;
              widget.onModify?.call(
                cards
                    .where((element) => element.selected)
                    .map((e) => e.card.cardId)
                    .toList(),
              );
            },
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final ListItem item = cards.removeAt(oldIndex);
            cards.insert(newIndex, item);
          });
          widget.onModify?.call(
            cards
                .where((element) => element.selected)
                .map((e) => e.card.cardId)
                .toList(),
          );
        },
      ),
    );
  }
}

class ReorderableListTile extends StatefulWidget {
  const ReorderableListTile({
    super.key,
    required this.index,
    required this.title,
    required this.checked,
    required this.onToggle,
  });

  final String title;
  final int index;
  final bool checked;
  final Function(bool) onToggle;

  @override
  State<ReorderableListTile> createState() => _ReorderableListTileState();
}

class _ReorderableListTileState extends State<ReorderableListTile> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: checked,
        onChanged: (value) {
          setState(() {
            checked = value!;
          });
          widget.onToggle.call(value!);
        },
      ),
      trailing: ReorderableDragStartListener(
        index: widget.index,
        child: const Icon(Icons.drag_handle),
      ),
    );
  }
}

class ListItem {
  final DashboardCard card;
  bool selected;

  ListItem({
    required this.card,
    this.selected = false,
  });
}
