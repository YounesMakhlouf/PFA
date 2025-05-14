import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/enums.dart';
import 'package:pfa/providers/global_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsService = ref.read(settingsServiceProvider);

    final ttsEnabledAsync = ref.watch(ttsEnabledProvider);
    final soundEffectsEnabledAsync = ref.watch(soundEffectsEnabledProvider);
    final currentAppLanguage = ref.watch(appLanguageProvider);
    final currentSpeechRate = ref.watch(ttsSpeechRateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // TTS Setting
          ttsEnabledAsync.when(
            data: (isEnabled) => SwitchListTile(
              title: Text(l10n.ttsEnabledSetting),
              value: isEnabled,
              onChanged: (bool value) async {
                await settingsService.setTtsEnabled(value);
                ref.invalidate(ttsEnabledProvider);
              },
            ),
            loading: () => const ListTile(
                title: Text("Loading TTS setting..."),
                trailing: CircularProgressIndicator()),
            error: (err, st) =>
                ListTile(title: Text("Error loading TTS setting: $err")),
          ),

          const Divider(),

          // Sound Effects Setting
          soundEffectsEnabledAsync.when(
            data: (isEnabled) => SwitchListTile(
              title: Text(l10n.soundEffectsEnabledSetting),
              value: isEnabled,
              onChanged: (bool value) async {
                await settingsService.setSoundEffectsEnabled(value);
                ref.invalidate(soundEffectsEnabledProvider);
              },
            ),
            loading: () => const ListTile(
                title: Text("Loading sound effects setting..."),
                trailing: CircularProgressIndicator()),
            error: (err, st) => ListTile(
                title: Text("Error loading sound effects setting: $err")),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.languageSetting),
            subtitle: Text(currentAppLanguage.displayName(context)),
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
                                  ? AppColors.primary
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
          const Divider(),

          // --- TTS Speech Rate Setting ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.ttsSpeechRateSetting,
                  style: Theme.of(context).textTheme.titleMedium,
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
        ],
      ),
    );
  }
}
