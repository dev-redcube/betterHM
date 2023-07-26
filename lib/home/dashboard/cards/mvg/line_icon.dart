import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

final lineColors = <String, (Color, BoxDecoration)>{
  "20": (Colors.white, const BoxDecoration(color: Color(0xFF56B8E2))),
  "21": (Colors.white, const BoxDecoration(color: Color(0xFFBF9737))),
  "29": (
    const Color(0xFFD02E26),
    BoxDecoration(border: Border.all(color: const Color(0xFFD02E26), width: 2))
  ),
  "153": (Colors.white, const BoxDecoration(color: Color(0xFF205060))),
  "N20": (Colors.white, const BoxDecoration(color: Color(0xFF16BAE7))),
};

class LineIcon extends StatelessWidget {
  const LineIcon(this.lineNumber, {super.key});

  final String lineNumber;

  @override
  Widget build(BuildContext context) {
    final item = lineColors[lineNumber];
    return SizedBox(
      width: 40,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: item?.$2.copyWith(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              lineNumber,
              style: context.theme.textTheme.labelLarge?.copyWith(
                color: item?.$1,
                fontWeight: FontWeight.bold,
                // fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
