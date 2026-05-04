import 'dart:async';
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

class _ScanPageState extends ConsumerState<ScanPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  final TextEditingController _manualController = TextEditingController();

  // true mentre aspettiamo una risposta o gestiamo l'UI post-scan
  bool _scanning = false;
  // true solo quando _controller.stop() è stato chiamato esplicitamente
  bool _cameraStopped = false;
  String? _lastBarcode;

  Timer? _slowTimer;
  bool _slowConnection = false;

  late final AnimationController _overlayController;
  late final Animation<double> _overlayOpacity;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),      // fade-in veloce
      reverseDuration: const Duration(milliseconds: 900), // fade-out ~1 sec
    );
    _overlayOpacity =
        Tween<double>(begin: 0.0, end: 0.8).animate(_overlayController);
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    _overlayController.dispose();
    _controller.dispose();
    _manualController.dispose();
    super.dispose();
  }

  // --- slow connection timer ---

  void _startSlowTimer() {
    _slowTimer?.cancel();
    _slowConnection = false;
    _slowTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _slowConnection = true);
    });
  }

  void _cancelSlowTimer() {
    _slowTimer?.cancel();
    _slowTimer = null;
    if (mounted && _slowConnection) setState(() => _slowConnection = false);
  }

  // --- overlay helpers ---

  void _showOverlay() => _overlayController.forward();

  void _hideOverlay() {
    if (_cameraStopped) _controller.start();
    _overlayController.reverse().whenComplete(() {
      if (!mounted) return;
      _scanning = false;
      _cameraStopped = false;
    });
  }

  // --- scan logic ---

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_scanning) return;
    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;
    _scanning = true;
    _lastBarcode = barcode;
    // La camera resta attiva (preview live): solo _scanning blocca nuovi barcode.
    // _controller.stop() viene chiamato solo in caso di ScanSuccess.
    _showOverlay();
    ref.read(scanProvider.notifier).scan(barcode);
  }

  Future<void> _lookupManual(String barcode) async {
    if (_scanning || barcode.isEmpty) return;
    _scanning = true;
    _lastBarcode = barcode;
    _controller.stop();
    _cameraStopped = true;
    _showOverlay();
    await ref.read(scanProvider.notifier).scan(barcode);
  }

  void _restartScanner() {
    ref.read(scanProvider.notifier).reset();
    _hideOverlay();
  }

  // --- build ---

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanProvider);
    final isWide = MediaQuery.of(context).size.width > 700;

    ref.listen<ScanState>(scanProvider, (prev, next) {
      if (next is ScanLoading) {
        _startSlowTimer();
      } else {
        _cancelSlowTimer();
        if (next is ScanSuccess) {
          // Fermiamo la camera solo adesso (navigazione imminente)
          _controller.stop();
          _cameraStopped = true;
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: next.product),
              ))
              .then((_) => _restartScanner());
        } else if (next is ScanError) {
          _showError(context, next);
        }
      }
    });

    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.appTitle), centerTitle: true),
      body: Stack(
        children: [
          isWide ? _desktopLayout(state, l) : _mobileLayout(state, l),
          // Overlay scuro animato sopra camera e controlli manuali
          AnimatedBuilder(
            animation: _overlayOpacity,
            builder: (context, _) {
              if (_overlayOpacity.value == 0) return const SizedBox.shrink();
              return Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: _overlayOpacity.value),
                    ),
                  ),
                ),
              );
            },
          ),
          // Spinner visibile sopra l'overlay durante la chiamata API
          if (state is ScanLoading)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                      if (_slowConnection) ...[
                        const SizedBox(height: 14),
                        Text(
                          AppLocalizations.of(context)!.slowConnectionMessage,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- layout ---

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
        Expanded(child: Center(child: _manualInputSection(state, l))),
      ],
    );
  }

  Widget _manualInputSection(ScanState state, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state is! ScanLoading) ...[
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: _lookupManual,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      _lookupManual(_manualController.text.trim()),
                  child: Text(l.searchButton),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // --- error dialog ---

  void _showError(BuildContext context, ScanError error) {
    final l = AppLocalizations.of(context)!;
    final isRetryable = error.errorType == OpenFoodFactsErrorType.timeout ||
        error.errorType == OpenFoodFactsErrorType.noInternet ||
        error.errorType == OpenFoodFactsErrorType.serverError;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // Trasparente: l'overlay scuro fa già da sfondo al dialog
      barrierColor: Colors.transparent,
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
      case OpenFoodFactsErrorType.serverError:
        return l.serverError;
      case OpenFoodFactsErrorType.unknown:
        return error.message;
    }
  }
}
