import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/enums.dart';
import 'package:pfa/providers/global_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 8.0, right: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsService = ref.read(settingsServiceProvider);
    final theme = Theme.of(context);

    final ttsEnabledAsync = ref.watch(ttsEnabledProvider);
    final soundEffectsEnabledAsync = ref.watch(soundEffectsEnabledProvider);
    final currentAppLanguage = ref.watch(appLanguageProvider);
    final currentSpeechRate = ref.watch(ttsSpeechRateProvider);
    final hapticsEnabled = ref.watch(hapticsEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, l10n.settingsSectionAudio),
          // TTS Setting
          ttsEnabledAsync.when(
            data: (isEnabled) => SwitchListTile(
              title: Text(l10n.ttsEnabledSetting),
              value: isEnabled,
              onChanged: (bool value) async {
                await settingsService.setTtsEnabled(value);
                ref.invalidate(ttsEnabledProvider);
              },
              secondary: const Icon(Icons.record_voice_over_outlined),
            ),
            loading: () => const ListTile(
                title: Text("Loading TTS setting..."),
                trailing: CircularProgressIndicator()),
            error: (err, st) =>
                ListTile(title: Text("Error loading TTS setting: $err")),
          ),
          // Sound Effects Setting
          soundEffectsEnabledAsync.when(
            data: (isEnabled) => SwitchListTile(
              title: Text(l10n.soundEffectsEnabledSetting),
              value: isEnabled,
              onChanged: (bool value) async {
                await settingsService.setSoundEffectsEnabled(value);
                ref.invalidate(soundEffectsEnabledProvider);
              },
              secondary: const Icon(Icons.volume_up_outlined),
            ),
            loading: () => const ListTile(
                title: Text("Loading sound effects setting..."),
                trailing: CircularProgressIndicator()),
            error: (err, st) => ListTile(
                title: Text("Error loading sound effects setting: $err")),
          ),
          // --- Haptics Enabled Setting ---
          SwitchListTile(
            title: Text(l10n.hapticsEnabledSetting),
            value: hapticsEnabled,
            onChanged: (bool value) {
              ref
                  .read(hapticsEnabledProvider.notifier)
                  .setHapticsEnabled(value);
            },
            secondary: const Icon(Icons.vibration),
          ),
          // --- TTS Speech Rate Setting ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed_outlined,
                          color: theme.colorScheme.primary, size: 24),
                      const SizedBox(width: 16),
                      Text(
                        l10n.ttsSpeechRateSetting,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Slider(
                    value: currentSpeechRate,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: currentSpeechRate.toStringAsFixed(1),
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha((0.3 * 255).round()),
                    onChanged: (double value) {
                      ref
                          .read(ttsSpeechRateProvider.notifier)
                          .updateSpeechRate(value);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.ttsRateSlow,
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(l10n.ttsRateNormal,
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(l10n.ttsRateFast,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Divider(),
          _buildSectionHeader(context, l10n.settingsSectionGeneral),
          Card(
            child: ListTile(
              leading: Icon(Icons.language_outlined,
                  color: theme.colorScheme.primary),
              title:
                  Text(l10n.languageSetting, style: theme.textTheme.bodyLarge),
              subtitle: Text(currentAppLanguage.displayName(context)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final AppLanguage? selectedLanguage =
                    await showDialog<AppLanguage>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return SimpleDialog(
                      title: Text(l10n.selectLanguageDialogTitle),
                      children: AppLanguage.values.map((lang) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(dialogContext, lang);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              lang.displayName(context),
                              style: TextStyle(
                                fontWeight: lang == currentAppLanguage
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: lang == currentAppLanguage
                                    ? theme.colorScheme.primary
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );

                if (selectedLanguage != null &&
                    selectedLanguage != currentAppLanguage) {
                  ref
                      .read(appLanguageProvider.notifier)
                      .updateLanguage(selectedLanguage);
                }
              },
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
