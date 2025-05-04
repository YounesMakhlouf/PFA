import 'package:flutter/material.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/widgets/option_widget.dart';
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
    final l10n = AppLocalizations.of(context);

    Widget screenContent;
    if (screenData is MultipleChoiceScreen) {
      screenContent = _buildMultipleChoiceUI(context, screenData, theme);
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
        _buildFeedbackArea(context, isCorrect, theme),
        _buildProgressIndicator(
            context, currentLevel, currentScreenNumber, theme),
      ],
    );
  }

  // --- Builder for Multiple Choice UI ---
  Widget _buildMultipleChoiceUI(
      BuildContext context, MultipleChoiceScreen screen, ThemeData theme) {
    return Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _buildOptionsArea(context, screen.options)));
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
              color: feedbackColor.withAlpha((0.5 * 255).round()), width: 1.5)),
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
}
