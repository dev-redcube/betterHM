import 'package:better_hm/shared/components/dropdown_list_tile.dart';
import 'package:flutter/material.dart';

import 'line.dart';
import 'next_departures_card.dart';
import 'service/data.dart';
import 'station.dart';

// TODO i18n
class NextDeparturesConfigScreen extends StatefulWidget {
  const NextDeparturesConfigScreen({
    super.key,
    required this.config,
    required this.onChanged,
  });

  final NextDeparturesConfig config;
  final void Function(NextDeparturesConfig) onChanged;

  @override
  State<NextDeparturesConfigScreen> createState() =>
      _NextDeparturesConfigScreenState();
}

class _NextDeparturesConfigScreenState
    extends State<NextDeparturesConfigScreen> {
  late Station station;
  late final List<Line> lines;

  @override
  void initState() {
    super.initState();
    station = widget.config.station;
    lines = widget.config.lines;
  }

  void save() {
    widget.onChanged(NextDeparturesConfig(
      station: station,
      lines: lines,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DropdownListTile<Station>(
          title: "Station",
          initialValue: station,
          onChanged: (Station? value) {
            if (value == null) return;
            setState(() {
              station = value;
            });
            save();
          },
          options: stationIds.map((e) => DropdownItem(e.name, e)),
        ),
        ListView(
            shrinkWrap: true,
            children: lineIds[station.id]!
                .map((e) => _LineCheckTile(
                      key: ValueKey(e),
                      title: "${e.number} ${e.direction}",
                      selected: lines.contains(e),
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
                .toList()),
      ],
    );
  }
}

class _LineCheckTile extends StatefulWidget {
  const _LineCheckTile({
    super.key,
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
