import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pfa/models/game_session.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/supabase_service.dart';

class GameSessionRepository {
  final SupabaseService _supabaseService;
  final LoggingService _logger;

  GameSessionRepository({
    required SupabaseService supabaseService,
    required LoggingService logger,
  })  : _supabaseService = supabaseService,
        _logger = logger;

  /// Fetches basic session data for a given child ID, ordered by start time.
  Future<List<GameSession>> getSessionsByChildId(String childId) async {
    try {
      _logger.info('Fetching game sessions for child ID: $childId');
      final response = await _supabaseService.client
          .from('game_session')
          .select()
          .eq('child_id', childId)
          .order('start_time', ascending: false);

      final sessions =
          response.map((data) => GameSession.fromJson(data)).toList();

      _logger.info('Found ${sessions.length} sessions for child ID: $childId');
      return sessions;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error fetching sessions for child $childId', e, stackTrace);
      throw Exception('Failed to load game sessions: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error fetching sessions for child $childId', e,
          stackTrace);
      throw Exception('An unexpected error occurred loading sessions.');
    }
  }

  Future<GameSession?> getSessionById(String sessionId) async {
    try {
      _logger.info('Fetching game session by ID: $sessionId');
      final response = await _supabaseService.client
          .from('game_session')
          .select()
          .eq('session_id', sessionId)
          .maybeSingle();

      if (response == null) {
        _logger.warning('Game session not found or not accessible: $sessionId');
        return null;
      }

      _logger.info('Successfully fetched session: $sessionId');
      return GameSession.fromJson(response);
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error fetching session $sessionId', e, stackTrace);
      throw Exception('Failed to load game session: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error fetching session $sessionId', e, stackTrace);
      throw Exception('An unexpected error occurred loading the session.');
    }
  }

  Future<List<ScreenAttempt>> getAttemptsForSession(String sessionId) async {
    try {
      _logger.info('Fetching attempts for session ID: $sessionId');
      final response = await _supabaseService.client
          .from('screen_attempt')
          .select()
          .eq('session_id', sessionId)
          .order('timestamp', ascending: true);

      final attempts =
          response.map((data) => ScreenAttempt.fromJson(data)).toList();

      _logger
          .info('Found ${attempts.length} attempts for session ID: $sessionId');
      return attempts;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error('Supabase error fetching attempts for session $sessionId',
          e, stackTrace);
      throw Exception('Failed to load session attempts: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error fetching attempts for session $sessionId',
          e, stackTrace);
      throw Exception('An unexpected error occurred loading attempts.');
    }
  }

  Future<GameSession> createSession({
    required String childId,
    required String gameId,
    required String levelId,
    DateTime? startTime,
  }) async {
    try {
      _logger.info(
          'Creating game session for child $childId, game $gameId, level $levelId');
      final response = await _supabaseService.client
          .from('game_session')
          .insert({
            'child_id': childId,
            'game_id': gameId,
            'level_id': levelId,
            'start_time': (startTime ?? DateTime.now()).toIso8601String(),
            'total_attempts': 0,
            'correct_attempts': 0,
            'hints_used': 0,
            'completed': false,
          })
          .select()
          .single();

      _logger.info('Game session created with ID: ${response['session_id']}');
      return GameSession.fromJson(response);
    } on PostgrestException catch (e, stackTrace) {
      _logger.error('Supabase error creating game session', e, stackTrace);
      throw Exception('Database error: Failed to create session. ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error creating game session', e, stackTrace);
      throw Exception(
          'An unexpected error occurred while creating the session.');
    }
  }

  /// Adds a single screen attempt to an existing session.
  Future<ScreenAttempt> addAttemptToSession({
    required String sessionId,
    required String screenId,
    required bool isCorrect,
    required int timeTakenMs,
    List<String>? selectedOptionIds,
    int hintsUsed = 0,
    DateTime? timestamp,
  }) async {
    try {
      _logger
          .debug('Adding attempt to session $sessionId for screen $screenId');
      final response = await _supabaseService.client
          .from('screen_attempt')
          .insert({
            'session_id': sessionId,
            'screen_id': screenId,
            'selected_option_ids': selectedOptionIds,
            'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
            'is_correct': isCorrect,
            'time_taken_ms': timeTakenMs,
            'hints_used': hintsUsed,
          })
          .select()
          .single();

      _logger.debug('Attempt added with ID: ${response['attempt_id']}');

      await _supabaseService.client.rpc('increment_session_stats', params: {
        'p_session_id': sessionId,
        'p_is_correct': isCorrect,
        'p_hints_used_increment': hintsUsed
      });

      return ScreenAttempt.fromJson(response);
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error adding attempt to session $sessionId', e, stackTrace);
      throw Exception('Database error: Failed to add attempt. ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error adding attempt to session $sessionId', e,
          stackTrace);
      throw Exception('An unexpected error occurred while adding the attempt.');
    }
  }

  /// Updates an existing game session, typically to mark it as ended.
  Future<bool> endSession({
    required String sessionId,
    required bool completed,
    DateTime? endTime,
    String? overallResult,
  }) async {
    try {
      _logger.info('Ending session: $sessionId');
      await _supabaseService.client.from('game_session').update({
        'end_time': (endTime ?? DateTime.now()).toIso8601String(),
        'completed': completed,
        'overall_result': overallResult,
      }).eq('session_id', sessionId);

      _logger
          .info('Session $sessionId marked as ended (completed: $completed)');
      return true;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error('Supabase error ending session $sessionId', e, stackTrace);
      throw Exception('Database error: Failed to end session. ${e.message}');
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error ending session $sessionId', e, stackTrace);
      throw Exception('An unexpected error occurred while ending the session.');
    }
  }
}
