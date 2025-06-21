import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const Color primaryColor = Color.fromARGB(255, 32, 192, 172); // Teal
const Color secondaryColor = Color.fromARGB(255, 255, 255, 255); // White

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final List<String> moodEmojis = ['😊', '😐', '😔', '😡', '😴'];
  String selectedMood = '😊';
  String note = '';
  List<Map<String, dynamic>> moodHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('moodHistory');
    if (historyJson != null) {
      setState(() {
        moodHistory = List<Map<String, dynamic>>.from(json.decode(historyJson));
      });
    }
  }

  Future<void> _saveMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = json.encode(moodHistory);
    await prefs.setString('moodHistory', historyJson);
  }

  void _logMood() {
    if (mounted) {
      setState(() {
        moodHistory.add({
          'date': DateTime.now().toString(),
          'mood': selectedMood,
          'note': note,
        });
        _saveMoodHistory();
        note = '';
      });
    }
  }

  List<Map<String, dynamic>> _getWeeklyMoodData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      final dayMoods = moodHistory.where((entry) {
        final entryDate = DateTime.parse(entry['date']);
        return entryDate.year == day.year &&
            entryDate.month == day.month &&
            entryDate.day == day.day;
      }).toList();

      double averageMood = -1;
      if (dayMoods.isNotEmpty) {
        averageMood = dayMoods
                .map((entry) => moodEmojis.indexOf(entry['mood']).toDouble())
                .reduce((a, b) => a + b) /
            dayMoods.length;
      }

      return {
        'day': _getDayAbbreviation(index),
        'value': averageMood,
      };
    });
  }

  String _getDayAbbreviation(int index) {
    final localizations = S.of(context)!;
    return [
      localizations.mondayShort,
      localizations.tuesdayShort,
      localizations.wednesdayShort,
      localizations.thursdayShort,
      localizations.fridayShort,
      localizations.saturdayShort,
      localizations.sundayShort,
    ][index];
  }

  Widget _buildMoodVisualizer() {
    final weeklyData = _getWeeklyMoodData();
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(15),
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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyData.map((data) {
                final value = data['value'] as double;
                final height =
                    value >= 0 ? (value + 1) / moodEmojis.length * 120 : 0.0;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (value >= 0) ...[
                        Text(
                          moodEmojis[value.round()],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        data['day'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getSuggestion() {
    final localizations = S.of(context)!;
    if (moodHistory.isEmpty) {
      return localizations.moodTrackerInitialSuggestion;
    }
    final lastMood = moodHistory.last['mood'];
    switch (lastMood) {
      case '😊':
        return localizations.moodTrackerHappySuggestion;
      case '😐':
        return localizations.moodTrackerNeutralSuggestion;
      case '😔':
        return localizations.moodTrackerSadSuggestion;
      case '😡':
        return localizations.moodTrackerAngrySuggestion;
      case '😴':
        return localizations.moodTrackerTiredSuggestion;
      default:
        return localizations.moodTrackerDefaultSuggestion;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.moodTrackerTitle,
          style: TextStyle(color: textMainColor),
        ),
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
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizations.moodTrackerQuestion,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              children: moodEmojis.map((emoji) {
                return ChoiceChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 24)),
                  selected: selectedMood == emoji,
                  onSelected: (selected) {
                    setState(() {
                      selectedMood = emoji;
                    });
                  },
                  selectedColor: primaryColor.withOpacity(0.3),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: primaryColor),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: localizations.moodTrackerNoteHint,
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.edit, color: primaryColor),
                ),
                onChanged: (value) {
                  setState(() {
                    note = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logMood,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                localizations.moodTrackerLogButton,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              localizations.moodTrackerWeeklyChart,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildMoodVisualizer(),
            const SizedBox(height: 40),
            Text(
              localizations.moodTrackerSuggestionTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getSuggestion(),
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
