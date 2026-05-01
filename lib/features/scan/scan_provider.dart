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
      final service = ref.read(openFoodFactsServiceProvider);
      final product = await service.fetchProduct(barcode);
      await ref.read(scanAndSaveProvider).saveProduct(product);
      state = ScanSuccess(product);
    } on OpenFoodFactsException catch (e) {
      state = ScanError(e.message, e.type);
    }
  }

  void reset() {
    state = const ScanIdle();
  }
}

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(() {
  return ScanNotifier();
});
