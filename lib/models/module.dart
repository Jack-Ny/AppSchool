import 'package:app_school/models/quiz.dart';
import 'package:app_school/models/tp.dart';

class Module {
  final String? id;
  final String courseId;
  final String name;
  final String? description;
  final int orderIndex;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Quiz> quizzes;
  final List<TP> tps;

  Module({
    this.id,
    required this.courseId,
    required this.name,
    this.description,
    this.orderIndex = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.quizzes = const [],
    this.tps = const [],
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      courseId: json['course_id'],
      name: json['name'],
      description: json['description'],
      orderIndex: json['order_index'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      quizzes:
          (json['quizzes'] as List?)?.map((q) => Quiz.fromJson(q)).toList() ??
              [],
      tps: (json['tps'] as List?)?.map((t) => TP.fromJson(t)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'course_id': courseId,
      'name': name,
      if (description != null) 'description': description,
      'order_index': orderIndex,
      'is_active': isActive,
    };
  }
}
