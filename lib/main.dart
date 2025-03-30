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
      appBar: AppBar(
        title: const Text('ألعاب التعلم'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Container(
        color: Colors.lightBlue[50],
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
                icon: 'assets/images/colors_icon.png',
                color: Colors.lightBlue,
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
                icon: 'assets/images/animals_icon.png',
                color: Colors.lightBlue,
                onTap: () {
                  // Will implement later
                },
              ),
              
              // Fruits and Vegetables Game
              GameCard(
                title: 'خضر و غلال',
                icon: 'assets/images/fruits_icon.png',
                color: Colors.lightBlue,
                onTap: () {
                  // Will implement later
                },
              ),
              
              // Numbers Game
              GameCard(
                title: 'الأرقام',
                icon: 'assets/images/numbers_icon.png',
                color: Colors.lightBlue,
                onTap: () {
                  // Will implement later
                },
              ),
              
              // Emotions Matching Game
              GameCard(
                title: 'تطابق المشاعر',
                icon: 'assets/images/emotions_icon.png',
                color: Colors.lightBlue,
                onTap: () {
                  // Will implement later
                },
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
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  icon,
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
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
