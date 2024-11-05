import 'package:app_school/models/quiz.dart';
import 'package:app_school/models/tp.dart';

class Module {
  String name;
  List<Quiz> quizzes;
  List<TP> tps;

  Module({
    required this.name,
    this.quizzes = const [],
    this.tps = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
      'tps': tps.map((tp) => tp.toJson()).toList(),
    };
  }

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      name: json['name'],
      quizzes:
          (json['quizzes'] as List).map((quiz) => Quiz.fromJson(quiz)).toList(),
      tps: (json['tps'] as List).map((tp) => TP.fromJson(tp)).toList(),
    );
  }
}
