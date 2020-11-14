import 'dart:async';

extension Filter<T> on Stream<T> {
  Stream<T> asyncWhere(FutureOr<bool> Function(T) test) {
    return asyncMap((t) async {
      final passed = await test(t);
      return passed ? t : null;
    }).where((t) => t != null);
  }
}
