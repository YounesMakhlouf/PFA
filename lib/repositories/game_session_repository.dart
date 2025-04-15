import 'package:pfa/models/game_session.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/repositories/user_repository.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/supabase_service.dart';

class GameSessionRepository {
  final SupabaseService _supabaseService;
  final GameRepository _gameRepository;
  final UserRepository _userRepository;
  final LoggingService _logger = LoggingService();

  GameSessionRepository({
    required SupabaseService supabaseService,
    required GameRepository gameRepository,
    required UserRepository userRepository,
  })  : _supabaseService = supabaseService,
        _gameRepository = gameRepository,
        _userRepository = userRepository;

  Future<List<GameSession>> getSessionsByChildId(String childId) async {
    try {
      final response = await _supabaseService.client
          .from('GameSession')
          .select()
          .eq('child_id', childId)
          .order('start_time', ascending: false);

      List<GameSession> sessions = [];
      for (var sessionData in response) {
        final session = await _getSessionWithAttempts(sessionData);
        if (session != null) {
          sessions.add(session);
        }
      }

      return sessions;
    } catch (e, stackTrace) {
      _logger.error('Error getting game sessions', e, stackTrace);
      return [];
    }
  }

  Future<GameSession?> getSessionById(String sessionId) async {
    try {
      final response = await _supabaseService.client
          .from('GameSession')
          .select()
          .eq('session_id', sessionId)
          .single();

      return await _getSessionWithAttempts(response);
    } catch (e, stackTrace) {
      _logger.error('Error getting game session', e, stackTrace);
      return null;
    }
  }

  Future<GameSession?> _getSessionWithAttempts(
      Map<String, dynamic> sessionData) async {
    try {
      final sessionId = sessionData['session_id'];
      final childId = sessionData['child_id'];
      final gameId = sessionData['game_id'];

      final child = await _userRepository.getChildById(childId);
      final game = await _gameRepository.getGameById(gameId);

      if (child == null || game == null) return null;

      // Get all attempts for this session
      final attemptsResponse = await _supabaseService.client
          .from('ScreenAttempt')
          .select()
          .eq('session_id', sessionId)
          .order('timestamp');

      List<ScreenAttempt> attempts = [];
      for (var attemptData in attemptsResponse) {
        // Find the screen in the game
        Screen? screen;
        for (var level in game.levels) {
          for (var s in level.screens) {
            if (s.screenId == attemptData['screen_id']) {
              screen = s;
              break;
            }
          }
          if (screen != null) break;
        }

        if (screen == null) continue;

        // Get selected option if any
        Option? selectedOption;
        if (attemptData['selected_option_ids'] != null &&
            attemptData['selected_option_ids'].isNotEmpty) {
          final optionId = attemptData['selected_option_ids'][0];
          // Find the option in the screen
          if (screen is MultipleChoiceScreen) {
            for (var option in screen.options) {
              if (option.optionId == optionId) {
                selectedOption = option;
                break;
              }
            }
          } else if (screen is MemoryScreen) {
            for (var option in screen.options) {
              if (option.optionId == optionId) {
                selectedOption = option;
                break;
              }
            }
          }
        }

        attempts.add(ScreenAttempt(
          attemptId: attemptData['attempt_id'],
          timestamp: DateTime.parse(attemptData['timestamp']),
          isCorrect: attemptData['is_correct'],
          timeTakenMs: attemptData['time_taken_ms'],
          hintsUsed: attemptData['hints_used'] ?? 0,
          screen: screen,
          selectedOption: selectedOption,
        ));
      }

      return GameSession(
        sessionId: sessionId,
        startTime: DateTime.parse(sessionData['start_time']),
        endTime: sessionData['end_time'] != null
            ? DateTime.parse(sessionData['end_time'])
            : null,
        overallResult: sessionData['overall_result'],
        child: child,
        game: game,
        attempts: attempts,
      );
    } catch (e, stackTrace) {
      _logger.error('Error in _getSessionWithAttempts', e, stackTrace);
      return null;
    }
  }

