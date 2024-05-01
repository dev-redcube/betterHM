extension IndexedMap<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int index) f) {
    return asMap().entries.map((e) => f(e.value, e.key));
  }
}

extension FirstWhere<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
