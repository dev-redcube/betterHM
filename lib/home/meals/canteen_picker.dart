import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/selected_canteen_provider.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenPicker extends StatefulWidget {
  const CanteenPicker({
    super.key,
    required this.canteens,
  });

  final List<Canteen> canteens;

  @override
  State<CanteenPicker> createState() => _CanteenPickerState();
}

class _CanteenPickerState extends State<CanteenPicker> {
  void loadDefaultCanteen() async {
    final provider = Provider.of<SelectedCanteenProvider>(context);
    final prefs = await SharedPreferences.getInstance();
    final String? canteenEnum = prefs.getString("selected-canteen");
    final Canteen canteen = widget.canteens.firstWhere(
      (element) => element.enumName == (canteenEnum ?? "MENSA_LOTHSTR"),
    );
    provider.canteen = canteen;
  }

  void saveCanteen(Canteen? canteen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected-canteen", canteen?.enumName ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedCanteenProvider>(
      builder: (context, provider, child) {
        if (provider.canteen == null) {
          loadDefaultCanteen();
        }
        return Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Canteen>(
              onChanged: (canteen) {
                provider.canteen = canteen;
                saveCanteen(canteen);
              },
              hint: Text(t.mealplan.choose_canteen),
              value: provider.canteen,
              items: widget.canteens
                  .map(
                    (canteen) => DropdownMenuItem(
                      value: canteen,
                      child: Text(canteen.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
