import 'package:flutter_riverpod/legacy.dart';

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

final sortOptionProvider = StateProvider<SortOption>(
  (ref) => SortOption.currentPrice,
);
