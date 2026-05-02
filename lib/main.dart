import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/history_repository.dart';
import 'core/storage/prefs_repository.dart';
import 'features/home/home_page.dart';
import 'l10n/app_localizations.dart';

/// Override lingua a compile-time (se vuota → lingua del dispositivo).
/// Esempio: flutter run --dart-define=FORCE_LOCALE=en
Locale? _localeFromEnvironment() {
  const forced = String.fromEnvironment('FORCE_LOCALE');
  switch (forced) {
    case 'en':
      return const Locale('en');
    case 'it':
      return const Locale('it');
    default:
      return null;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HistoryRepository.init();
  await PrefsRepository.init();
  runApp(const ProviderScope(child: KetoBuddyApp()));
}

class KetoBuddyApp extends StatelessWidget {
  const KetoBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KetoBuddy',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it'),
        Locale('en'),
      ],
      locale: _localeFromEnvironment(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        fontFamily: 'DMSans',
      ),
      home: const HomePage(),
    );
  }
}
