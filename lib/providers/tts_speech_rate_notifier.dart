import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arc_en_jeu/providers/global_providers.dart';

class TtsSpeechRateNotifier extends Notifier<double> {
  @override
  double build() {
    _loadInitialRate();
    return 1.0;
  }

  Future<void> _loadInitialRate() async {
    final rate = await ref.read(settingsServiceProvider).getTtsSpeechRate();
    if (!ref.mounted) return;
    state = rate;
    ref.read(loggingServiceProvider)
        .debug("TtsSpeechRateNotifier: Initial rate loaded: $rate");
  }

  Future<void> updateSpeechRate(double newRate) async {
    final clampedRate = newRate.clamp(0.0, 1.0).toDouble();
    if (state == clampedRate) return;
    await ref.read(ttsServiceProvider).changeSpeechRate(clampedRate);
    if (!ref.mounted) return;
    state = clampedRate;
    ref.read(loggingServiceProvider)
        .info("TtsSpeechRateNotifier: Speech rate updated to $clampedRate");
  }
}
