import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/providers/favorites_provider.dart';
import 'package:edencrew_assignment_starter/providers/quotes_provider.dart';
import 'package:edencrew_assignment_starter/providers/sort_provider.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/widgets/status_message.dart';
import 'package:edencrew_assignment_starter/models/quote.dart';
import 'package:edencrew_assignment_starter/widgets/selection_bottom_sheet.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist_row_tile.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final AsyncValue<Map<String, Quote>> quotesAsync = ref.watch(
      quotesProvider,
    );

    final Map favorites = ref.watch(favoritesProvider);
    final List items = ref.watch(watchlistProvider);
    final SortOption sortOption = ref.watch(sortOptionProvider);

    return ColoredBox(
      color: colors.surfaceBase,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.space4,
                vertical: dimens.space3,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    '관심',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 19,
                      fontWeight: AppTypography.bold,
                      height: 22 / 19,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Spacer(),
                  _SortChip(
                    label: sortOptionLabel(sortOption),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        barrierColor: colors.scrim,
                        builder: (_) => SelectionBottomSheet<SortOption>(
                          title: '정렬',
                          options: SortOption.values,
                          selected: sortOption,
                          labelBuilder: sortOptionLabel,
                          onSelect: (SortOption option) {
                            ref
                                .read(sortOptionProvider.notifier)
                                .select(option); // .state = option 대신
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(width: dimens.space4),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/ico_refresh.svg',
                      width: dimens.iconMd,
                      height: dimens.iconMd,
                      colorFilter: ColorFilter.mode(
                        colors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => ref.invalidate(quotesProvider),
                  ),
                ],
              ),
            ),
            if (quotesAsync.hasError)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: dimens.space4,
                  vertical: dimens.space2,
                ),
                child: Text(
                  '시세를 불러오지 못했습니다. 새로고침 버튼을 눌러 다시 시도해 주세요.',
                  style: TextStyle(
                    color: colors.feedbackWarning,
                    fontSize: 12,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ),
            Expanded(
              child: favorites.isEmpty
                  ? StatusMessage(
                      icon: SvgPicture.asset(
                        'assets/icons/ico_star.svg',
                        colorFilter: ColorFilter.mode(
                          colors.textTertiary,
                          BlendMode.srcIn,
                        ),
                      ),
                      title: '관심 종목이 없습니다',
                      message: '검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.',
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) =>
                          WatchlistRowTile(item: items[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: dimens.space1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimens.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 13,
                fontWeight: AppTypography.bold,
                height: 18 / 13, // line-height 18px ÷ font-size 13px
                letterSpacing: 0,
              ),
            ),
            SizedBox(width: dimens.space1),
            SvgPicture.asset(
              'assets/icons/ico_align.svg',
              width: dimens.iconSm,
              height: dimens.iconSm,
              colorFilter: ColorFilter.mode(
                colors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
