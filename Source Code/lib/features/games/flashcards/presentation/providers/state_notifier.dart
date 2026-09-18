import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

final notifierprovider = NotifierProvider<StateNotifier, int>(
  () => StateNotifier(),
);
