class TP {
  String title;
  String description;
  DateTime? dueDate;
  int? maxPoints;
  bool isCompleted;

  TP({
    required this.title,
    required this.description,
    this.dueDate,
    this.maxPoints,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'maxPoints': maxPoints,
      'isCompleted': isCompleted,
    };
  }

  factory TP.fromJson(Map<String, dynamic> json) {
    return TP(
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      maxPoints: json['maxPoints'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
