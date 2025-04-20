import 'package:better_hm/shared/extensions/extensions_context.dart';
import 'package:flutter/material.dart';

const busColor = Color(0xFF005262);
const tramColor = Color(0xFFe30613);

const genericBus = (Colors.white, BoxDecoration(color: busColor));

final lineColors = <String, (Color, BoxDecoration)>{
  // Lothstraße
  "20": (Colors.white, const BoxDecoration(color: Color(0xFF16bae7))), // Tram
  "21": (Colors.white, const BoxDecoration(color: Color(0xFFc79514))), // Tram
  "29": (
    const Color(0xFFD02E26),
    BoxDecoration(border: Border.all(color: const Color(0xFFD02E26), width: 2)),
  ), // Tram
  "N20": (Colors.white, const BoxDecoration(color: Color(0xFF16bae7))), // Tram
  "153": genericBus, // Bus
  "154": genericBus, // Bus
  // Avenariusplatz
  "160": genericBus, // Bus
  "230": genericBus, // Bus
  "292": genericBus, // Bus
  "690": genericBus, // Bus
  // Planegger Straße
  "56": (Colors.white, const BoxDecoration(color: Color(0xFFec6726))), // Bus
  "57": (Colors.white, const BoxDecoration(color: Color(0xFFec6726))), // Bus
  "58": (Colors.white, const BoxDecoration(color: Color(0xFFec6726))), // Bus
  "68": (Colors.white, const BoxDecoration(color: Color(0xFFec6726))), // Bus
  "259": genericBus, // Bus
  "265": genericBus, // Bus
  // Ottostraße
  "27": (
    Colors.white,
    const BoxDecoration(color: Color(0xFFf7a600)),
  ), // Tram SEV
  "727": genericBus, // Bus SEV
  // Lenbachplatz
  "19": (Colors.white, const BoxDecoration(color: tramColor)), // Tram
  // 21 -> siehe Lothstraße
  "N19": (Colors.white, const BoxDecoration(color: tramColor)), // Tram
  "N40": genericBus, // Bus
  "N41": genericBus, // Bus
  "N45": genericBus, // Bus
  "N27": (
    const Color(0xFFf2ad13),
    const BoxDecoration(color: Colors.black),
  ), // Tram
  "X201": (Colors.white, const BoxDecoration(color: Color(0xFF244a9a))),
  "X660": (Colors.white, const BoxDecoration(color: Color(0xFF244a9a))),
  "U1": (Colors.white, const BoxDecoration(color: Color(0xFF438136))),
  "U2": (Colors.white, const BoxDecoration(color: Color(0xFFC40C37))),
  "U3": (Colors.white, const BoxDecoration(color: Color(0xFFF36E31))),
  "U6": (Colors.white, const BoxDecoration(color: Color(0xFF006CB3))),
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
          decoration: item?.$2.copyWith(borderRadius: BorderRadius.circular(6)),
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
