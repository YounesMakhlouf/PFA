import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/viewmodels/game_state.dart';
import 'package:pfa/viewmodels/game_viewmodel.dart';
import 'package:pfa/widgets/option_widget.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/providers/global_providers.dart';

class GameScreenWidget extends ConsumerStatefulWidget {
  final Game game;
  final Screen currentScreen;
  final List<Option> currentOptions;
  final int currentLevel;
  final int currentScreenNumber;
  final bool? isCorrect;
  final Function(Option) onOptionSelected;

  const GameScreenWidget({
    super.key,
    required this.game,
    required this.currentScreen,
    required this.currentOptions,
    required this.currentLevel,
    required this.currentScreenNumber,
    required this.onOptionSelected,
    this.isCorrect,
  });

  @override
  ConsumerState<GameScreenWidget> createState() => _GameScreenWidgetState();
}

class _GameScreenWidgetState extends ConsumerState<GameScreenWidget> {
  @override
  void initState() {
    super.initState();
    final needsCamera = widget.game.category == GameCategory.EMOTIONS &&
        widget.currentOptions.length == 1 &&
        widget.currentOptions[0].isCorrect == true;

    if (needsCamera) {
      ref.read(gameViewModelProvider(widget.game.gameId).notifier).initCamera();
      ref
          .read(gameViewModelProvider(widget.game.gameId).notifier)
          .startEmotionDetection();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final translationService = ref.read(translationServiceProvider);

    final translatedInstruction = widget.currentScreen.instruction != null
        ? translationService.getTranslatedText(
            context, widget.currentScreen.instruction!)
        : l10n.selectCorrectOption;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            translatedInstruction,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: _buildScreenContent(context)),
        _buildFeedbackArea(context, widget.isCorrect, theme),
        _buildProgressIndicator(
            context, widget.currentLevel, widget.currentScreenNumber, theme),
      ],
    );
  }

  Widget _buildScreenContent(BuildContext context) {
    final screen = widget.currentScreen;

    if (screen is MultipleChoiceScreen) {
      return _buildMultipleChoiceUI(context, screen);
    } else if (screen is MemoryScreen) {
      return const ErrorScreen(errorMessage: "not implemented yet");
    } else {
      return Center(
        child: Text(
          AppLocalizations.of(context).unknownScreenType,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.error),
        ),
      );
    }
  }

  Widget _buildMultipleChoiceUI(
      BuildContext context, MultipleChoiceScreen screen) {
    final state = ref.watch(gameViewModelProvider(widget.game.gameId));

    final bool shouldShowCamera =
        widget.game.category == GameCategory.EMOTIONS &&
            widget.currentOptions.length == 1 &&
            widget.currentOptions[0].isCorrect == true;

    return SizedBox(
      child: shouldShowCamera
          ? _buildCameraOptionRow(context, state)
          : _buildOptionsArea(context, widget.currentOptions),
    );
  }

  Widget _buildCameraOptionRow(BuildContext context, GameState state) {
    final gameViewModel =
        ref.watch(gameViewModelProvider(widget.game.gameId).notifier);
    final cameraController = gameViewModel.cameraController;

    final Option currentOption = widget.currentOptions.first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildOptionsArea(context, [currentOption])
            ],
          ),
        ),

        Expanded(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: state.isCameraInitialized && cameraController != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CameraPreview(cameraController),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsArea(BuildContext context, List<Option> options) {
    final bool isStory = options.length == 1;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 60,
          runSpacing: 60,
          children: options.map((option) {
            return OptionWidget(
              option: option,
              onTap: () => widget.onOptionSelected(option),
              isStory: isStory,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeedbackArea(
      BuildContext context, bool? isCorrect, ThemeData theme) {
    if (isCorrect == null) return const SizedBox.shrink();

    final Color feedbackColor =
        isCorrect ? AppColors.success : theme.colorScheme.error;
    final String feedbackText = isCorrect
        ? AppLocalizations.of(context).correct
        : AppLocalizations.of(context).tryAgain;
    final IconData feedbackIcon =
        isCorrect ? Icons.check_circle_outline : Icons.highlight_off;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: feedbackColor.withAlpha((0.15 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: feedbackColor.withAlpha((0.5 * 255).round()),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(feedbackIcon, color: feedbackColor, size: 28),
          const SizedBox(width: 12),
          Text(
            feedbackText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: feedbackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
      BuildContext context, int level, int screenNum, ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12.0),
      child: Text(
        '${l10n.level}: $level / ${l10n.screen}: $screenNum',
        style: theme.textTheme.bodyMedium?.copyWith(
          color:
              theme.textTheme.bodyMedium?.color?.withAlpha((0.7 * 255).round()),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
