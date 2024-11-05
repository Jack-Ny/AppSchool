import 'package:app_school/models/module.dart';

class Course {
  String name;
  List<Module> modules;

  Course({
    required this.name,
    required this.modules,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      modules: (json['modules'] as List)
          .map((module) => Module.fromJson(module))
          .toList(),
    );
  }
}
