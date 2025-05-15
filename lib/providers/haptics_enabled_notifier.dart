import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/settings_service.dart';

class HapticsEnabledNotifier extends StateNotifier<bool> {
  final SettingsService _settingsService;
  final LoggingService _logger;

  HapticsEnabledNotifier(this._settingsService, this._logger) : super(true) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    state = await _settingsService.areHapticsEnabled();
    _logger.debug("HapticsEnabledNotifier: Initial haptics state loaded: $state");
  }

  Future<void> setHapticsEnabled(bool isEnabled) async {
    if (state != isEnabled) {
      await _settingsService.setHapticsEnabled(isEnabled);
      state = isEnabled;
      _logger.info("HapticsEnabledNotifier: Haptics enabled set to $state");
    }
  }
}
