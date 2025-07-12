import 'package:mockito/annotations.dart';
import 'package:arc_en_jeu/services/settings_service.dart';
import 'package:arc_en_jeu/services/supabase_service.dart';
import 'package:arc_en_jeu/services/logging_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arc_en_jeu/l10n/app_localizations.dart';
import 'package:arc_en_jeu/repositories/game_repository.dart';
import 'package:arc_en_jeu/repositories/game_session_repository.dart';
import 'package:arc_en_jeu/services/audio_service.dart';
import 'package:arc_en_jeu/services/emotion_detection_service.dart';
import 'package:arc_en_jeu/services/tts_service.dart';

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
