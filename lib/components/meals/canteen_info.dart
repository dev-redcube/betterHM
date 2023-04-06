import 'package:better_hm/extensions/extensions_context.dart';
import 'package:better_hm/models/meal/canteen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CanteenInfo extends StatelessWidget {
  const CanteenInfo({Key? key, required this.canteen, required this.date})
      : super(key: key);

  final Canteen canteen;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final openingTimes = canteen.openHours?[date.weekday];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMMEEEEd().format(date),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (openingTimes != null)
            Text(
              "${context.localizations.opening_hours}: ${openingTimes.start} - ${openingTimes.end}",
              style: const TextStyle(color: Colors.green),
            ),
        ],
      ),
    );
  }
}
