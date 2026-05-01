import 'package:hive_flutter/hive_flutter.dart';

class PrefsRepository {
  static const _boxName = 'app_prefs';
  static const _keyOnboardingSeen = 'onboarding_seen';

  static Box get _box => Hive.box(_boxName);

  static bool get onboardingSeen =>
      _box.get(_keyOnboardingSeen, defaultValue: false) as bool;

  static Future<void> setOnboardingSeen() =>
      _box.put(_keyOnboardingSeen, true);

  static Future<void> init() => Hive.openBox(_boxName);
}
