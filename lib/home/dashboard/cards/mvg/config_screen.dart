import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/components/dropdown_list_tile.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

import 'line.dart';
import 'next_departures_card.dart';
import 'service/data.dart';
import 'station.dart';

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
  late List<Line> lines;

  @override
  void initState() {
    super.initState();
    station = widget.config.station;
    lines = List<Line>.from(widget.config.lines);
  }

  void save() {
    if (lines.isNotEmpty) {
      widget.onChanged(NextDeparturesConfig(
        station: station,
        lines: lines,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(lineIds[station.id]!.map((e) => e.direction));
    return ListView(
      children: [
        DropdownListTile<Station>(
          title: t.dashboard.cards.nextDepartures.config.station,
          initialValue: station,
          onChanged: (Station? value) {
            if (value == null) return;
            setState(() {
              station = value;
            });
            lines = List<Line>.from(lineIds[station.id]!.toList());
            save();
          },
          options: stationIds.map((e) => DropdownItem(e.name, e)),
        ),
        ListTile(
          title: Text(
            t.dashboard.cards.nextDepartures.config.lines,
            style: context.theme.textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
              shrinkWrap: true,
              children: lineIds[station.id]!
                  .map((e) => CheckboxListTile(
                        key: ValueKey(e),
                        title: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Text(e.number),
                            ),
                            Text(e.direction)
                          ],
                        ),
                        value: lines.contains(e),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              lines.add(e);
                            } else {
                              if (lines.length == 1) return;
                              lines.remove(e);
                            }
                          });
                          save();
                        },
                      ))
                  .toList()),
        ),
      ],
    );
  }
}
