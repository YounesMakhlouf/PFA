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
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    if (_errorMessage != null ||
        _gameService.game == null ||
        _gameService.currentScreen == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Unknown error',
                style: const TextStyle(fontSize: 18),
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_gameService.game!.name),
        backgroundColor:
            _gameService.game!.themeColor.withAlpha((0.8 * 255).round()),
        elevation: 0,
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
