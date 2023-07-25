import 'package:better_hm/home/dashboard/cards/mvg/transport_type.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/components/dropdown_list_tile.dart';
import 'package:better_hm/shared/components/input_list_tile.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late List<TransportType> transportTypes;
  late int offset;

  @override
  void initState() {
    super.initState();
    station = widget.config.station;
    offset = widget.config.offset;
  }

  void save() {
    if (transportTypes.isNotEmpty) {
      widget.onChanged(NextDeparturesConfig(
        station: station,
        transportTypes: transportTypes,
        offset: offset,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            save();
          },
          options: stationIds.map((e) => DropdownItem(e.name, e)),
        ),
        InputListTile(
          title: Text(t.dashboard.cards.nextDepartures.config.leadTime),
          keyboardType: TextInputType.number,
          initialValue: widget.config.offset.toString(),
          decoration: const InputDecoration(
            suffixText: "min",
            constraints: BoxConstraints(maxWidth: 75),
            counterText: "",
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: 2,
          onFieldSubmitted: (value) {
            offset = int.parse(value);
            save();
          },
        ),
        ListTile(
          title: Text(
            t.dashboard.cards.nextDepartures.config.lines,
            style: context.theme.textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _TransportTypeChooser(
            initial: widget.config.transportTypes,
            onChanged: (value) {
              transportTypes = value;
              save();
            },
          ),
        ),
      ],
    );
  }
}

class _TransportTypeChooser extends StatefulWidget {
  const _TransportTypeChooser({
    required this.onChanged,
    required this.initial,
  });

  final void Function(List<TransportType>) onChanged;
  final List<TransportType> initial;

  @override
  State<_TransportTypeChooser> createState() => _TransportTypeChooserState();
}

class _TransportTypeChooserState extends State<_TransportTypeChooser> {
  late final Set<TransportType> chosen;

  @override
  void initState() {
    super.initState();
    chosen = widget.initial.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: TransportType.values
          .map((e) => CheckboxListTile(
                value: chosen.contains(e),
                title: Text(e.name),
                key: ValueKey(e.name),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      chosen.add(e);
                    } else {
                      chosen.remove(e);
                    }
                  });

                  widget.onChanged.call(chosen.toList());
                },
              ))
          .toList(),
    );
  }
}
