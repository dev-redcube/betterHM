import 'dart:async';

import 'package:flutter/material.dart';

enum LiveLocationState { off, searching, found, error }

class LiveLocationIndicator extends StatefulWidget {
  const LiveLocationIndicator({super.key, required this.state});

  final LiveLocationState state;

  @override
  State<LiveLocationIndicator> createState() => _LiveLocationIndicatorState();
}

class _LiveLocationIndicatorState extends State<LiveLocationIndicator> {
  Timer? timer;
  final duration = const Duration(milliseconds: 750);

  late LiveLocationState state;

  @override
  void initState() {
    super.initState();
    state = widget.state;
    if (state == LiveLocationState.searching) {
      timer = Timer.periodic(duration, timerFunc);
    }
  }

  @override
  void didUpdateWidget(covariant LiveLocationIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      state = widget.state;
      if (state == LiveLocationState.searching) {
        timer = Timer.periodic(duration, timerFunc);
      } else {
        timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void timerFunc(Timer timer) {
    setState(() {
      state =
          state == LiveLocationState.searching
              ? LiveLocationState.found
              : LiveLocationState.searching;
    });
  }

  IconData? get icon => switch (state) {
    LiveLocationState.searching => Icons.location_searching_rounded,
    LiveLocationState.found => Icons.my_location_rounded,
    LiveLocationState.error => Icons.error_rounded,
    _ => null,
  };

  @override
  Widget build(BuildContext context) =>
      icon == null ? const SizedBox.shrink() : Icon(icon, size: 16);
}
