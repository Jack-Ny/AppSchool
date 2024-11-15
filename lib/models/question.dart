import 'package:app_school/models/answer.dart';

class Question {
  final String? id;
  final String text;
  final List<Answer> answers;

  Question({
    this.id,
    required this.text,
    required this.answers,
  });
}
