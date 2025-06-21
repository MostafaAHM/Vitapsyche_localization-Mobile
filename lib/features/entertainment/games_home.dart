import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'games/color_sorting_game.dart';
import 'games/breathing_game.dart';
import 'games/memory_game.dart';

const Color primaryColor = Color.fromARGB(255, 32, 192, 172); // Teal
const Color secondaryColor = Color.fromARGB(255, 255, 255, 255); // White

class GamesHome extends StatelessWidget {
  const GamesHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                localizations.psychologicalGames,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                localizations.chooseGameToStart,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildGameCard(
                      context,
                      localizations.colorSorting,
                      localizations.improveFocus,
                      Icons.palette,
                      primaryColor,
                      const ColorSortingGame(),
                    ),
                    _buildGameCard(
                      context,
                      localizations.synchronizedBreathing,
                      localizations.relaxationAndCalm,
                      Icons.air,
                      primaryColor,
                      const BreathingGame(),
                    ),
                    _buildGameCard(
                      context,
                      localizations.memoryGame,
                      localizations.activateMemory,
                      Icons.memory,
                      primaryColor,
                      const MemoryGame(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget game,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => game),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
