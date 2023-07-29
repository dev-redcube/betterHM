import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

final lineColors = <String, (Color, BoxDecoration)>{
  "20": (Colors.white, const BoxDecoration(color: Color(0xFF56B8E2))),
  "21": (Colors.white, const BoxDecoration(color: Color(0xFFBF9737))),
  "19": (Colors.white, const BoxDecoration(color: Color(0xFFe30613))),
  "27": (Colors.white, const BoxDecoration(color: Color(0xFFf7a600))),
  "28": (
    const Color(0xFFf7a600),
    BoxDecoration(border: Border.all(color: const Color(0xFFf7a600), width: 2))
  ),
  "29": (
    const Color(0xFFD02E26),
    BoxDecoration(border: Border.all(color: const Color(0xFFD02E26), width: 2))
  ),
  "153": (Colors.white, const BoxDecoration(color: Color(0xFF205060))),
  "160": (Colors.white, const BoxDecoration(color: Color(0xFF005262))),
  "N20": (Colors.white, const BoxDecoration(color: Color(0xFF16BAE7))),
  "N27": (Colors.white, const BoxDecoration(color: Color(0xFFf7a600))),
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
