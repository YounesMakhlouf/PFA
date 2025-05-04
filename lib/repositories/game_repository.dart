import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';

class GameRepository {
  final SupabaseService _supabaseService;
  final LoggingService _logger;

  GameRepository(
      {required SupabaseService supabaseService,
      required LoggingService logger})
      : _supabaseService = supabaseService,
        _logger = logger;

  Future<List<Game>> getAllGames() async {
    try {
      _logger.info('Fetching all games');
      final response = await _supabaseService.client
          .from('game')
          .select()
          .order('created_at');

      List<Game> games = [];
      for (var gameData in response) {
        final game = await _getGameWithLevels(gameData['game_id']);
        if (game != null) {
          games.add(game);
        }
      }

      _logger.info('Successfully fetched ${games.length} games');
      return games;
    } catch (e, stackTrace) {
      _logger.error('Error getting games', e, stackTrace);
      return [];
    }
  }

  Future<Game?> getGameById(String gameId) async {
    try {
      _logger.info('Fetching game by ID: $gameId');
      return await _getGameWithLevels(gameId);
    } catch (e, stackTrace) {
      _logger.error('Error getting game: $gameId', e, stackTrace);
      return null;
    }
  }

  Future<Game?> _getGameWithLevels(String gameId) async {
    try {
      _logger.debug('Fetching game with levels: $gameId');
      final gameResponse = await _supabaseService.client
          .from('game')
          .select()
          .eq('game_id', gameId)
          .single();

      // Get all levels for this game
      final levelsResponse = await _supabaseService.client
          .from('level')
          .select()
          .eq('game_id', gameId)
          .order('level_number');

      List<Level> levels = [];
      for (var levelData in levelsResponse) {
        final level = await _getLevelWithScreens(levelData['level_id']);
        if (level != null) {
          levels.add(level);
        }
      }
      levels.sort((a, b) => a.levelNumber.compareTo(b.levelNumber));

      _logger.debug('Successfully fetched game with ${levels.length} levels');
      return Game(
        gameId: gameResponse['game_id'],
        name: gameResponse['name'],
        pictureUrl: gameResponse['picture_url'] ?? '',
        instruction: gameResponse['description'] ?? '',
        category: GameCategory.values.firstWhere(
            (e) => e.toString() == 'GameCategory.${gameResponse['category']}'),
        type: GameType.values.firstWhere(
            (e) => e.toString() == 'GameType.${gameResponse['type']}'),
        levels: levels,
      );
    } catch (e, stackTrace) {
      _logger.error('Error in _getGameWithLevels: $gameId', e, stackTrace);
      return null;
    }
  }

  Future<Level?> _getLevelWithScreens(String levelId) async {
    try {
      final levelResponse = await _supabaseService.client
          .from('level')
          .select()
          .eq('level_id', levelId)
          .single();

      // Get all screens for this level
      final screensResponse = await _supabaseService.client
          .from('screen')
          .select()
          .eq('level_id', levelId)
          .order('screen_number');

      List<Screen> screens = [];
      for (var screenData in screensResponse) {
        final screenType = screenData['type'];
        if (screenType == 'MULTIPLE_CHOICE') {
          final screen = await _getMultipleChoiceScreen(screenData);
          if (screen != null) {
            screens.add(screen);
          }
        } else if (screenType == 'MEMORY') {
          final screen = await _getMemoryScreen(screenData);
          if (screen != null) {
            screens.add(screen);
          }
        }
      }

      screens.sort((a, b) => a.screenNumber.compareTo(b.screenNumber));

      return Level(
        levelId: levelResponse['level_id'],
        levelNumber: levelResponse['level_number'],
        screens: screens,
      );
    } catch (e, stackTrace) {
      _logger.error('Error in _getLevelWithScreens', e, stackTrace);
      return null;
    }
  }

