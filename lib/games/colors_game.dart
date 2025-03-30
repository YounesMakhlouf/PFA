import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/models/screen.dart';
import 'package:pfa/ui/game_screen.dart';

class ColorsGame extends StatefulWidget {
  const ColorsGame({Key? key}) : super(key: key);

  @override
  State<ColorsGame> createState() => _ColorsGameState();
}

class _ColorsGameState extends State<ColorsGame> {
  // Game data
  late Game game;
  late Level currentLevel;
  late MultipleChoiceScreen currentScreen;
  int currentLevelIndex = 0;
  int currentScreenIndex = 0;
  
  // Track if the answer was correct
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    // Ensure landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeGame();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Initialize the game with levels and screens
  void _initializeGame() {
    // Create color options with empty picture paths since we'll use colored circles
    final redOption = Option(label: 'أحمر', picture: '');
    final greenOption = Option(label: 'أخضر', picture: '');
    final yellowOption = Option(label: 'أصفر', picture: '');
    final blueOption = Option(label: 'أزرق', picture: '');
    final purpleOption = Option(label: 'بنفسجي', picture: '');
    
    // Create screens for level 1
    final screens = [
      MultipleChoiceScreen(
        screenNumber: 1,
        options: [redOption, greenOption, blueOption],
        correctAnswer: redOption,
      ),
      MultipleChoiceScreen(
        screenNumber: 2,
        options: [yellowOption, blueOption, greenOption],
        correctAnswer: greenOption,
      ),
      MultipleChoiceScreen(
        screenNumber: 3,
        options: [blueOption, yellowOption, purpleOption],
        correctAnswer: yellowOption,
      ),
    ];
    
    // Create level
    final level1 = Level(
      levelNumber: 1,
      screens: screens,
    );
    
    // Create game
    game = Game(
      name: 'لعبة الألوان',
      picture: 'assets/images/colors_game.png',
      instruction: 'اختر اللون الصحيح',
      category: GameCategory.COLORS,
      type: GameType.MULTIPLE_CHOICE,
      levels: [level1],
    );
    
    // Set current level and screen
    currentLevel = game.levels[currentLevelIndex];
    currentScreen = currentLevel.screens[currentScreenIndex] as MultipleChoiceScreen;
    
    // Reset feedback
    isCorrect = null;
  }

  // Move to the next screen or level
  void _moveToNextScreen() {
    setState(() {
      // Reset feedback
      isCorrect = null;
      
      // Check if there are more screens in the current level
      if (currentScreenIndex < currentLevel.screens.length - 1) {
        currentScreenIndex++;
        currentScreen = currentLevel.screens[currentScreenIndex] as MultipleChoiceScreen;
      } else if (currentLevelIndex < game.levels.length - 1) {
        // Move to the next level
        currentLevelIndex++;
        currentScreenIndex = 0;
        currentLevel = game.levels[currentLevelIndex];
        currentScreen = currentLevel.screens[currentScreenIndex] as MultipleChoiceScreen;
      } else {
        // Game completed, restart
        currentLevelIndex = 0;
        currentScreenIndex = 0;
        currentLevel = game.levels[currentLevelIndex];
        currentScreen = currentLevel.screens[currentScreenIndex] as MultipleChoiceScreen;
      }
    });
  }

  // Check if the selected option is correct
  void _checkAnswer(Option selectedOption) {
    setState(() {
      isCorrect = selectedOption.label == currentScreen.correctAnswer.label;
      
      // If correct, move to the next screen after a delay
      if (isCorrect!) {
        Future.delayed(const Duration(seconds: 1), () {
          _moveToNextScreen();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        backgroundColor: game.themeColor.withOpacity(0.8),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              game.themeColor.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: GameScreenWidget(
            game: game,
            currentScreen: currentScreen,
            currentLevel: currentLevel.levelNumber,
            currentScreenNumber: currentScreen.screenNumber,
            isCorrect: isCorrect,
            onOptionSelected: _checkAnswer,
          ),
        ),
      ),
    );
  }
}
