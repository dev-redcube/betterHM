import 'package:better_hm/home/dashboard/card_settings_screen.dart';
import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardListTile extends StatelessWidget {
  const CardListTile({
    super.key,
    required this.index,
    required this.card,
    this.onDelete,
  });

  final int index;
  final Tuple<CardType, ICard> card;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final Widget? renderConfig = card.item2.renderConfig(index);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      t.dashboard.cardTitles[card.item1.name] ??
                          "No Title Provided",
                      style: context.theme.textTheme.bodyLarge),
                ),
              ),
              if (renderConfig != null)
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    context.pushNamed(
                      CardSettingsScreen.routeName,
                      extra: renderConfig,
                    );
                  },
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
