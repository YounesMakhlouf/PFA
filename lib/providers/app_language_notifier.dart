import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arc_en_jeu/models/enums.dart';
import 'package:arc_en_jeu/providers/global_providers.dart';

class AppLanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() {
    _loadCurrentLanguage();
    return AppLanguage.english;
  }

  Future<void> _loadCurrentLanguage() async {
    final settingsService = ref.read(settingsServiceProvider);
    final logger = ref.read(loggingServiceProvider);
    final language = await settingsService.getAppLanguage();
    if (!ref.mounted) return;
    state = language;
    logger.info("AppLanguageNotifier: Loaded language - ${language.code}");
  }

  Future<void> updateLanguage(AppLanguage newLanguage) async {
    if (state == newLanguage) return;
    final settingsService = ref.read(settingsServiceProvider);
    await settingsService.setAppLanguage(newLanguage);
    if (!ref.mounted) return;
    state = newLanguage;
    ref.read(loggingServiceProvider).info(
        "AppLanguageNotifier: Language updated to: ${newLanguage.code}");
  }
}
