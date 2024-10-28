import 'dart:async';

import 'package:better_hm/home/meals/models/canteen.dart';
import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/home/meals/service/selected_canteen_wrapper.dart';
import 'package:better_hm/i18n/strings.g.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CapacityCard extends ConsumerWidget {
  const CapacityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canteen = ref.watch(selectedCanteenProvider).value;

    if (![
          "STUCAFE_KARLSTR",
          "MENSA_LOTHSTR",
          "STUCAFE_LOTHSTR",
          "MENSA_PASING",
          "STUCAFE_PASING",
        ].contains(canteen?.canteen?.enumName) ||
        canteen?.canteen == null) return const SizedBox.shrink();

    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
        child: _CapacityContent(canteen!.canteen!),
      ),
    );
  }
}

class _CapacityContent extends StatefulWidget {
  const _CapacityContent(this.canteen);

  final Canteen canteen;

  @override
  State<_CapacityContent> createState() => _CapacityContentState();
}

class _CapacityContentState extends State<_CapacityContent> {
  double? capacityValue;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 1), getCapacity);
    getCapacity();
  }

  @override
  void didUpdateWidget(covariant _CapacityContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.canteen != oldWidget.canteen) getCapacity();
  }

  getCapacity([Timer? timer]) async {
    final c = await capacity(widget.canteen);
    setState(() {
      capacityValue = c;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${t.mealplan.capacity.label}:"),
        const SizedBox(width: 16),
        Expanded(
          child: _ProgressBar(value: capacityValue ?? 0),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  Color? getColor() => switch (value) {
        < 0.5 => Colors.green,
        < 0.75 => Colors.orange,
        _ => Colors.red
      };

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: value,
      ),
      builder: (context, value, _) => LinearProgressIndicator(
        value: value,
        color: getColor(),
      ),
    );
  }
}
