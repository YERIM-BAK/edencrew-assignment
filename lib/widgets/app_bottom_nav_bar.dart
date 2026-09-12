import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:edencrew_assignment_starter/providers/tab_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final AppTab current = ref.watch(currentTabProvider);

    return Container(
      height: dimens.tabBarHeight,
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        border: Border(
          top: BorderSide(
            color: colors.borderSubtle,
            width: dimens.borderHairline,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          _NavItem(
            label: '관심',
            icon: current == AppTab.watchlist ? Icons.star : Icons.star_border,
            selected: current == AppTab.watchlist,
            onTap: () =>
                ref.read(currentTabProvider.notifier).state = AppTab.watchlist,
          ),
          _NavItem(
            label: '검색',
            icon: Icons.search,
            selected: current == AppTab.search,
            onTap: () =>
                ref.read(currentTabProvider.notifier).state = AppTab.search,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color color = selected ? colors.navActive : colors.navInactive;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: AppTypography.regular,
                fontSize: 11,
                height: 14 / 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
