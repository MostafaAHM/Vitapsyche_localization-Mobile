class PersonalityDisorderResult {
  final String type;
  final List<int> questionIndexes;
  final int threshold;
  final int score;
  final bool diagnosed;

  PersonalityDisorderResult({
    required this.type,
    required this.questionIndexes,
    required this.threshold,
    required this.score,
    required this.diagnosed,
  });
}