  Future<GameSession?> createSession(GameSession session) async {
    try {
      // Insert session
      final sessionResponse =
          await _supabaseService.client.from('GameSession').insert({
        'child_id': session.child.userId,
        'game_id': session.game.gameId,
        'start_time': session.startTime.toIso8601String(),
        'end_time': session.endTime?.toIso8601String(),
        'overall_result': session.overallResult,
        'total_attempts': session.attempts.length,
        'correct_attempts': session.attempts.where((a) => a.isCorrect).length,
        'hints_used': session.attempts.fold(0, (sum, a) => sum + a.hintsUsed),
        'completed': session.endTime != null,
      }).select();

      if (sessionResponse.isEmpty) {
        throw Exception('Failed to create game session');
      }

      final sessionId = sessionResponse[0]['session_id'];

      // Insert attempts
      for (var attempt in session.attempts) {
        await _supabaseService.client.from('ScreenAttempt').insert({
          'session_id': sessionId,
          'screen_id': attempt.screen.screenId,
          'selected_option_ids': attempt.selectedOption != null
              ? [attempt.selectedOption!.optionId]
              : [],
          'timestamp': attempt.timestamp.toIso8601String(),
          'is_correct': attempt.isCorrect,
          'time_taken_ms': attempt.timeTakenMs,
          'hints_used': attempt.hintsUsed,
        });
      }

      // Return the created session with the new ID
      return await getSessionById(sessionId);
    } catch (e, stackTrace) {
      _logger.error('Error creating game session', e, stackTrace);
      return null;
    }
  }

  // Update an existing game session (e.g., when ending a session)
  Future<bool> updateSession(GameSession session) async {
    try {
      // Update session
      await _supabaseService.client.from('GameSession').update({
        'end_time': session.endTime?.toIso8601String(),
        'overall_result': session.overallResult,
        'total_attempts': session.attempts.length,
        'correct_attempts': session.attempts.where((a) => a.isCorrect).length,
        'hints_used': session.attempts.fold(0, (sum, a) => sum + a.hintsUsed),
        'completed': session.endTime != null,
      }).eq('session_id', session.sessionId);

      // Delete existing attempts and insert new ones
      await _supabaseService.client
          .from('ScreenAttempt')
          .delete()
          .eq('session_id', session.sessionId);

      for (var attempt in session.attempts) {
        await _supabaseService.client.from('ScreenAttempt').insert({
          'session_id': session.sessionId,
          'screen_id': attempt.screen.screenId,
          'selected_option_ids': attempt.selectedOption != null
              ? [attempt.selectedOption!.optionId]
              : [],
          'timestamp': attempt.timestamp.toIso8601String(),
          'is_correct': attempt.isCorrect,
          'time_taken_ms': attempt.timeTakenMs,
          'hints_used': attempt.hintsUsed,
        });
      }

      return true;
    } catch (e, stackTrace) {
      _logger.error('Error updating game session', e, stackTrace);
      return false;
    }
  }

  Future<bool> addAttemptToSession(
      String sessionId, ScreenAttempt attempt) async {
    try {
      // Insert attempt
      await _supabaseService.client.from('ScreenAttempt').insert({
        'session_id': sessionId,
        'screen_id': attempt.screen.screenId,
        'selected_option_ids': attempt.selectedOption != null
            ? [attempt.selectedOption!.optionId]
            : [],
        'timestamp': attempt.timestamp.toIso8601String(),
        'is_correct': attempt.isCorrect,
        'time_taken_ms': attempt.timeTakenMs,
        'hints_used': attempt.hintsUsed,
      });

      // Update session stats
      final session = await getSessionById(sessionId);
      if (session != null) {
        await _supabaseService.client.from('GameSession').update({
          'total_attempts': session.attempts.length,
          'correct_attempts': session.attempts.where((a) => a.isCorrect).length,
          'hints_used': session.attempts.fold(0, (sum, a) => sum + a.hintsUsed),
        }).eq('session_id', sessionId);
      }

      return true;
    } catch (e, stackTrace) {
      _logger.error('Error adding attempt to session', e, stackTrace);
      return false;
    }
  }
}
