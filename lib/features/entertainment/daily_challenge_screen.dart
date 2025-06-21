import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'daily_challenge.dart';

class DailyChallengeScreen extends StatefulWidget {
  @override
  _DailyChallengeScreenState createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  late DailyChallenge currentChallenge;
  final TextEditingController _responseController = TextEditingController();
  bool showReward = false;
  late List<DailyChallenge> challenges;

  @override
  void initState() {
    super.initState();
    _loadCurrentChallenge();
  }

  void _initializeChallenges(BuildContext context) {
    final localizations = S.of(context);
    challenges = [
      DailyChallenge(
        title: localizations.deepBreathingChallenge,
        description: localizations.deepBreathingDescription,
        reward: localizations.deepBreathingReward,
        date: DateTime.now(),
      ),
      DailyChallenge(
        title: localizations.journalingChallenge,
        description: localizations.journalingDescription,
        reward: localizations.journalingReward,
        date: DateTime.now(),
      ),
    ];
  }

  Future<void> _loadCurrentChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final savedChallengeJson = prefs.getString('currentChallenge');

    if (savedChallengeJson != null) {
      final savedChallenge =
          DailyChallenge.fromJson(json.decode(savedChallengeJson));
      if (savedChallenge.date.day == DateTime.now().day) {
        setState(() {
          currentChallenge = savedChallenge;
        });
        return;
      }
    }

    // Challenges will be initialized in build method
    if (mounted) {
      setState(() {
        currentChallenge = challenges[DateTime.now().day % challenges.length];
      });
      _saveCurrentChallenge();
    }
  }

  Future<void> _saveCurrentChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'currentChallenge', json.encode(currentChallenge.toJson()));
  }

  void _completeChallenge() {
    if (_responseController.text.isNotEmpty) {
      setState(() {
        currentChallenge = DailyChallenge(
          title: currentChallenge.title,
          description: currentChallenge.description,
          reward: currentChallenge.reward,
          isCompleted: true,
          date: currentChallenge.date,
        );
        showReward = true;
      });
      _saveCurrentChallenge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    _initializeChallenges(context);

    if (currentChallenge == null) {
      currentChallenge = challenges[DateTime.now().day % challenges.length];
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          localizations.dailyChallengeTitle,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.journalingChallenge,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          localizations.journalingDescription,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (!currentChallenge.isCompleted) ...[
                  TextField(
                    controller: _responseController,
                    maxLines: 3,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: localizations.writeResponseHere,
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _completeChallenge,
                    child: Text(
                      localizations.completeChallenge,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
                if (showReward) ...[
                  SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: primaryColor,
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.star,
                            size: 48,
                            color: Colors.yellowAccent,
                          ),
                          SizedBox(height: 8),
                          Text(
                            localizations.yourReward,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            currentChallenge.reward,
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }
}
