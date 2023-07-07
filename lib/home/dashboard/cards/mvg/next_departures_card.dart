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
        "lines": lineIds[Stations.lothstr]!.map((e) => e.id).toList(),
      };

  @override
  Future<List<Departure>> future() {
    return ApiMvg().getDepartures(
        stopId: stationIds[Stations.fromString(config["station"])]!,
        lineIds: (config["lines"] as List<dynamic>).cast<String>());
  }

  @override
  Widget render(data) => NextDepartures(departures: data);

  @override
  Widget? renderConfig(int cardIndex) => _Config(
        config: config,
        onChanged: (key, value) {
          config[key] = value;
          print(config);
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
  late Set<String> lines;

  @override
  void initState() {
    super.initState();
    station = Stations.fromString(widget.config["station"]);
    lines = (widget.config["lines"] as List<dynamic>).cast<String>().toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownListTile<Stations>(
          title: "Station",
          initialValue: station,
          onChanged: (Stations value) {
            setState(() {
              station = value;
            });
            widget.onChanged("station", value.toString());
          },
          options: Stations.values.map((e) => DropdownItem(e.toString(), e)),
        ),
        ExpansionTile(
          shape: Border.all(color: Colors.transparent),
          title: const Text("Lines"),
          children: lineIds[station]!
              .map((e) => _LineCheckTile(
                    selected: lines.contains(e.id),
                    title: e.direction,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          lines.add(e.id);
                        } else {
                          lines.remove(e.id);
                        }
                      });
                      widget.onChanged("lines", lines.toList());
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _LineCheckTile extends StatefulWidget {
  const _LineCheckTile({
    required this.selected,
    required this.title,
    required this.onChanged,
  });

  final bool selected;
  final String title;
  final void Function(bool value) onChanged;

  @override
  State<_LineCheckTile> createState() => _LineCheckTileState();
}

class _LineCheckTileState extends State<_LineCheckTile> {
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: selected,
      title: Text(widget.title),
      onChanged: (value) {
        setState(() {
          selected = value!;
        });
        widget.onChanged(value!);
      },
    );
  }
}
