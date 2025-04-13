import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa/services/supabase_service.dart';
import 'games/colors_game.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Arial',
      ),
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Container(
        color: const Color(0xFFE6F2F5),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  AppLocalizations.of(context).learningGames,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A9C),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    children: [
                      // Colors and Shapes Game
                      GameCard(
                        title: AppLocalizations.of(context).colorsAndShapes,
                        imagePath: 'assets/images/colors_icon.png',
                        onTap: () {
                          // Set landscape orientation for game
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ColorsGame()),
                          ).then((_) {
                            // Reset to portrait when returning to home
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                          });
                        },
                      ),

                      // Animals Game
                      GameCard(
                        title: AppLocalizations.of(context).animals,
                        imagePath: 'assets/images/animals_icon.png',
                        onTap: () {
                          // Will implement later
                        },
                      ),

                      // Fruits and Vegetables Game
                      GameCard(
                        title: AppLocalizations.of(context).fruitsAndVegetables,
                        imagePath: 'assets/images/fruits_icon.png',
                        onTap: () {
                          // Will implement later
                        },
                      ),

                      // Numbers Game
                      GameCard(
                        title: AppLocalizations.of(context).numbers,
                        imagePath: 'assets/images/numbers_icon.png',
                        onTap: () {
                          // Will implement later
                        },
                      ),

                      // Emotions Matching Game
                      GameCard(
                        title: AppLocalizations.of(context).emotions,
                        imagePath: 'assets/images/emotions_icon.png',
                        onTap: () {
                          // Will implement later
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF7FBCD2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback icon if image not found
                      return const Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2D7A9C),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
