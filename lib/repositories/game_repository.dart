import 'package:pfa/models/game.dart';
import 'package:pfa/models/level.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScreenWithOptionsMenu {
  final Screen screen;
  final List<Option> options;

  ScreenWithOptionsMenu({required this.screen, required this.options});
}

class GameRepository {
  final SupabaseService _supabaseService;
  final LoggingService _logger;

  static const String _gameSummarySelect =
      'game_id, name, image_path, category, type';
  static const String _levelSummarySelect = 'level_id, game_id, level_number';
  static const String _screenSelect =
      'screen_id, level_id, screen_number, type, instruction';
  static const String _optionSelect =
      'option_id, screen_id, label_text, picture_url, is_correct, pair_id';

  GameRepository(
      {required SupabaseService supabaseService,
      required LoggingService logger})
      : _supabaseService = supabaseService,
        _logger = logger;

  Future<Game?> getGameById(String gameId) async {
    try {
      _logger.info('Fetching game by ID: $gameId');
      final response = await _supabaseService.client
          .from('game')
          .select(_gameSummarySelect)
          .eq('game_id', gameId)
          .maybeSingle();

      if (response == null) {
        _logger.warning('Game not found with ID: $gameId');
        return null;
      }

      _logger.info('Successfully fetched game: ${response['name']}');
      return Game.fromJson(response);
    } on PostgrestException catch (e, stackTrace) {
      _logger.error('Supabase error fetching game $gameId', e, stackTrace);
      throw Exception('Failed to load game details: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error fetching game $gameId', e, stackTrace);
      throw Exception(
          'An unexpected error occurred while loading game details.');
    }
  }

  Future<List<Game>> getAvailableGames() async {
    try {
      _logger.info('Fetching available games summary');
      final response = await _supabaseService.client
          .from('game')
          .select(_gameSummarySelect)
          .order('name', ascending: true);

      final games = response.map((data) => Game.fromJson(data)).toList();
      _logger.info('Successfully fetched ${games.length} available games');
      return games;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error('Supabase error fetching available games', e, stackTrace);
      throw Exception('Failed to load games: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error fetching available games', e, stackTrace);
      throw Exception('An unexpected error occurred while loading games.');
    }
  }

  Future<List<Level>> getLevelsForGame(String gameId) async {
    try {
      _logger.info('Fetching levels for game ID: $gameId');
      final response = await _supabaseService.client
          .from('level')
          .select(_levelSummarySelect)
          .eq('game_id', gameId)
          .order('level_number', ascending: true);

      final levels = response.map((data) => Level.fromJson(data)).toList();
      _logger.info('Found ${levels.length} levels for game $gameId');
      return levels;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error fetching levels for game $gameId', e, stackTrace);
      throw Exception('Failed to load levels: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error fetching levels for game $gameId', e, stackTrace);
      throw Exception('An unexpected error occurred while loading levels.');
    }
  }

  Future<ScreenWithOptionsMenu?> getScreenWithDetails(String screenId) async {
    try {
      _logger.info('Fetching screen details for ID: $screenId');

      final screenData = await _supabaseService.client
          .from('screen')
          .select(_screenSelect)
          .eq('screen_id', screenId)
          .maybeSingle();

      if (screenData == null) {
        _logger.warning('Screen not found or not accessible: $screenId');
        return null;
      }

      final optionsData = await _supabaseService.client
          .from('option')
          .select(_optionSelect)
          .eq('screen_id', screenId)
          .order('option_id', ascending: true);

      final List<Option> options =
          optionsData.map((data) => Option.fromJson(data)).toList();
      _logger.debug('Found ${options.length} options for screen $screenId');

      final screenTypeString = screenData['type'] as String?;
      final ScreenType screenType =
          ScreenTypeExtension.fromString(screenTypeString);

      Screen? screenObject;

      switch (screenType) {
        case ScreenType.MULTIPLE_CHOICE:
          screenObject = MultipleChoiceScreen.fromJson(screenData);
          _logger.debug("Created MultipleChoiceScreen for $screenId");
          break;
        case ScreenType.MEMORY_MATCH:
          screenObject = MemoryScreen.fromJson(screenData);
          _logger.debug("Created MemoryScreen for $screenId");
          break;
        default:
          _logger.error(
              'Unknown or unsupported screen type "$screenTypeString" for screen ID: $screenId');
          throw Exception('Unsupported screen type: $screenTypeString');
      }

      // Ensure screenObject was successfully created
      if (screenObject == null) {
        _logger.error(
            'Failed to instantiate screen object for type "$screenTypeString", screen ID: $screenId');
        return null;
      }

      return ScreenWithOptionsMenu(screen: screenObject, options: options);
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error fetching screen details $screenId', e, stackTrace);
      throw Exception('Failed to load screen details: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error fetching screen details $screenId', e, stackTrace);
      throw Exception(
          'An unexpected error occurred while loading screen details.');
    }
  }

  Future<List<String>> getScreenIdsForLevel(String levelId) async {
    try {
      _logger.info('Fetching screen IDs for level ID: $levelId');
      final response = await _supabaseService.client
          .from('screen')
          .select('screen_id')
          .eq('level_id', levelId)
          .order('screen_number', ascending: true);

      final screenIds =
          response.map((data) => data['screen_id'] as String).toList();
      _logger.info('Found ${screenIds.length} screen IDs for level $levelId');
      return screenIds;
    } on PostgrestException catch (e, stackTrace) {
      _logger.error(
          'Supabase error fetching screens for level $levelId', e, stackTrace);
      throw Exception('Failed to load screens: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Unexpected error fetching screens for level $levelId', e,
          stackTrace);
      throw Exception('An unexpected error occurred while loading screens.');
    }
  }
}
