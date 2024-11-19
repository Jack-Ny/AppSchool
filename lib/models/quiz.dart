class Quiz {
  final String? id;
  final String moduleId;
  final String title;
  final int timeLimit;
  final String timeUnit;
  final int passingScore;
  final bool isActive;
  final DateTime createdAt;
  final List<Question> questions;

  Quiz({
    this.id,
    required this.moduleId,
    required this.title,
    this.timeLimit = 30,
    this.timeUnit = 'minutes',
    this.passingScore = 75,
    this.isActive = true,
    required this.createdAt,
    this.questions = const [],
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      moduleId: json['module_id'],
      title: json['title'],
      timeLimit: json['time_limit'] ?? 30,
      timeUnit: json['time_unit'] ?? 'minutes',
      passingScore: json['passing_score'] ?? 75,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      questions: (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'module_id': moduleId,
      'title': title,
      'time_limit': timeLimit,
      'time_unit': timeUnit,
      'passing_score': passingScore,
      'is_active': isActive,
    };
  }
}