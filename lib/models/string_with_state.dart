class StringWithState {
  final String string;
  bool state;

  StringWithState(this.string, this.state);

  @override
  String toString() => "${state ? 1 : 0}$string";
}

extension WithState on String {
  StringWithState get withState {
    assert(startsWith("1") || startsWith("0"),
        "to convert String to StringWithState, it must start with 0 or 1");
    return StringWithState(
      substring(1),
      this[0] == "1" ? true : false,
    );
  }
}

extension StringWithStateList on List<String> {
  List<StringWithState> get withState => map((e) => e.withState).toList();
}

extension WithoutState on List<StringWithState> {
  List<String> get withoutState => map((e) => e.toString()).toList();
}
