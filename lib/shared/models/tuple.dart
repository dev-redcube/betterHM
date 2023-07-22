class Tuple<T, S> {
  final T item1;
  final S item2;

  const Tuple(this.item1, this.item2);

  List toList() => [item1, item2];
}
