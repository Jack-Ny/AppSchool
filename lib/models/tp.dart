import 'dart:io';

import 'package:uuid/uuid.dart';

import 'module.dart';
import 'tp_submission.dart';

class TP {
  String id;
  String? moduleId;
  String title;
  String description;
  DateTime? dueDate;
  int? maxPoints;
  bool isActive;
  DateTime createdAt;
  List<String> fileUrls;
  List<File>? files;

  // Relations
  Module? module;
  List<TPSubmission> submissions;

  TP({
    String? id,
    this.moduleId,
    required this.title,
    required this.description,
    this.dueDate,
    this.maxPoints,
    this.isActive = true,
    DateTime? createdAt,
    List<String>? fileUrls,
    this.files,
    this.module,
    this.submissions = const [],
  })  : this.id = id ?? const Uuid().v4(),
        this.createdAt = createdAt ?? DateTime.now(),
        this.fileUrls = fileUrls ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'max_points': maxPoints,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'file_urls': fileUrls,
    };
  }

  factory TP.fromJson(Map<String, dynamic> json) {
    return TP(
      id: json['id'],
      moduleId: json['module_id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      maxPoints: json['max_points'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      fileUrls: List<String>.from(json['file_urls'] ?? []),
    );
  }
}