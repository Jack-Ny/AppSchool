import 'package:app_school/models/module.dart';

class Course {
  final String name;
  final String category;
  final List<Module> modules;

  Course({
    required this.name,
    required this.category,
    required this.modules,
  });
}
