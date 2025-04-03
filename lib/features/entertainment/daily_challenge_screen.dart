import 'package:flutter/material.dart';
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

  final List<DailyChallenge> challenges = [
    DailyChallenge(
      title: "تحدي التنفس العميق",
      description:
          "خذ 3 دقائق للتركيز على تنفسك. استنشق ببطء لعدّ 4، واحتفظ بالنفس لعدّ 4، ثم أخرجه لعدّ 6.",
      reward: "\"التنفس العميق هو مرساة للهدوء النفسي.\"",
      date: DateTime.now(),
    ),
    DailyChallenge(
      title: "تحدي كتابة المشاعر",
      description: "اكتب في دفتر مذكراتك مشاعرك الحالية دون أي تصحيح أو حكم.",
      reward: "\"عندما تكتب، تمنح مشاعرك المساحة للتعبير.\"",
      date: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentChallenge();
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

    currentChallenge = challenges[DateTime.now().day % challenges.length];
    _saveCurrentChallenge();
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'تحدي اليوم',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
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
                          currentChallenge.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          currentChallenge.description,
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
                      labelText: 'اكتب استجابتك هنا',
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
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _completeChallenge,
                    child: Text(
                      'إكمال التحدي',
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
                    color: Colors.green.withOpacity(0.9),
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
                            'مكافأتك',
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
