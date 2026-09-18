import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateNotifierUnscrambles extends Notifier<int> {
  @override
  int build() => 0;

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

final unscrambledNotifierprovider =
    NotifierProvider<StateNotifierUnscrambles, int>(
      () => StateNotifierUnscrambles(),
    );
