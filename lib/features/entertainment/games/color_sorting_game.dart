import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';

const Color primaryColor = Color.fromARGB(255, 32, 192, 172); // Teal
const Color secondaryColor = Color.fromARGB(255, 255, 255, 255); // White

class ColorSortingGame extends StatefulWidget {
  const ColorSortingGame({Key? key}) : super(key: key);

  @override
  ColorSortingGameState createState() => ColorSortingGameState();
}

class ColorSortingGameState extends State<ColorSortingGame> {
  late List<Color> colors;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _initializeColors();
  }

  void _initializeColors() {
    colors = [
      const Color(0xFF004D40), // Teal Very Dark
      const Color(0xFF00796B), // Teal Dark
      const Color(0xFF009688), // Teal Medium
      const Color(0xFF26A69A), // Teal Light
      const Color(0xFF80CBC4), // Teal Very Light
    ];

    colors.shuffle();
  }

  bool _checkOrder() {
    for (int i = 0; i < colors.length - 1; i++) {
      if (colors[i].computeLuminance() < colors[i + 1].computeLuminance()) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(localizations.colorSorting),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 40,
                  color: primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.sortColorsInstruction,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.dragAndDropInstruction,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Color item = colors.removeAt(oldIndex);
                  colors.insert(newIndex, item);
                  isCorrect = _checkOrder();
                });
              },
              children: colors
                  .map((color) => Container(
                        key: ValueKey(color),
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          if (isCorrect)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    localizations.correctOrderMessage,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _initializeColors();
                  isCorrect = false;
                });
              },
              icon: const Icon(Icons.refresh),
              label: Text(localizations.playAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
