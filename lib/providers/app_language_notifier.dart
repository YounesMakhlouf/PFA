import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/enums.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/settings_service.dart';

class AppLanguageNotifier extends StateNotifier<AppLanguage> {
  final SettingsService _settingsService;
  final LoggingService _logger;

  AppLanguageNotifier(this._settingsService, this._logger)
      : super(AppLanguage.english) {
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    state = await _settingsService.getAppLanguage();
    _logger.info("AppLanguageNotifier: Loaded language - ${state.code}");
  }

  Future<void> updateLanguage(AppLanguage newLanguage) async {
    if (state != newLanguage) {
      await _settingsService.setAppLanguage(newLanguage);
      state = newLanguage;
      _logger.info("AppLanguageNotifier: Language updated to - ${state.code}");
    }
  }
}
