extension UndexedMap<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int index) f) {
    return asMap().entries.map((e) => f(e.value, e.key));
  }
}