  // Helper method to get a multiple choice screen with options
  Future<MultipleChoiceScreen?> _getMultipleChoiceScreen(
      Map<String, dynamic> screenData) async {
    try {
      final screenId = screenData['screen_id'];

      // Get all options for this screen
      final optionsResponse = await _supabaseService.client
          .from('option')
          .select()
          .eq('screen_id', screenId);

      List<Option> options = [];
      Option? correctAnswer;

      for (var optionData in optionsResponse) {
        final option = Option(
          optionId: optionData['option_id'],
          labelText: optionData['label_text'],
          pictureUrl: optionData['picture_url'],
        );

        options.add(option);

        if (optionData['is_correct'] == true) {
          correctAnswer = option;
        }
      }

      if (correctAnswer == null && options.isNotEmpty) {
        correctAnswer =
            options.first; // Fallback if no correct answer is marked
      }

      return MultipleChoiceScreen(
        screenId: screenId,
        screenNumber: screenData['screen_number'],
        instruction: screenData['instruction'],
        options: options,
        correctAnswer: correctAnswer!,
      );
    } catch (e, stackTrace) {
      _logger.error('Error in _getMultipleChoiceScreen', e, stackTrace);
      return null;
    }
  }

  // Helper method to get a memory screen with options
  Future<MemoryScreen?> _getMemoryScreen(
      Map<String, dynamic> screenData) async {
    try {
      final screenId = screenData['screen_id'];

      // Get all options for this screen
      final optionsResponse = await _supabaseService.client
          .from('option')
          .select()
          .eq('screen_id', screenId);

      List<Option> options = [];

      for (var optionData in optionsResponse) {
        final option = Option(
          optionId: optionData['option_id'],
          labelText: optionData['label_text'],
          pictureUrl: optionData['picture_url'],
          pairId: optionData['pair_id'],
        );

        options.add(option);
      }

      return MemoryScreen(
        screenId: screenId,
        screenNumber: screenData['screen_number'],
        instruction: screenData['instruction'],
        options: options,
      );
    } catch (e, stackTrace) {
      _logger.error('Error in _getMemoryScreen', e, stackTrace);
      return null;
    }
  }

  Future<Game?> createGame(Game game) async {
    try {
      // Insert game
      final gameResponse = await _supabaseService.client.from('game').insert({
        'name': game.name,
        'description': game.instruction,
        'category': game.category.toString().split('.').last,
        'type': game.type.toString().split('.').last,
        'picture_url': game.pictureUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).select();

      if (gameResponse.isEmpty) {
        throw Exception('Failed to create game');
      }

      final gameId = gameResponse[0]['game_id'];

      // Insert levels
      for (var level in game.levels) {
        final levelResponse =
            await _supabaseService.client.from('level').insert({
          'game_id': gameId,
          'level_number': level.levelNumber,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }).select();

        if (levelResponse.isEmpty) continue;

        final levelId = levelResponse[0]['level_id'];

        // Insert screens
        for (var screen in level.screens) {
          String screenType = '';
          if (screen is MultipleChoiceScreen) {
            screenType = 'MULTIPLE_CHOICE';
          } else if (screen is MemoryScreen) {
            screenType = 'MEMORY';
          }

          final screenResponse =
              await _supabaseService.client.from('screen').insert({
            'level_id': levelId,
            'screen_number': screen.screenNumber,
            'type': screenType,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          }).select();

          if (screenResponse.isEmpty) continue;

          final screenId = screenResponse[0]['screen_id'];

          // Insert options
          if (screen is MultipleChoiceScreen) {
            for (var option in screen.options) {
              await _supabaseService.client.from('option').insert({
                'screen_id': screenId,
                'label_text': option.labelText,
                'picture_url': option.pictureUrl,
                'is_correct': option.optionId == screen.correctAnswer.optionId,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              });
            }
          } else if (screen is MemoryScreen) {
            for (var option in screen.options) {
              await _supabaseService.client.from('option').insert({
                'screen_id': screenId,
                'label_text': option.labelText,
                'picture_url': option.pictureUrl,
                'pair_id': option.pairId,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              });
            }
          }
        }
      }

      // Return the created game with the new IDs
      return await getGameById(gameId);
    } catch (e, stackTrace) {
      _logger.error('Error creating game', e, stackTrace);
      return null;
    }
  }
}
