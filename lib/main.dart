import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'games/colors_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق تعلم التوحد',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Arial',
      ),
      locale: const Locale('ar', 'SA'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Set portrait orientation for home page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFE6F2F5), // Light blue background like in the image
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  'ألعاب التعلم',
                  style: TextStyle(
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
                        title: 'ألوان وأشكال',
                        imagePath: 'assets/images/colors_icon.png',
                        onTap: () {
                          // Set landscape orientation for game
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ColorsGame()),
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
                        title: 'الحيوانات',
                        imagePath: 'assets/images/animals_icon.png',
                        onTap: () {
                          // Will implement later
                        },
                      ),
                      
                      // Fruits and Vegetables Game
                      GameCard(
                        title: 'خضر و غلال',
                        imagePath: 'assets/images/fruits_icon.png',
                        onTap: () {
                          // Will implement later
                        },
                      ),
                      
                      // Numbers Game
                      GameCard(
                        title: 'الأرقام',
                        imagePath: 'assets/images/numbers_icon.png',
                        onTap: () {
                          // Will implement later
                        },
                      ),
                      
                      // Emotions Matching Game
                      GameCard(
                        title: 'تطابق المشاعر',
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
                color: const Color(0xFF7FBCD2), // Teal blue like in the image
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
