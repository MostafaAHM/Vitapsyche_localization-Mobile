import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter_mindmed_project/generated/l10n.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({Key? key}) : super(key: key);

  @override
  MemoryGameState createState() => MemoryGameState();
}

class MemoryGameState extends State<MemoryGame> {
  final List<String> _emojis = [
    '🌸',
    '🌺',
    '🌹',
    '🌷',
    '🌼',
    '🌻',
    '🌸',
    '🌺',
    '🌹',
    '🌷',
    '🌼',
    '🌻',
  ];

  List<bool> _isFlipped = [];
  List<int> _flippedCards = [];
  int _pairs = 0;
  bool _isProcessing = false;
  int _moves = 0;
  Timer? _gameTimer;
  int _secondsElapsed = 0;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _emojis.shuffle();
    _isFlipped = List.generate(_emojis.length, (index) => false);
    _flippedCards = [];
    _pairs = 0;
    _moves = 0;
    _isProcessing = false;
    _secondsElapsed = 0;
    _gameStarted = false;
    _gameTimer?.cancel();
  }

  void _startGameTimer() {
    if (!_gameStarted) {
      _gameStarted = true;
      _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _secondsElapsed++;
        });
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onCardTap(int index) {
    if (_isProcessing || _isFlipped[index] || _flippedCards.length >= 2) {
      return;
    }
    _startGameTimer();
    setState(() {
      _isFlipped[index] = true;
      _flippedCards.add(index);
    });
    if (_flippedCards.length == 2) {
      _moves++;
      _isProcessing = true;
      Timer(const Duration(milliseconds: 1000), () {
        _checkMatch();
        setState(() {
          _isProcessing = false;
        });
      });
    }
  }

  void _checkMatch() {
    if (_emojis[_flippedCards[0]] == _emojis[_flippedCards[1]]) {
      _pairs++;
      if (_pairs == _emojis.length ~/ 2) {
        _gameTimer?.cancel();
      }
    } else {
      setState(() {
        _isFlipped[_flippedCards[0]] = false;
        _isFlipped[_flippedCards[1]] = false;
      });
    }
    _flippedCards = [];
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text(localizations.memoryGame,
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(localizations.time,
                      _formatTime(_secondsElapsed), Icons.timer),
                  _buildStatCard(
                      localizations.moves, _moves.toString(), Icons.touch_app),
                  _buildStatCard(localizations.pairs,
                      '$_pairs/${_emojis.length ~/ 2}', Icons.favorite),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _emojis.length,
                itemBuilder: (context, index) {
                  return _buildCard(index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _initializeGame();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: Text(localizations.playAgain),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal[300]),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCard(int index) {
    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _isFlipped[index] ? Colors.white : Colors.teal[300],
        child: Center(
          child: _isFlipped[index]
              ? Text(_emojis[index], style: const TextStyle(fontSize: 40))
              : Icon(Icons.question_mark, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
