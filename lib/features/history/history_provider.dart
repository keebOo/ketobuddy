import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/score_config_loader.dart';
import '../../core/models/keto_score.dart';
import '../../core/models/product.dart';
import '../../core/models/scan_record.dart';
import '../../core/services/scoring_service.dart';
import '../../core/storage/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

class HistoryNotifier extends Notifier<List<ScanRecord>> {
  @override
  List<ScanRecord> build() {
    return ref.read(historyRepositoryProvider).getAll();
  }

  Future<void> addScan(Product product, KetoScore score,
      {required int maxItems}) async {
    final record = ScanRecord.fromProductAndScore(product, score);
    await ref
        .read(historyRepositoryProvider)
        .addScan(record, maxItems: maxItems);
    state = ref.read(historyRepositoryProvider).getAll();
  }

  Future<void> clear() async {
    await ref.read(historyRepositoryProvider).clear();
    state = [];
  }
}

final historyProvider =
    NotifierProvider<HistoryNotifier, List<ScanRecord>>(HistoryNotifier.new);

// Convenience provider: computes score and saves to history
final scanAndSaveProvider = Provider<ScanAndSaveService>((ref) {
  return ScanAndSaveService(ref);
});

class ScanAndSaveService {
  final Ref _ref;
  ScanAndSaveService(this._ref);

  Future<void> saveProduct(Product product) async {
    final config = await ScoreConfigLoader.load();
    final score = ScoringService(config)
        .calculate(product.nutritionData, product.ingredientsTags);
    await _ref
        .read(historyProvider.notifier)
        .addScan(product, score, maxItems: config.historyMaxItems);
  }
}
