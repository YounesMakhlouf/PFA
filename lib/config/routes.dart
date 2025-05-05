import 'package:flutter/material.dart';
import 'package:pfa/screens/auth_gate.dart';
import 'package:pfa/screens/create_child_profile_screen.dart';
import 'package:pfa/screens/error_screen.dart';
import 'package:pfa/screens/home_screen.dart';
import 'package:pfa/screens/welcome_screen.dart';
import 'package:pfa/games/multiple_choice_game.dart';

import '../screens/stats_screen.dart';

class AppRoutes {
  static const String authGate = '/';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String createChildProfile = '/create-child-profile';
  static const String multipleChoiceGame = '/game/multiple-choice';
  static const String stats = '/stats';

  static Map<String, WidgetBuilder> get routes {
    return {
      authGate: (context) => const AuthGate(),
      welcome: (context) => const WelcomeScreen(),
      home: (context) => const HomeScreen(),
      createChildProfile: (context) => const CreateChildProfileScreen(),
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
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final childUuid = args?['childUuid'] as String?;

        if (childUuid == null) {
          return const Scaffold(body: Center(child: Text("Error: Child UUID missing")));
        }

        return StatsScreen(childUuid: childUuid);
      },

    };
  }
}

class GameIds {
  static const String colorsGame =
      '4a5e6b80-7c1f-4d3a-9b9e-5c8f9a0d1b2c'; // TODO: Use better logic and get rid of this
}
