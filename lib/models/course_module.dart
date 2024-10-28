// lib/models/course_module.dart
class CourseModule {
  final String title;
  final List<ModuleContent> contents;

  CourseModule({
    required this.title,
    required this.contents,
  });
}

class ModuleContent {
  final String title;
  final ContentType type;
  final bool isCompleted;

  ModuleContent({
    required this.title,
    required this.type,
    this.isCompleted = false,
  });
}

enum ContentType {
  quiz,
  tp,
}
