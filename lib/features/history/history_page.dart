import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/keto_score.dart';
import '../../core/models/scan_record.dart';
import '../../l10n/app_localizations.dart';
import '../product_detail/product_detail_page.dart';
import 'history_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final records = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l.historyTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l.historyClear,
              onPressed: () => _confirmClear(context, ref, l),
            ),
        ],
      ),
      body: records.isEmpty
          ? _EmptyState(l: l)
          : _HistoryList(records: records, l: l),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref, AppLocalizations l) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.historyClearTitle),
        content: Text(l.historyClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).clear();
              Navigator.of(ctx).pop();
            },
            child: Text(
              l.historyClear,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l;
  const _EmptyState({required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            l.historyEmpty,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.historyEmptySubtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<ScanRecord> records;
  final AppLocalizations l;

  const _HistoryList({required this.records, required this.l});

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(records, l);
    final sections = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: sections.fold<int>(0, (sum, e) => sum + 1 + e.value.length),
      itemBuilder: (context, index) {
        int cursor = 0;
        for (final section in sections) {
          if (index == cursor) return _DateHeader(label: section.key);
          cursor++;
          final recordIndex = index - cursor;
          if (recordIndex < section.value.length) {
            return _RecordTile(record: section.value[recordIndex]);
          }
          cursor += section.value.length;
        }
        return const SizedBox.shrink();
      },
    );
  }

  Map<String, List<ScanRecord>> _groupByDate(
      List<ScanRecord> records, AppLocalizations l) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final result = <String, List<ScanRecord>>{};
    for (final record in records) {
      final day = DateTime(
        record.scannedAt.year,
        record.scannedAt.month,
        record.scannedAt.day,
      );
      final String key;
      if (day == today) {
        key = l.historyToday;
      } else if (day == yesterday) {
        key = l.historyYesterday;
      } else {
        key = '${day.day.toString().padLeft(2, '0')}/'
            '${day.month.toString().padLeft(2, '0')}/'
            '${day.year}';
      }
      result.putIfAbsent(key, () => []).add(record);
    }
    return result;
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7C6B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final ScanRecord record;
  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: record.toProduct()),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _ScoreBadge(score: record.score, label: record.scoreLabel),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.productName ?? record.barcode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  if (record.brand != null)
                    Text(
                      record.brand!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7C6B),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
          ],
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  final ScoreLabel label;

  const _ScoreBadge({required this.score, required this.label});

  Color get _color {
    return switch (label) {
      ScoreLabel.excellent => const Color(0xFF2E7D32),
      ScoreLabel.good => const Color(0xFF8BC34A),
      ScoreLabel.fair => const Color(0xFFFF9800),
      ScoreLabel.bad => const Color(0xFFE53935),
      ScoreLabel.noData => const Color(0xFF9E9E9E),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label == ScoreLabel.noData ? '?' : '$score',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
