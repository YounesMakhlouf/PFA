import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arc_en_jeu/providers/global_providers.dart';

class HapticsEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadInitialState();
    return true;
  }

  Future<void> _loadInitialState() async {
    final enabled = await ref.read(settingsServiceProvider).areHapticsEnabled();
    if (!ref.mounted) return;
    state = enabled;
    ref.read(loggingServiceProvider).debug(
        "HapticsEnabledNotifier: Initial haptics state loaded: $enabled");
  }

  Future<void> setHapticsEnabled(bool isEnabled) async {
    if (state == isEnabled) return;
    await ref.read(settingsServiceProvider).setHapticsEnabled(isEnabled);
    if (!ref.mounted) return;
    state = isEnabled;
    ref.read(loggingServiceProvider)
        .info("HapticsEnabledNotifier: Haptics enabled set to $isEnabled");
  }
}
