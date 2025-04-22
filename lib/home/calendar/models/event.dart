import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class Event {
  final String title;
  final String? description;
  final String? room;
  final Color? color;

  const Event({required this.title, this.description, this.room, this.color});

  Event copyWith({
    String? title,
    String? description,
    String? room,
    Color? color,
  }) => Event(
    title: title ?? this.title,
    description: description ?? this.description,
    room: room ?? this.room,
    color: color ?? this.color,
  );
}
