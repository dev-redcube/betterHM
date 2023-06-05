import 'package:better_hm/providers/prefs/prefs.dart';
import 'package:better_hm/screens/dashboard_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ManageCardsPopup extends StatefulWidget {
  const ManageCardsPopup({super.key, this.onReorder});
  final void Function(List<String>)? onReorder;

  @override
  State<ManageCardsPopup> createState() => _ManageCardsPopupState();
}

class _ManageCardsPopupState extends State<ManageCardsPopup> {
  late final List<String> cards;

  @override
  void initState() {
    super.initState();
    cards = List.from(Prefs.cardsToDisplay.value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ReorderableListView.builder(
        itemCount: dashboardCards.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final cardId = cards[index];
          final e =
              dashboardCards.firstWhere((element) => element.cardId == cardId);
          return ReorderableListTile(
            key: ValueKey(e),
            index: index,
            title: e.title,
            checked: true,
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = cards.removeAt(oldIndex);
            cards.insert(newIndex, item);
            widget.onReorder?.call(cards);
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
  });

  final String title;
  final int index;
  final bool checked;

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
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              if (kDebugMode) print("SETTINGS");
            },
            icon: const Icon(Icons.settings_rounded),
          ),
          ReorderableDragStartListener(
            index: widget.index,
            child: const Icon(Icons.drag_handle),
          ),
        ],
      ),
    );
  }
}
