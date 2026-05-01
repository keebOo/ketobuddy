import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/product.dart';
import '../../core/services/open_food_facts_service.dart';
import '../history/history_provider.dart';

final openFoodFactsServiceProvider = Provider<OpenFoodFactsService>((ref) {
  return OpenFoodFactsService();
});

sealed class ScanState {
  const ScanState();
}

class ScanIdle extends ScanState {
  const ScanIdle();
}

class ScanLoading extends ScanState {
  const ScanLoading();
}

class ScanSuccess extends ScanState {
  final Product product;
  const ScanSuccess(this.product);
}

class ScanError extends ScanState {
  final String message;
  final OpenFoodFactsErrorType errorType;
  const ScanError(this.message, this.errorType);
}

class ScanNotifier extends Notifier<ScanState> {
  @override
  ScanState build() => const ScanIdle();

  Future<void> scan(String barcode) async {
    if (state is ScanLoading) return;
    state = const ScanLoading();
    try {
      final product = await _fetchProduct(barcode);
      await ref.read(scanAndSaveProvider).saveProduct(product);
      state = ScanSuccess(product);
    } on OpenFoodFactsException catch (e) {
      state = ScanError(e.message, e.type);
    }
  }

  Future<Product> _fetchProduct(String barcode) async {
    // Cerca nella cache locale prima di fare una chiamata di rete.
    // Salta la cache se nutritionData è null (prodotto scansionato in precedenza
    // senza dati: potrebbe averli ora su OpenFoodFacts).
    final cached = ref
        .read(historyRepositoryProvider)
        .getAll()
        .where((r) => r.barcode == barcode && r.nutritionData != null)
        .firstOrNull;

    if (cached != null) return cached.toProduct();

    return ref.read(openFoodFactsServiceProvider).fetchProduct(barcode);
  }

  void reset() {
    state = const ScanIdle();
  }
}

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(() {
  return ScanNotifier();
});
