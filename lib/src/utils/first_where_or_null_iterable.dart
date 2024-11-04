extension FirstWhereOrNullExtension<E> on Iterable<E> {
  /// Extension method to return the first element matching the [test] condition or `null` if none found.
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
