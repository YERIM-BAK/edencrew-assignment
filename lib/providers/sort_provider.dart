import 'package:edencrew_assignment_starter/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOption { currentPrice, changeRate, alphabetical }

String sortOptionLabel(SortOption option) {
  switch (option) {
    case SortOption.currentPrice:
      return '현재가순';
    case SortOption.changeRate:
      return '등락률순';
    case SortOption.alphabetical:
      return '가나다순';
  }
}

class SortOptionNotifier extends Notifier<SortOption> {
  static const _key = 'sortOption';

  @override
  SortOption build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_key);
    return SortOption.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => SortOption.currentPrice,
    );
  }

  void select(SortOption option) {
    state = option;
    ref.read(sharedPreferencesProvider).setString(_key, option.name);
  }
}

final sortOptionProvider = NotifierProvider<SortOptionNotifier, SortOption>(
  SortOptionNotifier.new,
);
