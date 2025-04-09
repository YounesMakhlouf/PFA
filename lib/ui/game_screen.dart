import 'package:flutter/material.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/l10n/app_localizations.dart';

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
    if (currentScreen is MultipleChoiceScreen) {
      return _buildMultipleChoiceScreen(
          context, currentScreen as MultipleChoiceScreen);
    } else if (currentScreen is MemoryScreen) {
      return _buildMemoryScreen(context, currentScreen as MemoryScreen);
    } else {
      return Center(
          child: Text(AppLocalizations.of(context).unknownScreenType));
    }
  }

  Widget _buildMultipleChoiceScreen(
      BuildContext context, MultipleChoiceScreen screen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Question or prompt
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            screen.correctAnswer.labelText ?? '',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 24),

        // Options
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: screen.options.map((option) {
            // For colors game, use colored circles
            if (game.category == GameCategory.COLORS_SHAPES) {
              Color color;
              switch (option.labelText) {
                case 'أحمر':
                  color = Colors.red;
                  break;
                case 'أخضر':
                  color = Colors.green;
                  break;
                case 'أصفر':
                  color = Colors.yellow;
                  break;
                case 'أزرق':
                  color = Colors.blue;
                  break;
                case 'بنفسجي':
                  color = Colors.purple;
                  break;
                default:
                  color = Colors.grey;
              }

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onOptionSelected(option),
                  borderRadius: BorderRadius.circular(40),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    width: 80,
                    height: 80,
                  ),
                ),
              );
            } else {
              // For other games, use cards with text
              return ElevatedButton(
                onPressed: () => onOptionSelected(option),
                style: ElevatedButton.styleFrom(
                  backgroundColor: game.themeColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  option.labelText ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Feedback area
        if (isCorrect != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCorrect!
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isCorrect!
                  ? AppLocalizations.of(context).correct
                  : AppLocalizations.of(context).tryAgain,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCorrect! ? Colors.green : Colors.red,
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Progress indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${AppLocalizations.of(context).level}: $currentLevel',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${AppLocalizations.of(context).screen}: $currentScreenNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryScreen(BuildContext context, MemoryScreen screen) {
    // Implement memory game UI here
    return Center(
        child: Text(AppLocalizations.of(context).memoryGameUnderDevelopment));
  }
}
