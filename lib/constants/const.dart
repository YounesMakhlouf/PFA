import 'package:pfa/models/enums.dart';

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
// Smile probability thresholds
const double smileHigh = 0.7; // Strong smile → Joy
const double smileLow = 0.3; // Weak/no smile → Sadness
const double smileNeutralMin = 0.3;
const double smileNeutralMax = 0.7;

// Head rotation thresholds (in degrees)
const double headTiltZ = 20.0; // Head roll → Surprise
const double headTurnY = 30.0; // Head yaw → Anger or frustration

String defaultLanguageCode = AppLanguage.arabic.code;
