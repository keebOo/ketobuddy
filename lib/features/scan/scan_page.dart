import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/services/open_food_facts_service.dart';
import '../../l10n/app_localizations.dart';
import '../product_detail/product_detail_page.dart';
import 'scan_provider.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  final TextEditingController _manualController = TextEditingController();
  bool _scanning = false; // true = camera ferma, in attesa di risposta o UI
  String? _lastBarcode;

  @override
  void dispose() {
    _controller.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_scanning) return;
    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;
    _scanning = true;
    _lastBarcode = barcode;
    _controller.stop();
    ref.read(scanProvider.notifier).scan(barcode);
  }

  Future<void> _lookupManual(String barcode) async {
    if (_scanning || barcode.isEmpty) return;
    _scanning = true;
    _lastBarcode = barcode;
    _controller.stop();
    await ref.read(scanProvider.notifier).scan(barcode);
  }

  void _restartScanner() {
    ref.read(scanProvider.notifier).reset();
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      _scanning = false;
      _controller.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanProvider);
    final isWide = MediaQuery.of(context).size.width > 700;

    ref.listen<ScanState>(scanProvider, (prev, next) {
      if (next is ScanSuccess) {
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: next.product),
            ))
            .then((_) => _restartScanner());
      } else if (next is ScanError) {
        _showError(context, next);
      }
    });

    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        centerTitle: true,
      ),
      body: isWide ? _desktopLayout(state, l) : _mobileLayout(state, l),
    );
  }

  Widget _mobileLayout(ScanState state, AppLocalizations l) {
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetected,
          ),
        ),
        _manualInputSection(state, l),
      ],
    );
  }

  Widget _desktopLayout(ScanState state, AppLocalizations l) {
    return Row(
      children: [
        Expanded(
          child: MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetected,
          ),
        ),
        Expanded(
          child: Center(child: _manualInputSection(state, l)),
        ),
      ],
    );
  }

  Widget _manualInputSection(ScanState state, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state is ScanLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else ...[
            Text(
              l.scanInstructions,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _manualController,
                    decoration: InputDecoration(
                      hintText: l.manualBarcodeHint,
                      border: const OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: _lookupManual,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _lookupManual(_manualController.text.trim()),
                  child: Text(l.searchButton),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showError(BuildContext context, ScanError error) {
    final l = AppLocalizations.of(context)!;
    final isRetryable = error.errorType == OpenFoodFactsErrorType.timeout ||
        error.errorType == OpenFoodFactsErrorType.noInternet;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l.error),
        content: Text(_errorMessage(error, l)),
        actions: [
          if (isRetryable && _lastBarcode != null)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                final barcode = _lastBarcode!;
                ref.read(scanProvider.notifier).reset();
                _scanning = false;
                _lookupManual(barcode);
              },
              child: Text(l.retry),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _restartScanner();
            },
            child: Text(isRetryable ? l.cancel : l.ok),
          ),
        ],
      ),
    );
  }

  String _errorMessage(ScanError error, AppLocalizations l) {
    switch (error.errorType) {
      case OpenFoodFactsErrorType.notFound:
        return l.productNotFound;
      case OpenFoodFactsErrorType.noInternet:
        return l.noInternetConnection;
      case OpenFoodFactsErrorType.timeout:
        return l.apiTimeout;
      case OpenFoodFactsErrorType.unknown:
        return error.message;
    }
  }
}
