import 'package:app_school/models/question.dart';

class Quiz {
  final String? id;
  final String moduleId;
  final String title;
  final int timeLimit;
  final String timeUnit;
  final int passingScore;
  final bool isActive;
  final DateTime createdAt;
  late final List<Question>? questions;
  final List description;

  Quiz(
      {this.id,
      required this.moduleId,
      required this.title,
      required this.timeLimit,
      required this.timeUnit,
      this.passingScore = 75,
      this.isActive = true,
      required this.createdAt,
      this.questions,
      required this.description});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      moduleId: json['module_id'],
      title: json['title'],
      timeLimit: json['time_limit'],
      timeUnit: json['time_unit'],
      passingScore: json['passing_score'] ?? 75,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      description: json['list'],
    );
  }
}
