class TP {
  final String? id;
  final String moduleId;
  final String title;
  final String description;
  final DateTime? dueDate;
  final int? maxPoints;
  final bool isActive;
  final DateTime createdAt;
  final DateTime deadline;

  TP({
    this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    this.dueDate,
    this.maxPoints,
    this.isActive = true,
    required this.createdAt,
    required this.deadline,
  });

  factory TP.fromJson(Map<String, dynamic> json) {
    return TP(
      id: json['id'],
      moduleId: json['module_id'],
      title: json['title'],
      description: json['description'],
      dueDate:
          json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      maxPoints: json['max_points'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      deadline: DateTime.parse(json['deadline']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'module_id': moduleId,
      'title': title,
      'description': description,
      if (dueDate != null) 'due_date': dueDate!.toIso8601String(),
      if (maxPoints != null) 'max_points': maxPoints,
      'is_active': isActive,
    };
  }
}
