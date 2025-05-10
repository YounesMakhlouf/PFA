import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/game_screen.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/utils/color_utils.dart';
import 'package:pfa/viewmodels/game_state.dart';

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
  @override
  void initState() {
    super.initState();
    // Ensure landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameViewModelProvider(widget.gameId));
    final gameViewModel =
        ref.read(gameViewModelProvider(widget.gameId).notifier);
    final logger = ref.read(loggingServiceProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (gameState.status) {
      case GameStatus.initial:
      case GameStatus.loadingGame:
      case GameStatus.loadingLevel:
      case GameStatus.loadingScreen:
        return Scaffold(
          appBar: AppBar(title: Text(gameState.game?.name ?? l10n.loading)),
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
              child: CircularProgressIndicator(color: colorScheme.primary)),
        );

      case GameStatus.error:
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close, color: colorScheme.onError),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(l10n.applicationError),
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: colorScheme.error, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    gameState.errorMessage ?? l10n.unexpectedError,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => gameViewModel.restartGame(),
                      label: Text(l10n.retry),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.errorContainer,
                          foregroundColor: colorScheme.onErrorContainer)),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.goBack,
                        style: TextStyle(color: theme.colorScheme.primary)),
                  ),
                ],
              ),
            ),
          ),
        );

      case GameStatus.completed:
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(gameState.game?.name ?? l10n.gameOver),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.congratulationsAllLevelsComplete,
                    style: theme.textTheme.headlineSmall),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay),
                  onPressed: () => gameViewModel.restartGame(),
                  label: Text(l10n.playAgain),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.backToGames,
                      style: TextStyle(color: theme.colorScheme.primary)),
                ),
              ],
            ),
          ),
        );

      case GameStatus.playing:
        if (gameState.currentScreenData == null ||
            gameState.game == null ||
            gameState.currentLevel == null) {
          ref.read(loggingServiceProvider).error(
              "GenericGameScreen: Playing status but currentScreenData, game, or currentLevel is null!");
          return ErrorScreen(errorMessage: l10n.unexpectedError);
        }

        final fallbackColor =
            theme.appBarTheme.backgroundColor ?? theme.primaryColor;

        final gameThemeColor = gameState.game?.themeColorCode
            .parseToColor(fallbackColor: fallbackColor);
        final appBarForegroundColor = theme.colorScheme.onPrimary;

        return Scaffold(
          appBar: AppBar(
            title: Text(gameState.game!.name),
            backgroundColor: gameThemeColor?.withAlpha((0.9 * 255).round()),
            foregroundColor: appBarForegroundColor,
            elevation: theme.appBarTheme.elevation,
            actions: [
              if (gameState.currentScreenData?.screen.instruction != null &&
                  gameState.currentScreenData!.screen.instruction!.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.volume_up_outlined,
                      color: appBarForegroundColor),
                  tooltip: l10n.repeatInstructionTooltip,
                  onPressed: () =>
                      gameViewModel.repeatCurrentScreenInstruction(),
                ),
            ],
            leading: IconButton(
              icon: Icon(Icons.close, color: appBarForegroundColor),
              tooltip: l10n.exitGameTooltip,
              onPressed: () async {
                // Show Confirmation Dialog
                final bool? shouldExit = await showDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    final dialogTheme = Theme.of(dialogContext);

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      title: Text(
                        l10n.exitGameConfirmationTitle,
                        style: dialogTheme.dialogTheme.titleTextStyle ??
                            theme.textTheme.titleLarge,
                      ),
                      content: Text(
                        l10n.exitGameConfirmationMessage,
                        style: dialogTheme.dialogTheme.contentTextStyle ??
                            theme.textTheme.bodyMedium,
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(l10n.cancelButton),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.errorContainer,
                            foregroundColor: theme.colorScheme.onErrorContainer,
                          ),
                          child: Text(l10n.exitButton),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );

                // If the dialog was dismissed by tapping outside (shouldExit is null) or user pressed Cancel (false)
                if (shouldExit != true) {
                  logger.debug("Exit game cancelled by user.");
                  return; // Do nothing, stay in the game
                }

                // User confirmed exit
                logger.info("User confirmed exiting game ${widget.gameId}");
                try {
                  await gameViewModel.endCurrentSession(completed: false);
                  logger.debug("Game session ended via ViewModel.");
                } catch (e, st) {
                  logger.error(
                      "Error ending session via ViewModel on exit", e, st);
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: GameScreenWidget(
              game: gameState.game!,
              currentScreen: gameState.currentScreenData!.screen,
              currentOptions: gameState.currentScreenData!.options,
              currentLevel: gameState.currentLevel!.levelNumber,
              currentScreenNumber: gameState.currentScreenIndex + 1,
              isCorrect: gameState.isCorrect,
              onOptionSelected: (Option selectedOption) {
                gameViewModel.checkAnswer(
                    selectedOption: selectedOption,
                    correctFeedbackText: l10n.correct,
                    tryAgainFeedbackText: l10n.tryAgain);
              },
            ),
          ),
        );
    }
  }
}
