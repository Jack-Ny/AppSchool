import 'package:app_school/models/module.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseService {
  final _supabase = Supabase.instance.client;

  // Récupérer tous les cours
  Future<List<Map<String, dynamic>>> getAllCourses() async {
    try {
      final response = await _supabase.from('courses').select('''
            *,
            enrollments:course_enrollments(count),
            teacher:teacher_courses(
              teacher:teachers(
                user:users(
                  name
                )
              )
            )
          ''').order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des cours: $e');
    }
  }

  // Récupérer tous les formateurs
  Future<List<Map<String, dynamic>>> getAllTeachers() async {
    try {
      final response = await _supabase.from('users').select('''
            id,
            name,
            teachers!inner (
              id,
              specialization
            )
          ''').eq('user_type', 'teacher');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des formateurs: $e');
    }
  }

  // Créer un nouveau cours
  Future<Map<String, dynamic>> createCourseWithModules({
    required String name,
    required String category,
    required List<Module> modules,
    required String userId,
  }) async {
    try {
      final courseResponse = await _supabase
          .from('courses')
          .insert({
            'name': name,
            'category': category,
            'created_by': userId,
            'is_active': true,
          })
          .select()
          .single();

      final courseId = courseResponse['id'];

      for (var module in modules) {
        final moduleResponse = await _supabase
            .from('modules')
            .insert({
              'name': module.name,
              'course_id': courseId,
            })
            .select()
            .single();

        final moduleId = moduleResponse['id'];

        for (var quiz in module.quizzes) {
          final quizResponse = await _supabase
              .from('quizzes')
              .insert({
                'title': quiz.title,
                'description': quiz.description,
                'module_id': moduleId,
              })
              .select()
              .single();

          final quizId = quizResponse['id'];

          for (var question in quiz.questions) {
            final questionResponse = await _supabase
                .from('questions')
                .insert({
                  'text': question.text,
                  'quiz_id': quizId,
                })
                .select()
                .single();

            final questionId = questionResponse['id'];

            for (var answer in question.answers) {
              await _supabase.from('answers').insert({
                'text': answer.text,
                'is_correct': answer.isCorrect,
                'question_id': questionId,
              });
            }
          }
        }

        for (var tp in module.tps) {
          await _supabase.from('tps').insert({
            'title': tp.title,
            'description': tp.description,
            'deadline': tp.deadline.toIso8601String(),
            'module_id': moduleId,
          });
        }
      }

      return courseResponse;
    } catch (e) {
      throw Exception('Erreur lors de la création du cours: $e');
    }
  }

  // Supprimer un cours
  Future<void> deleteCourse(String courseId) async {
    try {
      await _supabase.from('courses').delete().eq('id', courseId);
    } catch (e) {
      throw Exception('Erreur lors de la suppression du cours: $e');
    }
  }

  // Mettre à jour un cours
  Future<Map<String, dynamic>> updateCourse({
    required String courseId,
    String? title,
    String? category,
    String? description,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['name'] = title;
      if (category != null) updates['category'] = category;
      if (description != null) updates['description'] = description;

      final response = await _supabase
          .from('courses')
          .update(updates)
          .eq('id', courseId)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du cours: $e');
    }
  }

  // Assigner un formateur à un cours
  Future<void> assignTeacherToCourse(String courseId, String teacherId) async {
    try {
      await _supabase.from('teacher_courses').insert({
        'course_id': courseId,
        'teacher_id': teacherId,
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'assignation du formateur: $e');
    }
  }
}
