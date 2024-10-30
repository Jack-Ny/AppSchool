// lib/models/quiz_models.dart
enum QuestionType {
  multipleChoice, // Choix multiples
  trueFalse, // Vrai/Faux
  textInput // Saisie de texte
}

class QuizQuestion {
  final String questionText;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final int questionNumber;
  final int totalQuestions;

  QuizQuestion({
    required this.questionText,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.questionNumber,
    required this.totalQuestions,
  });
}
