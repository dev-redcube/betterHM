import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCardPopup extends StatelessWidget {
  const AddCardPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: CardType.values
            .map((e) => ListTile(
                  title: Text(
                      t.dashboard.cardTitles[e.name] ?? "No Title Provided"),
                  onTap: () {
                    context.pop(e);
                  },
                ))
            .toList(),
      ),
    );
  }
}
