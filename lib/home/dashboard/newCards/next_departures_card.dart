import 'package:better_hm/home/dashboard/card_service.dart';
import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:flutter/material.dart';

class NextDeparturesCard extends ICard {
  @override
  CardConfig get config => super.config ?? {"showDepartures": true};

  @override
  Widget render(data) => Text("Next Departures: ${config["showDepartures"]}");

  @override
  Widget? renderConfig(int cardIndex) => _Config(
        config: config,
        onChanged: (key, value) {
          config[key] = value;
          CardService()
              .replaceCardAt(cardIndex, Tuple(CardType.nextDepartures, this));
        },
      );
}

class _Config extends StatefulWidget {
  const _Config({required this.config, required this.onChanged});

  final CardConfig config;
  final void Function(String key, dynamic value) onChanged;

  @override
  State<_Config> createState() => _ConfigState();
}

class _ConfigState extends State<_Config> {
  late bool showDepartures;

  @override
  void initState() {
    super.initState();
    showDepartures = widget.config["showDepartures"] as bool;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text("Show Departures"),
      value: showDepartures,
      onChanged: (bool value) {
        // config["showDepartures"] = value;
        setState(() {
          showDepartures = value;
        });
        widget.onChanged("showDepartures", value);
        print(value);
      },
    );
  }
}
