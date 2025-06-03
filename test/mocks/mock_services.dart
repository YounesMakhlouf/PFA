import 'package:mockito/annotations.dart';
import 'package:pfa/services/settings_service.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/repositories/game_session_repository.dart';
import 'package:pfa/services/audio_service.dart';
import 'package:pfa/services/emotion_detection_service.dart';
import 'package:pfa/services/tts_service.dart';

// Generate mocks using build_runner:
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([
  GameRepository,
  LoggingService,
  GameSessionRepository,
  TtsService,
  AudioService,
  EmotionDetectionService,
  AppLocalizations,
  Ref,
  SupabaseService,
  SettingsService
])
void main() {}
