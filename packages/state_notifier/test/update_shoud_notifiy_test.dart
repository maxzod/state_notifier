import 'package:mockito/mockito.dart';
import 'package:state_notifier/state_notifier.dart' hide Listener;
import 'package:test/test.dart';

import 'state_notifier_test.dart';

// ignore: prefer_mixin
class TestNotifier extends StateNotifier<int> with Mock {
  TestNotifier(int state) : super(state);

  int get currentState => state;

  void increment() => state++;

  void decrement() => state--;

  @override
  bool updateShouldNotify(int old, int current) {
    return super.noSuchMethod(
      Invocation.method(#updateShouldNotify, [old, current]),
      returnValue: false,
    ) as bool;
  }
}

void main() {
  test(
    'it updates and does not notify when updateShouldNotify return false',
    () {
      final notifier = TestNotifier(0);
      when(notifier.updateShouldNotify(0, 1)).thenReturn(true);
      when(notifier.updateShouldNotify(1, 0)).thenReturn(false);
      final listener = Listener();

      notifier.addListener(listener, fireImmediately: false);
      verifyZeroInteractions(listener);

      notifier.increment();

      verify(listener(1));

      notifier.decrement();

      verifyNoMoreInteractions(listener);
      expect(notifier.debugState, 0);
    },
  );
}