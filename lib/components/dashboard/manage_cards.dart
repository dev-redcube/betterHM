import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final l = ["one", "two", "three"];

class ManageCardsPopup extends StatefulWidget {
  const ManageCardsPopup({super.key});

  @override
  State<ManageCardsPopup> createState() => _ManageCardsPopupState();
}

class _ManageCardsPopupState extends State<ManageCardsPopup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ReorderableListView.builder(
        itemCount: l.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final e = l[index];
          return ReorderableListTile(
            key: ValueKey(e),
            index: index,
            title: "Semester status $e",
            checked: true,
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = l.removeAt(oldIndex);
            l.insert(newIndex, item);
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
