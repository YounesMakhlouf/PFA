import 'package:flutter/material.dart';
import 'package:pfa/screens/home_screen.dart';
import 'package:pfa/screens/auth_screen.dart';
import 'package:pfa/games/multiple_choice_game.dart';

class AppRoutes {
  static const String home = '/';
  static const String auth = '/auth';
  static const String multipleChoiceGame = '/game/multiple-choice';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      auth: (context) => const AuthScreen(),
      multipleChoiceGame: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final gameId = args?['gameId'] as String?;

        if (gameId == null) {
          return const Scaffold(
              body: Center(child: Text("Error: Game ID missing")));
        }
        return MultipleChoiceGame(gameId: gameId);
      },
    };
  }
}

class GameIds {
  static const String colorsGame =
      '4a5e6b80-7c1f-4d3a-9b9e-5c8f9a0d1b2c'; // TODO: Use better logic and get rid of this
}
