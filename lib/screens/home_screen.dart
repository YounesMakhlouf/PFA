import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/l10n/app_localizations.dart';
import 'package:pfa/config/routes.dart';
import 'package:pfa/ui/game_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final List<Map<String, dynamic>> gameData = [
      {
        'title': AppLocalizations.of(context).colorsAndShapes,
        'imagePath': 'assets/images/colors_icon.png',
        'iconData': Icons.color_lens_outlined,
        'route': AppRoutes.multipleChoiceGame,
        'args': {'gameId': GameIds.colorsGame},
      },
      {
        'title': AppLocalizations.of(context).animals,
        'imagePath': 'assets/images/animals_icon.png',
        'iconData': Icons.pets,
        'route': null,
        'args': null,
      }, // TODO: Change these to be retrieved from the database
      {
        'title': AppLocalizations.of(context).statsTitle,
        'imagePath': 'assets/images/stats_icon.png',
        'iconData': Icons.bar_chart,
        'route': AppRoutes.stats,
        'args': {
          'childUuid': '33333333-3333-3333-3333-333333333333'//TODO: get this from the app's global state
        },
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
              child: Text(
                AppLocalizations.of(context).learningGames,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: gameData.length,
                  itemBuilder: (context, index) {
                    final game = gameData[index];
                    final bool isEnabled = game['route'] != null;

                    return GameCardWidget(
                      title: game['title'],
                      imagePath: game['imagePath'],
                      iconData: game['iconData'],
                      backgroundColor: game['backgroundColor'],
                      foregroundColor: game['foregroundColor'],
                      isEnabled: isEnabled,
                      onTap: isEnabled
                          ? () => _navigateToGame(
                              context, game['route'], game['args'])
                          : null,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGame(
      BuildContext context, String routeName, dynamic arguments) {
    final navigator = Navigator.of(context);
    if (routeName == AppRoutes.stats) {
      navigator.pushNamed(routeName, arguments: arguments);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((_) {
        if (!mounted) return;
        navigator.pushNamed(routeName, arguments: arguments);
      });
    }
  }
}
