import 'package:flutter/material.dart';
import 'package:pfa/models/game.dart';
import 'package:pfa/screens/auth_gate.dart';
import 'package:pfa/screens/category_screen.dart';
import 'package:pfa/screens/create_child_profile_screen.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/home_screen.dart';
import 'package:pfa/screens/select_child_profile_screen.dart';
import 'package:pfa/screens/settings_screen.dart';
import 'package:pfa/screens/welcome_screen.dart';
import 'package:pfa/games/multiple_choice_game.dart';

import '../screens/stats_screen.dart';

class AppRoutes {
  static const String authGate = '/auth';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String categoryGames = '/category-games';
  static const String createChildProfile = '/create-child-profile';
  static const String selectChildProfile = '/select-child-profile';
  static const String multipleChoiceGame = '/game/multiple-choice';
  static const String stats = '/stats';
  static const String settings = '/settings';
  static const String emotionDetectionGame = '/game/emotion-detection';

  static Map<String, WidgetBuilder> get routes {
    return {
      authGate: (context) => const AuthGate(),
      welcome: (context) => const WelcomeScreen(),
      home: (context) => const HomeScreen(),
      createChildProfile: (context) => const CreateChildProfileScreen(),
      settings: (context) => const SettingsScreen(),
      selectChildProfile: (context) => const SelectChildProfileScreen(),
      categoryGames: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final category = args?['category'] as GameCategory?;
        if (category == null) {
          return ErrorScreen(errorMessage: "Error: Category missing");
        }
        return CategoryGamesScreen(category: category);
      },
      multipleChoiceGame: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final gameId = args?['gameId'] as String?;

        if (gameId == null) {
          return ErrorScreen(
            errorMessage: 'Error: Game category or ID missing',
          );
        }
        return MultipleChoiceGame(gameId: gameId);
      },
      stats: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final childUuid = args?['childUuid'] as String?;

        if (childUuid == null) {
          return ErrorScreen(errorMessage: "Child identifier is missing");
        }

        return StatsScreen(childUuid: childUuid);
      },
    };
  }
}
