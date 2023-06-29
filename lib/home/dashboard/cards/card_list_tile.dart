import 'package:better_hm/home/dashboard/cards/card_config.dart';
import 'package:flutter/material.dart';

class CardListTile extends StatelessWidget {
  const CardListTile({
    super.key,
    required this.index,
    required this.config,
    this.onDelete,
  });

  final int index;
  final CardConfig config;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
          Expanded(
            // TODO i18n
            child: Text(config.cardType.name),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded),
            // TODO confirm dialog
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
