import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../data/model/personality_disorder_result.dart';
import '../../data/disorder_evaluator.dart';

class PersonalityDisorderResultScreen extends StatelessWidget {
  final Map<int, String> answers;

  const PersonalityDisorderResultScreen({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    // نحول Map<int, String> إلى List<String> للإجابات مرتبة
    final List<int> orderedAnswers = List.generate(120, (index) {
      final answer = answers[index]?.toLowerCase();
      return answer == "yes" ? 1 : 0;
    });

    final List<PersonalityDisorderResult> results =
        evaluateDisorders(orderedAnswers);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secoundryColor,
        foregroundColor: primaryColor,
        title: Text(localizations.personalityDisordersResult),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            localizations.yourScoreIs,
            style: TextStyle(
                color: mainBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: 26),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  color: result.diagnosed ? Colors.red[50] : Colors.green[50],
                  child: ListTile(
                    title: Text(
                      result.type,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${localizations.score}: ${result.score}/${result.threshold}",
                      style: TextStyle(
                        color: result.diagnosed ? Colors.red : Colors.green,
                      ),
                    ),
                    trailing: Icon(
                      result.diagnosed ? Icons.warning : Icons.check_circle,
                      color: result.diagnosed ? Colors.red : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
