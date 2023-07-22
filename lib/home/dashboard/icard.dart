import 'package:flutter/widgets.dart';

/// This class is used to configure a card.
/// Types: T = future data type, S = config data type
abstract class ICard<T> {
  set config(Map<String, dynamic>? config) {}

  Map<String, dynamic>? get config => null;

  Future<T> future() => Future.value();

  Widget render(T data);

  Widget? renderConfig(int cardIndex);
}
