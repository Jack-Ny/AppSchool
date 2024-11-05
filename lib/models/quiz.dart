enum QuestionType { trueFalse, singleAnswer, selection }

class Quiz {
  String title;
  List<Question> questions;
  int timeLimit;
  String timeUnit;
  int passingScore;
  bool isCompleted;

  Quiz({
    required this.title,
    required this.questions,
    required this.timeLimit,
    required this.timeUnit,
    this.passingScore = 75,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'questions': questions.map((question) => question.toJson()).toList(),
      'timeLimit': timeLimit,
      'timeUnit': timeUnit,
      'passingScore': passingScore,
      'isCompleted': isCompleted, // serialisation du champ isCompleted
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      title: json['title'],
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
      timeLimit: json['timeLimit'],
      timeUnit: json['timeUnit'],
      passingScore: json['passingScore'],
      isCompleted: json['isCompleted'] ??
          false, // deserialisation avec valeur par defaut false
    );
  }
}

class Question {
  String questionText;
  QuestionType type;
  dynamic answer;
  int points;
  List<String>? choices;

  Question({
    required this.questionText,
    required this.type,
    required this.answer,
    required this.points,
    this.choices,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'type': type.toString(),
      'answer': answer,
      'points': points,
      'choices': choices,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      answer: json['answer'],
      points: json['points'],
      choices:
          json['choices'] != null ? List<String>.from(json['choices']) : null,
    );
  }
}
