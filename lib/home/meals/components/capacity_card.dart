import 'package:better_hm/home/meals/service/canteen_service.dart';
import 'package:better_hm/home/meals/service/selected_canteen_wrapper.dart';
import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CapacityCard extends ConsumerWidget {
  const CapacityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canteen = ref.watch(selectedCanteenProvider).value;
    print(canteen?.canteen);
    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Auslastung: "),
            const SizedBox(width: 16),
            if(canteen?.canteen != null)
            Expanded(
              child: FutureBuilder(
                future: capacity(canteen!.canteen!),
                builder: (context, snapshot) {
                  double progress = snapshot.data ?? 0;

                  return _ProgressBar(value: progress);
                },
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {},
              child: const Text("Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({super.key, required this.value});

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
