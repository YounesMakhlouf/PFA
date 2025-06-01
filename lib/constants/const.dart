class StorageBuckets {
  static const String gameAssets = 'game-assets';
  static const String avatars = 'avatars';
}

const List<String> positiveEmojis = ['🎉', '👍', '✅', '🥳', '🌟', '👏', '😄'];
const List<String> neutralEmojis = ['🤔', '🧐', '😮', '💡', '💪'];
final List<String> positiveEmojisList = List.from(positiveEmojis);
final List<String> neutralEmojisList = List.from(neutralEmojis);

const String onboardingCompletedKey = 'hasCompletedOnboarding';
const String keyLastActiveChildId = 'lastActiveChildId';
const String keyTtsEnabled = 'ttsEnabled';
const String keySoundEffectsEnabled = 'soundEffectsEnabled';
const String keyAppLanguage = 'appLanguage';
const String keyTtsSpeechRate = 'ttsSpeechRate';
const String keyHapticFeedbackEnabled = 'hapticFeedbackEnabled';

const String defaultLanguageCode = 'ar';
