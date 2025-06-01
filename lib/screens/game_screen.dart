import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/config/app_theme.dart';
import 'package:pfa/constants/const.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/viewmodels/game_state.dart';
import 'package:pfa/widgets/option_widget.dart';

class GameScreenWidget extends ConsumerStatefulWidget {
  final Game game;
  final Screen currentScreen;
  final List<Option> currentOptions;
  final int currentLevel;
  final int currentScreenNumber;
  final bool? isCorrect;
  final Function(Option) onOptionSelected;
  // Memory Game specific state
  final List<Option> selectedMemoryCards;
  final bool isMemoryPairAttempted;
  final Set<String> matchedPairIds;

  const GameScreenWidget({
    super.key,
    required this.game,
    required this.currentScreen,
    required this.currentOptions,
    required this.currentLevel,
    required this.currentScreenNumber,
    required this.onOptionSelected,
    this.isCorrect,
    this.selectedMemoryCards = const [],
    this.isMemoryPairAttempted = false,
    this.matchedPairIds = const {},
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
    final l10n = AppLocalizations.of(context)!;
    final translationService = ref.read(translationServiceProvider);

    final translatedInstruction = widget.currentScreen.instruction != null
        ? translationService.getTranslatedText(
            context, widget.currentScreen.instruction!)
        : l10n.selectCorrectOption;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            translatedInstruction,
            style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryOnLight
                    .withAlpha((0.85 * 255).round())),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 300.ms),
        ),
        Expanded(child: Center(child: _buildScreenContent(context))),
        _buildFeedbackArea(context, widget.isCorrect, theme),
        _buildProgressIndicator(
            context, widget.currentLevel, widget.currentScreenNumber, theme),
      ],
    );
  }

  Widget _buildScreenContent(BuildContext context) {
    final screen = widget.currentScreen;
    final l10n = AppLocalizations.of(context)!;

    if (screen is MultipleChoiceScreen) {
      return _buildMultipleChoiceUI(context, screen);
    } else if (screen is MemoryScreen) {
      return _buildMemoryUI(context, screen);
    } else {
      return ErrorScreen(errorMessage: l10n.unknownScreenType);
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

  Widget _buildMemoryUI(BuildContext context, MemoryScreen screen) {
    final theme = Theme.of(context);
    final options = widget.currentOptions;

    int crossAxisCount = 6;
    if (options.length > 12) {
      crossAxisCount = 4;
    } else if (options.length > 6) {
      crossAxisCount = 3;
    } else if (options.length <= 2) {
      crossAxisCount = options.length;
    }

    double childAspectRatio = 1.0;
    if (MediaQuery.of(context).size.height < 400 && options.length > 8) {
      // Very short screen
      childAspectRatio = 1.2; // Make cards wider
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];

          final bool isSelected = widget.selectedMemoryCards
              .any((selected) => selected.optionId == option.optionId);
          final bool isMatched = option.pairId != null &&
              widget.matchedPairIds.contains(option.pairId!);
          final bool isRevealed = isSelected || isMatched;
          // Disable further taps if:
          // 1. A pair attempt is in progress AND this card is not one of the selected ones
          // 2. This card is already matched
          final bool isDisabled =
              (widget.isMemoryPairAttempted && !isSelected) || isMatched;

          return OptionWidget(
            option: option,
            onTap: () => widget.onOptionSelected(option),
            gameThemeColor: theme.colorScheme.primary,
            size: 80,
            isSelected: isSelected,
            isDisabled: isDisabled,
            isRevealed: isRevealed,
            isMatched: isMatched,
          ).animate().fadeIn(
              duration: 300.ms, delay: (index * 50).ms); // Staggered fade-in
        },
      ),
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
              gameThemeColor: AppColors.primary,
              isStory: isStory,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeedbackArea(
      BuildContext context, bool? isCorrect, ThemeData theme) {
    // Key for AnimatedSwitcher to ensure widgets are treated as different
    // when isCorrect changes from null -> true/false or true -> false.
    final Key feedbackKey = ValueKey<bool?>(isCorrect);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: isCorrect == null
          ? SizedBox(key: feedbackKey, height: 60)
          : _buildFeedbackContent(context, isCorrect, theme, feedbackKey),
    );
  }

  Widget _buildFeedbackContent(
      BuildContext context, bool? isCorrect, ThemeData theme, Key key) {
    final Color feedbackColor =
        isCorrect == true ? AppColors.success : AppColors.error;

    final String feedbackText;
    final String feedbackEmoji;
    if (isCorrect == null) return const SizedBox.shrink();

    if (isCorrect) {
      feedbackText = AppLocalizations.of(context)!.correct;
      feedbackEmoji = (positiveEmojisList..shuffle()).first;
    } else {
      feedbackText = AppLocalizations.of(context)!.tryAgain;
      feedbackEmoji = (neutralEmojisList..shuffle()).first;
    }
    final String fullFeedbackText = '$feedbackText $feedbackEmoji';

    final IconData feedbackIconData =
        isCorrect ? Icons.check_circle_outline : Icons.highlight_off;

    return Container(
      key: key,
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
          Icon(feedbackIconData, color: feedbackColor, size: 32)
              .animate()
              .scale(
                duration: 400.ms,
                begin: const Offset(0.5, 0.5),
                curve: Curves.elasticOut,
              )
              .then(delay: 200.ms)
              .shake(hz: 4, duration: 300.ms),
          const SizedBox(width: 12),
          Text(
            fullFeedbackText,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: feedbackColor),
          ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(
              begin: 0.2,
              end: 0,
              duration: 300.ms,
              delay: 100.ms,
              curve: Curves.easeOut),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
      BuildContext context, int level, int screenNum, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

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
