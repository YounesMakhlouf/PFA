import 'package:flutter/material.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/ui/option_widget.dart';
import 'package:pfa/config/app_theme.dart';

class GameScreenWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenData = currentScreen;
    final theme = Theme.of(context);

    if (screenData is MultipleChoiceScreen) {
      return _buildMultipleChoiceUI(context, screenData,
          theme); // TODO: We will later add the logic here for memory games
    } else {
      return Center(
          child: Text(
        AppLocalizations.of(context).unknownScreenType,
        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
      ));
    }
  }

  // --- Builder for Multiple Choice UI ---
  Widget _buildMultipleChoiceUI(
      BuildContext context, MultipleChoiceScreen screen, ThemeData theme) {
    final String prompt =
        screen.instruction ?? AppLocalizations.of(context).selectCorrectOption;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            prompt,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOptionsArea(context, screen.options),
                _buildFeedbackArea(context, isCorrect),
              ],
            ),
          ),
        ),
        _buildProgressIndicator(context, currentLevel, currentScreenNumber),
      ],
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
          onTap: () => onOptionSelected(option),
          gameThemeColor: game.themeColor,
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackArea(BuildContext context, bool? isCorrect) {
    if (isCorrect == null) {
      return const SizedBox(height: 60);
    }

    final Color feedbackColor = isCorrect ? Colors.green : Colors.red;
    final String feedbackText = isCorrect
        ? AppLocalizations.of(context).correct
        : AppLocalizations.of(context).tryAgain;
    final IconData feedbackIcon = isCorrect ? Icons.check_circle : Icons.cancel;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: feedbackColor.withAlpha((0.15 * 255).round()),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: feedbackColor.withAlpha((0.5 * 255).round()), width: 1.5)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(feedbackIcon, color: feedbackColor, size: 28),
          const SizedBox(width: 12),
          Text(
            feedbackText,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: feedbackColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
      BuildContext context, int level, int screenNum) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
      child: Text(
        '${l10n.level}: $level / ${l10n.screen}: $screenNum',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
