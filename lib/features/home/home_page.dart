import 'package:flutter/material.dart';
import '../../core/storage/prefs_repository.dart';
import '../../l10n/app_localizations.dart';
import '../history/history_page.dart';
import '../scan/scan_page.dart';
import 'widgets/onboarding_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (!PrefsRepository.onboardingSeen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        PrefsRepository.setOnboardingSeen();
        showOnboardingDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => showOnboardingDialog(context),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    child: Icon(Icons.info_outline,
                        size: 20, color: Color(0xFFCCCCCC)),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/appicon.png',
                height: screenHeight * 0.28,
                width: screenHeight * 0.28,
              ),
              const SizedBox(height: 24),
              Text(
                l.appTitle,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.homeSubtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7C6B),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ScanPage()),
                  ),
                  child: Text(
                    l.homeScanButton.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                  ),
                  child: Text(
                    l.homeHistoryButton.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l.appVersion,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
