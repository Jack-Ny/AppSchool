class Question {
  final String? id;
  final String quizId;
  final String questionText;
  final String questionType;
  final String answer;
  final int points;
  final List<Map<String, dynamic>>? choices;
  final DateTime createdAt;

  Question({
    this.id,
    required this.quizId,
    required this.questionText,
    required this.questionType,
    required this.answer,
    this.points = 1,
    this.choices,
    required this.createdAt,
    required String text,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      quizId: json['quiz_id'],
      questionText: json['question_text'],
      questionType: json['question_type'],
      answer: json['answer'],
      points: json['points'] ?? 1,
      choices: json['choices'] != null
          ? List<Map<String, dynamic>>.from(json['choices'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      text: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'quiz_id': quizId,
      'question_text': questionText,
      'question_type': questionType,
      'answer': answer,
      'points': points,
      if (choices != null) 'choices': choices,
    };
  }
}
