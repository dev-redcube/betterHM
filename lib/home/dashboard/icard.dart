import 'package:flutter/widgets.dart';

typedef CardConfig = Map<String, dynamic>;

/// This class is used to configure a card.
/// Types: T = future data type, S = config data type
abstract class ICard<T> {
  /// This config map can have anything as value that can be encoded to json:
  /// [bool], [int], [String], [List], [Map]
  CardConfig? config;

  Future<T> future() => Future.value();

  Widget render(T data);

  Widget? renderConfig(int cardIndex);

  static get defaultConfig => {};
}
