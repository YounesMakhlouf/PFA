import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/screens/game_screen.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultipleChoiceGame extends ConsumerStatefulWidget {
  final String gameId;

  const MultipleChoiceGame({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<MultipleChoiceGame> createState() => _MultipleChoiceGameState();
}

class _MultipleChoiceGameState extends ConsumerState<MultipleChoiceGame> {
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
    final logger = ref.read(loggingServiceProvider);
    final gameService = ref.read(multipleChoiceGameServiceProvider);

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await gameService.loadGameData(widget.gameId);

      setState(() {
        _isLoading = gameService.isLoading;
        _errorMessage = gameService.errorMessage;
      });
    } catch (e, stackTrace) {
      logger.error('Error loading game data', e, stackTrace);
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load game: ${e.toString()}';
      });
    }
  }

  void _moveToNextScreen() {
    final gameService = ref.read(multipleChoiceGameServiceProvider);

    setState(() {
      gameService.moveToNextScreen();
      _errorMessage = gameService.errorMessage;
    });
  }

  // Check if the selected option is correct
  void _checkAnswer(Option selectedOption) {
    final gameService = ref.read(multipleChoiceGameServiceProvider);

    setState(() {
      bool correct = gameService.checkAnswer(selectedOption);

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
    final gameService = ref.read(multipleChoiceGameServiceProvider);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);
    final translationService = ref.read(translationServiceProvider);

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
        gameService.game == null ||
        gameService.currentScreen == null) {
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
    final gameThemeColor = gameService.game!.themeColor;
    final appBarForegroundColor = colorScheme.onPrimary;
    gameService.currentScreen!.instruction =
        translationService.getTranslatedText(
            context, gameService.currentScreen!.instruction ?? "");
    return Scaffold(
      appBar: AppBar(
        title: Text(translationService.getTranslatedText(
            context, gameService.game!.name)),
        backgroundColor: gameThemeColor.withAlpha((0.9 * 255).round()),
        foregroundColor: appBarForegroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: SafeArea(
        child: GameScreenWidget(
          game: gameService.game!,
          currentScreen: gameService.currentScreen!,
          currentLevel: gameService.currentLevel!.levelNumber,
          currentScreenNumber: gameService.currentScreen!.screenNumber,
          isCorrect: gameService.isCorrect,
          onOptionSelected: _checkAnswer,
        ),
      ),
    );
  }
}
