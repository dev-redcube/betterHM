import 'package:better_hm/home/dashboard/card_service.dart';
import 'package:better_hm/home/dashboard/cards.dart';
import 'package:better_hm/home/dashboard/icard.dart';
import 'package:better_hm/shared/components/dropdown_list_tile.dart';
import 'package:better_hm/shared/models/tuple.dart';
import 'package:flutter/material.dart';

import 'departure.dart';
import 'line.dart';
import 'next_departures.dart';
import 'service/api_mvg.dart';
import 'service/data.dart';
import 'station.dart';

class NextDeparturesCard extends ICard<List<Departure>> {
  late final NextDeparturesConfig _config;

  @override
  Map<String, dynamic> get config => _config.toJson();

  @override
  set config(Map<String, dynamic>? config) {
    _config = NextDeparturesConfig.fromJson(config);
  }

  @override
  Future<List<Departure>> future() {
    return ApiMvg()
        .getDepartures(stationId: _config.station, lineIds: _config.lines);
  }

  @override
  Widget render(data) => NextDepartures(departures: data);

  @override
  Widget? renderConfig(int cardIndex) => _Config(
        config: _config,
        onChanged: (NextDeparturesConfig config) {
          _config.apply(config);
          CardService()
              .replaceCardAt(cardIndex, Tuple(CardType.nextDepartures, this));
        },
      );
}

class _Config extends StatefulWidget {
  const _Config({required this.config, required this.onChanged});

  final NextDeparturesConfig config;
  final void Function(NextDeparturesConfig) onChanged;

  @override
  State<_Config> createState() => _ConfigState();
}

class _ConfigState extends State<_Config> {
  late Station station;
  late List<Line> lines;

  @override
  void initState() {
    super.initState();
    station = StationService.getFromId(widget.config.station)!;
    lines = widget.config.lines
        .map((e) => LineService.getFromId(e))
        .where((element) => element != null)
        .cast<Line>()
        .toList();
  }

  void save() {
    widget.onChanged(NextDeparturesConfig(
        station: station.id, lines: lines.map((e) => e.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownListTile<Station>(
          title: "Station",
          initialValue: station,
          onChanged: (Station value) {
            setState(() {
              station = value;
            });
            save();
          },
          options: stationIds.map((e) => DropdownItem(e.name, e)),
        ),
        ExpansionTile(
          shape: Border.all(color: Colors.transparent),
          title: const Text("Lines"),
          children: lineIds[station.id]!
              .map((e) => _LineCheckTile(
                    selected: lines.contains(e),
                    title: e.direction,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          lines.add(e);
                        } else {
                          lines.remove(e);
                        }
                      });
                      save();
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

class NextDeparturesConfig {
  String station;
  Iterable<String> lines;

  NextDeparturesConfig({
    required this.station,
    required this.lines,
  });

  void apply(NextDeparturesConfig config) {
    station = config.station;
    lines = config.lines;
  }

  Map<String, dynamic> toJson() => {
        "station": station,
        "lines": lines.toList(),
      };

  factory NextDeparturesConfig.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return NextDeparturesConfig(
        station: json["station"],
        lines: (json["lines"] as List<dynamic>).cast<String>(),
      );
    }
    // Fall back to default config
    return NextDeparturesConfig(
        station: "de:09162:12",
        lines: lineIds["de:09162:12"]!.map((e) => e.id));
  }
}
