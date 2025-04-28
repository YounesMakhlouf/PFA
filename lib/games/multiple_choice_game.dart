import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/screens/game_screen.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/repositories/game_repository.dart';
import 'package:pfa/services/supabase_service.dart';
import 'package:pfa/services/logging_service.dart';
import 'package:pfa/services/multiple_choice_game_service.dart';

class MultipleChoiceGame extends StatefulWidget {
  final String gameId;

  const MultipleChoiceGame({
    super.key,
    required this.gameId,
  });

  @override
  State<MultipleChoiceGame> createState() => _MultipleChoiceGameState();
}

class _MultipleChoiceGameState extends State<MultipleChoiceGame> {
  final _logger = LoggingService();
  late final MultipleChoiceGameService _gameService;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Ensure landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final gameRepository = GameRepository(supabaseService: SupabaseService());
    _gameService = MultipleChoiceGameService(gameRepository: gameRepository);
    _loadGameData();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _loadGameData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await _gameService.loadGameData(widget.gameId);

      setState(() {
        _isLoading = _gameService.isLoading;
        _errorMessage = _gameService.errorMessage;
      });
    } catch (e, stackTrace) {
      _logger.error('Error loading game data', e, stackTrace);
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load game: ${e.toString()}';
      });
    }
  }

  void _moveToNextScreen() {
    setState(() {
      _gameService.moveToNextScreen();
      _errorMessage = _gameService.errorMessage;
    });
  }

  // Check if the selected option is correct
  void _checkAnswer(Option selectedOption) {
    setState(() {
      bool correct = _gameService.checkAnswer(selectedOption);

      // If correct, move to the next screen after a delay
      if (correct) {
        Future.delayed(const Duration(seconds: 1), () {
          _moveToNextScreen();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
      );
    }

    if (_errorMessage != null ||
        _gameService.game == null ||
        _gameService.currentScreen == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(l10n.applicationError),
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: colorScheme.error,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? l10n.unexpectedError,
                  style:
                      textTheme.titleMedium?.copyWith(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context).goBack),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final gameThemeColor = _gameService.game!.themeColor ?? theme.primaryColor;
    final appBarForegroundColor = colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(_gameService.game!.name),
        backgroundColor: gameThemeColor.withAlpha((0.9 * 255).round()),
        foregroundColor: appBarForegroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: SafeArea(
        child: GameScreenWidget(
          game: _gameService.game!,
          currentScreen: _gameService.currentScreen!,
          currentLevel: _gameService.currentLevel!.levelNumber,
          currentScreenNumber: _gameService.currentScreen!.screenNumber,
          isCorrect: _gameService.isCorrect,
          onOptionSelected: _checkAnswer,
        ),
      ),
    );
  }
}
