import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    Key? key,
    required this.child,
    this.allowHide = true,
  }) : super(key: key);
  final bool allowHide;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
            PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert_rounded),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: Text(t.dashboard.cards.settings),
                  onTap: () {
                    if (kDebugMode) {
                      print("SETTINGS");
                    }
                  },
                ),
                if (allowHide)
                  PopupMenuItem(
                    child: Text(t.dashboard.cards.hide),
                    onTap: () {
                      if (kDebugMode) {
                        print("HIDE");
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
