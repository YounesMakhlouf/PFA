import 'package:flutter/material.dart';

class ColorsGame extends StatefulWidget {
  const ColorsGame({Key? key}) : super(key: key);

  @override
  State<ColorsGame> createState() => _ColorsGameState();
}

class _ColorsGameState extends State<ColorsGame> {
  // List of colors to learn
  final List<ColorItem> colors = [
    ColorItem(color: Colors.red, nameEn: 'Red', nameAr: 'أحمر'),
    ColorItem(color: Colors.green, nameEn: 'Green', nameAr: 'أخضر'),
    ColorItem(color: Colors.yellow, nameEn: 'Yellow', nameAr: 'أصفر'),
    // Can add more colors later
  ];

  // Current color to identify
  late ColorItem currentColor;
  // Available options (including the correct one)
  late List<Color> options;
  // Track if the answer was correct
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _setupNewRound();
  }

  void _setupNewRound() {
    // Randomly select a color to identify
    currentColor =
        colors[DateTime.now().millisecondsSinceEpoch % colors.length];

    // Create options including the correct color
    options = [
      Colors.red,
      Colors.green,
      Colors.yellow,
    ];

    // Reset the answer state
    isCorrect = null;
  }

  void _checkAnswer(Color selectedColor) {
    setState(() {
      isCorrect = selectedColor == currentColor.color;

      // After a short delay, set up a new round if correct
      if (isCorrect == true) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _setupNewRound();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colors Game'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Container(
        color: Colors.lightBlue[
            50], // Light blue background as per autism-friendly colors
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the color name to identify
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  currentColor.nameAr,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Display color options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: options.map((color) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GestureDetector(
                      onTap: () => _checkAnswer(color),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // Feedback area
              if (isCorrect != null)
                Text(
                  isCorrect! ? 'Correct! 👏' : 'Try again! 🤔',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCorrect! ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model class for color items
class ColorItem {
  final Color color;
  final String nameEn;
  final String nameAr;

  ColorItem({
    required this.color,
    required this.nameEn,
    required this.nameAr,
  });
}
