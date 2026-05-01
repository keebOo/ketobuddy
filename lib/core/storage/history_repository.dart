import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_record.dart';

class HistoryRepository {
  static const _boxName = 'scan_history';

  Box<String> get _box => Hive.box<String>(_boxName);

  Future<void> addScan(ScanRecord record, {required int maxItems}) async {
    await _box.add(record.toJson());
    if (_box.length > maxItems) {
      final excess = _box.length - maxItems;
      final keysToDelete = _box.keys.cast<int>().toList()
        ..sort()
        ..take(excess).toList();
      await _box.deleteAll(keysToDelete.take(excess));
    }
  }

  List<ScanRecord> getAll() {
    if (_box.isEmpty) return [];
    final keys = _box.keys.cast<int>().toList()..sort();
    return keys.reversed
        .map((k) => _parse(_box.get(k)))
        .whereType<ScanRecord>()
        .toList();
  }

  Future<void> clear() => _box.clear();

  ScanRecord? _parse(String? json) {
    if (json == null) return null;
    try {
      return ScanRecord.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }
}
