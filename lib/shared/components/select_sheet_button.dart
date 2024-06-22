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
    this.initialChildSize = 0.75,
  })  : assert(items != null || itemsBuilder != null),
        assert(items == null || itemsBuilder == null),
        assert(initialChildSize >= 0.25 && initialChildSize <= 0.9);

  final SelectBottomSheetItemList<T>? items;
  final Future<SelectBottomSheetItemList<T>> Function()? itemsBuilder;
  final void Function(SelectBottomSheetItem<T> item) onSelect;

  final LiveLocationState locationState;
  final String text;

  final double initialChildSize;

  void showBottomSheet(BuildContext context) async {
    SelectBottomSheetItemList<T>? sheetItems = items;
    sheetItems ??= await itemsBuilder?.call();

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        useRootNavigator: true,
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          snap: true,
          snapSizes: [initialChildSize],
          initialChildSize: initialChildSize,
          builder: (context, scrollController) => ListView(
            controller: scrollController,
            children: sheetItems!
                .map(
                  (e) => ListTile(
                    title: Text(e.title),
                    leading: Icon(e.icon),
                    subtitle: e.subtitle == null ? null : Text(e.subtitle!),
                    enabled: e.enabled,
                    onTap: () {
                      onSelect.call(e);
                      Navigator.pop(context);
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  final IconData? icon;
  final bool enabled;
  final T? data;

  SelectBottomSheetItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.enabled = true,
    this.data,
  });

  @override
  String toString() =>
      "SelectBottomSheetItem<$T>(title: $title, subtitle: $subtitle, icon: $icon, enabled: $enabled, data: $data)";
}
