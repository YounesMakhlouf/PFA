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
    ColorItem(color: Colors.blue, nameEn: 'Blue', nameAr: 'أزرق'),
    ColorItem(color: Colors.purple, nameEn: 'Purple', nameAr: 'بنفسجي'),
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

  // Set up a new round with random colors
  void _setupNewRound() {
    // Reset feedback
    isCorrect = null;

    // Select a random color as the correct answer
    currentColor =
        colors[DateTime.now().millisecondsSinceEpoch % colors.length];

    // Create options including the correct answer and some wrong answers
    options = [currentColor.color];

    // Add other random colors as options
    while (options.length < 3) {
      final randomColor =
          colors[DateTime.now().millisecondsSinceEpoch % colors.length].color;
      if (!options.contains(randomColor)) {
        options.add(randomColor);
      }
    }

    // Shuffle options to randomize position
    options.shuffle();
  }

  // Check if the selected color is correct
  void _checkAnswer(Color selectedColor) {
    setState(() {
      isCorrect = selectedColor == currentColor.color;

      // If correct, set up a new round after a delay
      if (isCorrect!) {
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
        title: const Text('لعبة الألوان'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Container(
        color: Colors.lightBlue[
            50], // Light blue background as per autism-friendly colors
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the color name to identify
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    currentColor.nameAr,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Display color options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: options.map((color) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
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

                const SizedBox(height: 20),

                // Feedback area
                if (isCorrect != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      isCorrect! ? 'صحيح! 👏' : 'حاول مرة أخرى! 🤔',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isCorrect! ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
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
