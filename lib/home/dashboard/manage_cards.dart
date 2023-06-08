import 'package:better_hm/home/dashboard/dashboard_screen.dart';
import 'package:better_hm/shared/models/string_with_state.dart';
import 'package:better_hm/shared/prefs.dart';
import 'package:flutter/material.dart';

class ManageCardsPopup extends StatefulWidget {
  const ManageCardsPopup({super.key, this.onModify});
  final void Function(List<StringWithState>)? onModify;

  @override
  State<ManageCardsPopup> createState() => _ManageCardsPopupState();
}

class _ManageCardsPopupState extends State<ManageCardsPopup> {
  late final List<StringWithState> cards;

  @override
  void initState() {
    super.initState();
    cards = List.from(Prefs.cardsToDisplay.value.withState);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ReorderableListView.builder(
        itemCount: cards.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final cardId = cards[index];
          final e = dashboardCards
              .firstWhere((element) => element.cardId == cardId.string);
          final s = cards.firstWhere((element) => element.string == e.cardId);
          return ReorderableListTile(
            key: ValueKey(e),
            index: index,
            title: e.title,
            checked: s.state,
            onToggle: (value) {
              s.state = value;
              widget.onModify?.call(cards);
            },
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final StringWithState item = cards.removeAt(oldIndex);
            cards.insert(newIndex, item);
            widget.onModify?.call(cards);
          });
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
