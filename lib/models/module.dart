import 'package:app_school/models/quiz.dart';
import 'package:app_school/models/tp.dart';

class Module {
  final String name;
  final List<Quiz> quizzes;
  final List<TP> tps;

  Module({
    required this.name,
    required this.quizzes,
    required this.tps,
  });
}
