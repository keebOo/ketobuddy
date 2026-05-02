import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/models/keto_score.dart';
import '../../core/models/product.dart';
import '../../l10n/app_localizations.dart';
import '../home/widgets/onboarding_dialog.dart';
import 'product_detail_provider.dart';
import 'share_utils.dart';
import 'widgets/macro_bar_widget.dart';
import 'widgets/score_badge_widget.dart';
import 'widgets/score_gauge_widget.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  final GlobalKey _captureKey = GlobalKey();
  bool _sharing = false;

  Future<void> _shareImage() async {
    if (_sharing) return;
    final scoreAsync = ref.read(ketoScoreProvider(widget.product));
    if (!scoreAsync.hasValue) return;
    final score = scoreAsync.value!;
    // Cattura valori dal context prima degli await
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final l = AppLocalizations.of(context)!;
    final productName = widget.product.name ?? l.product;

    setState(() => _sharing = true);
    try {
      final boundary = _captureKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      const pixelRatio = 3.0;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final bytes = await composeShareImage(
        image: image,
        badgeColor: scoreLabelToColor(score.label),
        backgroundColor: bgColor,
        productName: productName,
        pixelRatio: pixelRatio,
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ketobuddy_share.png');
      await file.writeAsBytes(bytes);

      final text = '$productName — Score keto: ${score.score}/100\n\nby KetoBuddy';

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: text,
      );
    } catch (_) {
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final scoreAsync = ref.watch(ketoScoreProvider(widget.product));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name ?? l.product),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showOnboardingDialog(context),
            tooltip: 'Info',
          ),
          IconButton(
            icon: _sharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.share_outlined),
            onPressed: _sharing ? null : _shareImage,
            tooltip: 'Condividi',
          ),
        ],
      ),
      body: scoreAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorGeneric(e.toString()))),
        data: (score) => RepaintBoundary(
          key: _captureKey,
          child: _ProductDetailBody(product: widget.product, score: score),
        ),
      ),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  final Product product;
  final KetoScore score;

  const _ProductDetailBody({required this.product, required this.score});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    final content = isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _scoreSection(context)),
              Expanded(child: _macroSection(context)),
            ],
          )
        : Column(
            children: [
              _scoreSection(context),
              _macroSection(context),
            ],
          );

    return SingleChildScrollView(
      child: Column(
        children: [
          if (product.imageUrl != null) _productImage(),
          content,
          if (score.warnings.isNotEmpty) _warningsSection(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _productImage() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Image.network(
        product.imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _scoreSection(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (product.brand != null)
            Text(
              product.brand!,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          const SizedBox(height: 8),
          ScoreGaugeWidget(score: score, size: 160),
          const SizedBox(height: 12),
          ScoreBadgeWidget(score: score),
          if (score.hasEnoughData && score.netCarbs != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    '${score.netCarbs!.toStringAsFixed(1)}g',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  Text(
                    l.netCarbsPer100g,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
          if (!score.hasEnoughData) ...[
            const SizedBox(height: 12),
            Text(
              l.insufficientDataDescription,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _macroSection(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final nutrition = product.nutritionData;
    if (nutrition == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.macrosPer100g,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          MacroBarWidget(
            label: l.carbohydrates,
            value: nutrition.carbohydrates100g,
            maxValue: 100,
            color: Colors.orange,
          ),
          MacroBarWidget(
            label: l.netCarbs,
            value: score.netCarbs,
            maxValue: 100,
            color: Colors.deepOrange,
          ),
          MacroBarWidget(
            label: l.fat,
            value: nutrition.fat100g,
            maxValue: 100,
            color: Colors.blue,
          ),
          MacroBarWidget(
            label: l.proteins,
            value: nutrition.proteins100g,
            maxValue: 100,
            color: Colors.red,
          ),
          MacroBarWidget(
            label: l.fiber,
            value: nutrition.fiber100g,
            maxValue: 30,
            color: Colors.green,
          ),
          if (nutrition.energyKcal100g != null) ...[
            const SizedBox(height: 8),
            Text(
              l.energyValue(nutrition.energyKcal100g!.toStringAsFixed(0)),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _warningsSection(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.warningsTitle,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          ...score.warnings.map((w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Text('⚠️ ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(
                        l.warningBadSweetener(w),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
