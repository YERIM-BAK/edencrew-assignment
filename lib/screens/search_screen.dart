import 'package:edencrew_assignment_starter/screens/stock_detail_screen.dart';
import 'package:edencrew_assignment_starter/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/providers/favorites_provider.dart';
import 'package:edencrew_assignment_starter/providers/search_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/widgets/empty_state.dart';
import 'package:edencrew_assignment_starter/widgets/search_result_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final String query = ref.watch(searchQueryProvider);

    return ColoredBox(
      color: colors.surfaceBase,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(dimens.space4),
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: dimens.space3),
                decoration: BoxDecoration(
                  color: colors.surfaceSunken,
                  borderRadius: BorderRadius.circular(dimens.radiusMd),
                  border: Border.all(
                    color: colors.borderStrong,
                    width: dimens.borderHairline,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: dimens.iconSm,
                      color: colors.textTertiary,
                    ),
                    SizedBox(width: dimens.space3),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (String value) =>
                            ref.read(searchQueryProvider.notifier).state =
                                value,
                        style: TextStyle(
                          fontWeight: AppTypography.medium,
                          fontSize: 15,
                          height: 20 / 15,
                          letterSpacing: -0.1,
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '종목명 또는 종목코드',
                          hintStyle: TextStyle(
                            fontWeight: AppTypography.medium,
                            fontSize: 15,
                            height: 20 / 15,
                            letterSpacing: -0.1,
                            color: colors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    if (query.isNotEmpty) ...<Widget>[
                      SizedBox(width: dimens.space2),
                      GestureDetector(
                        onTap: () {
                          _controller.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                        child: Icon(
                          Icons.close,
                          size: dimens.iconSm,
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(child: _buildBody(context, query)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String query) {
    final AppColors colors = context.colors;

    if (query.isEmpty) {
      return EmptyState(
        icon: SvgPicture.asset(
          'assets/icons/ico_search.svg',
          colorFilter: ColorFilter.mode(colors.textTertiary, BlendMode.srcIn),
        ),
        title: '종목을 검색해 보세요',
        message: '종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.',
      );
    }

    final AsyncValue<List<StockRef>> results = ref.watch(searchResultsProvider);

    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) =>
          Center(child: Text('오류가 발생했습니다: $error')),
      data: (List<StockRef> stocks) {
        if (stocks.isEmpty) {
          return EmptyState(
            icon: SvgPicture.asset(
              'assets/icons/ico_search_empty.svg',
              colorFilter: ColorFilter.mode(
                colors.textTertiary,
                BlendMode.srcIn,
              ),
            ),
            title: '검색 결과가 없습니다',
            message: "'$query'와\n일치하는 검색 결과를 찾지 못했습니다.",
          );
        }

        final Map<String, StockRef> favorites = ref.watch(favoritesProvider);

        return ListView.builder(
          itemCount: stocks.length,
          itemBuilder: (BuildContext context, int index) {
            final StockRef stock = stocks[index];
            final bool isFavorite = favorites.containsKey(stock.canonicalId);

            return SearchResultTile(
              stock: stock,
              query: query,
              isFavorite: isFavorite,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StockDetailScreen(stock: stock),
                ),
              ),
              onToggleFavorite: () {
                final bool nowFavorite = !isFavorite;
                ref.read(favoritesProvider.notifier).toggle(stock);
                AppToast.show(
                  context,
                  icon: nowFavorite ? Icons.star : Icons.star_border,
                  iconColor: nowFavorite
                      ? colors.favoriteActive
                      : colors.textSecondary,
                  message: nowFavorite ? '관심이 등록되었습니다' : '관심이 해제되었습니다',
                );
              },
            );
          },
        );
      },
    );
  }
}
