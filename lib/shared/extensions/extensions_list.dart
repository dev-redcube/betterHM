extension IndexedMap<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int index) f) {
    return asMap().entries.map((e) => f(e.value, e.key));
  }

  int? indexWhereOrNull(bool Function(E element) test) {
    for (final (int index, E element) in indexed) {
      if (test(element)) return index;
    }
    return null;
  }
}
