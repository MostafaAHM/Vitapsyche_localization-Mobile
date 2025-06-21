class Test {
  String testTitle;
  bool payment;
  List<Question> questions;
  List<ScoreRange> scoreRanges;
  int max;

  Test({
    required this.testTitle,
    required this.payment,
    required this.questions,
    required this.scoreRanges,
    required this.max,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      testTitle: json['testTitle'] ?? 'Unknown Test',
      payment: json['payment'] ?? false,
      questions: json['questions'] is List
          ? (json['questions'] as List)
              .map((q) => Question.fromJson(q))
              .toList()
          : [], // Default to an empty list if not a List
      scoreRanges: json['scoreRanges'] is List
          ? (json['scoreRanges'] as List)
              .map((r) => ScoreRange.fromJson(r))
              .toList()
          : [], // Default to an empty list if not a List
      max: json['max'] ?? 0,
    );
  }
}

class Question {
  int id;
  String question;
  List<Choice> choices;

  Question({
    required this.id,
    required this.question,
    required this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      choices: (json['choices'] as List)
          .map((choiceJson) => Choice.fromJson(choiceJson))
          .toList(),
    );
  }
}

class Choice {
  int score;
  String text;

  Choice({
    required this.score,
    required this.text,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      score: json['score'],
      text: json['text'] ?? 'no text',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'text': text,
    };
  }
}

class ScoreRange {
  List<int>? range;
  String? description;
  String? color;
  String? info;

  ScoreRange({
    required this.range,
    required this.description,
    required this.color,
    required this.info,
  });

  factory ScoreRange.fromJson(Map<String, dynamic> json) {
    return ScoreRange(
      range: (json['range'] != null) ? List<int>.from(json['range']) : [0, -1],
      description: json['description'] ?? 'no description',
      color: json['color'] ?? 'no color',
      info: json['info'] ?? 'no info',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range,
      'description': description,
      'color': color,
      'info': info,
    };
  }
}
