import 'package:better_hm/home/dashboard/cards/card_config.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
              Expanded(
                // TODO i18n
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(config.cardType.name,
                      style: context.theme.textTheme.bodyLarge),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded),
                // TODO confirm dialog
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
