import 'package:flutter/widgets.dart';

/// This class is used to configure a card.
/// Types: T = future data type, S = config data type
abstract class CardConfig<T> {
  Map<String, String> config = {};

  CardConfig(this.config);

  Future<T> future() => Future.value();

  Widget render(T? data);

  static defaultConfig() => {};
}
