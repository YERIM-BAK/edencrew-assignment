import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:edencrew_assignment_starter/providers/tab_provider.dart';
import 'package:edencrew_assignment_starter/screens/search_screen.dart';
import 'package:edencrew_assignment_starter/screens/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/widgets/app_bottom_nav_bar.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTab tab = ref.watch(currentTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: tab.index,
        children: const <Widget>[WatchlistScreen(), SearchScreen()],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
