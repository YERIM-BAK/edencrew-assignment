import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/providers/meta_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class SearchResultTile extends ConsumerWidget {
  final StockRef stock;
  final String query;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;

  const SearchResultTile({
    super.key,
    required this.stock,
    required this.query,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final AsyncValue<StockRef> metaAsync = ref.watch(
      stockMetaProvider(stock.symbol),
    );
    final String displayName = metaAsync.value?.name ?? stock.name;
    final String displayMarket = metaAsync.value?.market ?? stock.market;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        padding: EdgeInsets.symmetric(
          horizontal: dimens.space4,
          vertical: dimens.space3,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.borderSubtle,
              width: dimens.borderHairline,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _highlightedName(colors, displayName),
                  const SizedBox(height: 2), // 토큰 없음, Figma 값 그대로
                  Text(
                    '${stock.symbol} · $displayMarket',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontWeight: AppTypography.regular,
                      fontSize: 11,
                      height: 14 / 11,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: dimens.space3),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                size: 22, // 토큰 없음, Figma 값 그대로
                color: isFavorite
                    ? colors.favoriteActive
                    : colors.favoriteInactive,
              ),
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightedName(AppColors colors, String name) {
    final int index = query.isEmpty ? -1 : name.indexOf(query);
    final TextStyle baseStyle = TextStyle(
      color: colors.textPrimary,
      fontWeight: AppTypography.medium,
      fontSize: 15,
      height: 20 / 15,
      letterSpacing: -0.1,
    );

    if (index < 0) {
      return Text(name, style: baseStyle);
    }

    final String before = name.substring(0, index);
    final String matched = name.substring(index, index + query.length);
    final String after = name.substring(index + query.length);

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: <TextSpan>[
          TextSpan(text: before),
          TextSpan(
            text: matched,
            style: TextStyle(color: colors.searchHighlight),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
