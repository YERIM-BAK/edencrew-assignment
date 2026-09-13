import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/services/meta_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockMetaProvider = FutureProvider.family<StockRef, String>((
  ref,
  symbol,
) async {
  return MetaService().fetchMeta(symbol);
});
