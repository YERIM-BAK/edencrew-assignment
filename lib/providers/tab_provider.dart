import 'package:flutter_riverpod/legacy.dart';

enum AppTab { watchlist, search }

final currentTabProvider = StateProvider<AppTab>((ref) => AppTab.watchlist);
