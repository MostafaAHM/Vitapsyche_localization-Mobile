
import '../data/disorders_map.dart';
import 'model/personality_disorder_result.dart';


List<PersonalityDisorderResult> evaluateDisorders(List<int> answers) {
  List<PersonalityDisorderResult> results = [];

  disordersMap.forEach((type, data) {
    List<int> indexes = List<int>.from(data['indexes']);
    int threshold = data['threshold'];

    int score = indexes.fold(0, (sum, i) => sum + (answers[i]));

    results.add(PersonalityDisorderResult(
      type: type,
      questionIndexes: indexes,
      threshold: threshold,
      score: score,
      diagnosed: score >= threshold,
    ));
  });

  return results;
}