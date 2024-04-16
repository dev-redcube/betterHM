import 'package:better_hm/shared/components/live_location_indicator.dart';
import 'package:better_hm/shared/components/text_button_round_with_icons.dart';
import 'package:flutter/material.dart';

typedef SelectBottomSheetItemList<T> = Iterable<SelectBottomSheetItem<T>>;

class SelectSheetButton<T> extends StatelessWidget {
  const SelectSheetButton({
    super.key,
    required this.locationState,
    required this.text,
    this.items,
    this.itemsBuilder,
    required this.onSelect,
  })  : assert(items != null || itemsBuilder != null),
        assert(items == null || itemsBuilder == null);

  final SelectBottomSheetItemList<T>? items;
  final Future<SelectBottomSheetItemList<T>> Function()? itemsBuilder;
  final void Function(SelectBottomSheetItem<T> item) onSelect;

  final LiveLocationState locationState;
  final String text;

  void showBottomSheet(BuildContext context) async {
    SelectBottomSheetItemList<T>? sheetItems = items;
    sheetItems ??= await itemsBuilder?.call();

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        showDragHandle: true,
        useRootNavigator: true,
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) => ListView(
            children: sheetItems!
                .map(
                  (e) => ListTile(
                    title: Text(e.title),
                    subtitle: e.subtitle == null ? null : Text(e.subtitle!),
                    enabled: e.enabled,
                    onTap: () {
                      onSelect.call(e);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButtonRoundWithIcons(
      onPressed: () => showBottomSheet(context),
      left: locationState == LiveLocationState.off
          ? null
          : LiveLocationIndicator(state: locationState),
      text: text,
      right: const Icon(Icons.arrow_drop_down_rounded),
    );
  }
}

class SelectBottomSheetItem<T> {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool enabled;
  final T? data;

  SelectBottomSheetItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.enabled = true,
    this.data,
  });
}
