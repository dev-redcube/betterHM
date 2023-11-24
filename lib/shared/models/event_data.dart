import 'package:flutter/material.dart';

class EventData {
  final String title;
  final String description;
  final Color? color;

  EventData({
    required this.title,
    required this.description,
    this.color,
  });
}
