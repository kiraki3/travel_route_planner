import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_route_planner/models/models.dart';

class MemoNotifier extends StateNotifier<List<Memo>> {
  MemoNotifier() : super([]);

  void addMemo(String text) {
    state = [...state, Memo(text: text)];
  }

  void removeMemo(Memo memo) {
    state = state.where((m) => m != memo).toList();
  }

  void clearMemos() {
    state = [];
  }
}

// Memo Provider
final memoProvider = StateNotifierProvider<MemoNotifier, List<Memo>>((ref) {
  return MemoNotifier();
});
