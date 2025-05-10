import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/providers/global_providers.dart';
import 'package:pfa/view_models/game_screen/game_screen_state.dart';
import 'package:pfa/view_models/game_screen/game_screen_view_model.dart';
import 'package:pfa/widgets/option_widget.dart';
import 'package:pfa/config/app_theme.dart';

class GameScreenWidget extends ConsumerStatefulWidget {
  final Game game;
  final Screen currentScreen;
  final int currentLevel;
  final int currentScreenNumber;
  final bool? isCorrect;
  final Function(Option) onOptionSelected;

  const GameScreenWidget({
    super.key,
    required this.game,
    required this.currentScreen,
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
    Future.microtask(() {
      ref.read(gameScreenViewModelProvider.notifier).initCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(gameScreenViewModelProvider.notifier);
    final state = ref.watch(gameScreenViewModelProvider);

    final screenData = widget.currentScreen;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    Widget screenContent;
    if (screenData is MultipleChoiceScreen) {
      screenContent =
          _buildMultipleChoiceUI(context, screenData, theme, viewModel, state);
    } else {
      screenContent = Center(
        child: Text(
          l10n.unknownScreenType,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            screenData.instruction ?? l10n.selectCorrectOption,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: screenContent,
        ),
        _buildFeedbackArea(context, widget.isCorrect, theme),
        _buildProgressIndicator(
            context, widget.currentLevel, widget.currentScreenNumber, theme),
      ],
    );
  }

  Widget _buildMultipleChoiceUI(
    BuildContext context,
    MultipleChoiceScreen screen,
    ThemeData theme,
    GameScreenViewModel viewModel,
    GameScreenState state,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            if (widget.game.category == GameCategory.EMOTIONS)
              _buildCameraOptionRow(context, screen, viewModel, state),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsArea(BuildContext context, List<Option> options) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 90,
      runSpacing: 90,
      children: options.map((option) {
        return OptionWidget(
          option: option,
          onTap: () => widget.onOptionSelected(option),
          gameThemeColor: widget.game.themeColor,
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackArea(
      BuildContext context, bool? isCorrect, ThemeData theme) {
    final Color successColor = AppColors.success;
    final Color errorColor = theme.colorScheme.error;

    if (isCorrect == null) {
      return const SizedBox.shrink();
    }

    final Color feedbackColor = isCorrect ? successColor : errorColor;
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color
                  ?.withAlpha((0.7 * 255).round()),
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCameraOptionRow(
    BuildContext context,
    MultipleChoiceScreen screen,
    GameScreenViewModel viewModel,
    GameScreenState state,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        // Dynamic camera size
        double cameraSize = screenWidth * 0.4;
        if (cameraSize > 250) cameraSize = 250;
        if (cameraSize < 120) cameraSize = 120;

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            // Camera preview + capture button + emotion text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                state.isCameraInitialized && state.cameraController != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: cameraSize,
                          height: cameraSize,
                          child: CameraPreview(state.cameraController!),
                        ),
                      )
                    : SizedBox(
                        width: cameraSize,
                        height: cameraSize,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: viewModel.takePhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.game.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text("Capture"),
                ),
                const SizedBox(height: 12),
                Text(
                  state.detectedEmotion ?? "no emotion detected",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Options area
            if (screen.options.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [_buildOptionsArea(context, screen.options)],
              ),
          ],
        );
      },
    );
  }
}
