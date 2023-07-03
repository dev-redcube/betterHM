import 'package:better_hm/home/dashboard/card_service.dart';
import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/cards/mvg/departure.dart';
import 'package:better_hm/home/dashboard/cards/mvg/next_departures.dart';
import 'package:better_hm/home/dashboard/cards/mvg/service/api_mvg.dart';
import 'package:better_hm/home/dashboard/cards/mvg/service/data.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/shared/components/dropdown_list_tile.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:flutter/material.dart';

class NextDeparturesCard extends ICard<List<Departure>> {
  @override
  CardConfig get config =>
      super.config ??
      {
        "station": Stations.lothstr.toString(),
      };

  @override
  Future<List<Departure>> future() {
    return ApiMvg().getDepartures(
        stopId: stationIds[Stations.fromString(config["station"])]!,
        lineIds: lineIdsLothstr);
  }

  @override
  Widget render(data) => NextDepartures(departures: data);

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
  late Stations station;

  @override
  void initState() {
    super.initState();
    station = Stations.fromString(widget.config["station"]);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownListTile<Stations>(
      title: "Station",
      initialValue: station,
      onChanged: (Stations value) {
        widget.onChanged("station", value.toString());
      },
      options: Stations.values.map((e) => DropdownItem(e.toString(), e)),
    );
  }
}
