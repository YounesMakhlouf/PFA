import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/providers/global_providers.dart';

import '../constants/const.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  void _onIntroEnd(BuildContext context, WidgetRef ref) {
    final logger = ref.read(loggingServiceProvider);
    logger.info("Onboarding completed. Navigating to AuthGate.");

    ref.read(sharedPreferencesProvider).whenData((prefs) {
      prefs.setBool(onboardingCompletedKey, true);
    });

    ref.invalidate(onboardingCompletedProvider);

    Navigator.of(context).pushReplacementNamed(AppRoutes.authGate);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    List<PageViewModel> getPages() {
      return [
        PageViewModel(
          titleWidget: const SizedBox.shrink(), // No title
          bodyWidget: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                l10n.onboardingDesc1,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          image: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset('assets/images/onboarding_child_puzzle.png',
                height: 300),
          )),
          decoration: PageDecoration(
            pageColor: theme.scaffoldBackgroundColor,
            bodyAlignment: Alignment.center,
            imageAlignment: Alignment.bottomCenter,
            imagePadding: const EdgeInsets.only(bottom: 0),
          ),
        ),
        PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                l10n.onboardingDesc2,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
              ),
            ),
          ),
          image: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child:
                Image.asset('assets/images/onboarding_family.png', height: 300),
          )),
          decoration: PageDecoration(
            pageColor: theme.scaffoldBackgroundColor,
            bodyAlignment: Alignment.center,
            imageAlignment: Alignment.bottomCenter,
            imagePadding: const EdgeInsets.only(bottom: 0),
          ),
        ),
      ];
    }

    return IntroductionScreen(
      key: GlobalKey(),
      pages: getPages(),
      onDone: () => _onIntroEnd(context, ref),
      onSkip: () => _onIntroEnd(context, ref),
      showSkipButton: true,
      skip: Text(l10n.onboardingSkipButton,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
      next: Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
      done: Text(l10n.onboardingGetStartedButton,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: theme.colorScheme.primary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      globalBackgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
