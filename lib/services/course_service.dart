import 'package:app_school/models/module.dart';
import 'package:app_school/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'module_service.dart';
import '../config/supabase_config.dart';

class CourseService {
  final _supabase = SupabaseConfig.client;
  final AuthService _authService = AuthService();
  late final ModuleService _moduleService;

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

  Future<Map<String, dynamic>> createCourseWithModules({
  required String name,
  required String description,
  required String createdBy,
  required List<Map<String, dynamic>> modules,
}) async {
  try {
    // Créer le cours
    final courseData = {
      'name': name,
      'description': description,
      'created_by': createdBy,
    };

    // Insérer le cours dans la BD
    final courseResponse = await _supabase
        .from('courses')
        .insert(courseData)
        .select()
        .single();

    if (courseResponse == null) {
      throw Exception('Échec de la création du cours');
    }

    final courseId = courseResponse['id'];
    
    // Créer les modules associés
    for (var moduleData in modules) {
      final moduleToInsert = {
        'course_id': courseId,
        'name': moduleData['name'],
        'description': moduleData['description'],
        'order_index': moduleData['order_index'],
      };

      final moduleResponse = await _supabase
          .from('modules')
          .insert(moduleToInsert)
          .select()
          .single();

      if (moduleResponse == null) {
        throw Exception('Échec de la création du module');
      }

      final moduleId = moduleResponse['id'];

      // Créer les TPs
      if (moduleData['tps'] != null) {
        for (var tpData in moduleData['tps']) {
          final tpToInsert = {
            'module_id': moduleId,
            'title': tpData['title'],
            'description': tpData['description'],
            'due_date': tpData['due_date'],
            'max_points': tpData['max_points'],
            'file_urls': tpData['file_urls'] ?? [],
          };

          final tpResponse = await _supabase
              .from('tps')
              .insert(tpToInsert)
              .select()
              .single();

          if (tpResponse == null) {
            throw Exception('Échec de la création du TP');
          }
        }
      }

      // Créer les quizz
      if (moduleData['quizzes'] != null) {
        for (var quizData in moduleData['quizzes']) {
          final quizToInsert = {
            'module_id': moduleId,
            'title': quizData['title'],
            'time_limit': quizData['time_limit'],
            'time_unit': quizData['time_unit'],
            'passing_score': quizData['passing_score'] ?? 75,
          };

          final quizResponse = await _supabase
              .from('quizzes')
              .insert(quizToInsert)
              .select()
              .single();

          if (quizResponse == null) {
            throw Exception('Échec de la création du quiz');
          }

          final quizId = quizResponse['id'];

          // Créer les questions associées
          if (quizData['questions'] != null) {
            for (var questionData in quizData['questions']) {
              final questionToInsert = {
                'quiz_id': quizId,
                'question_text': questionData['question_text'],
                'question_type': questionData['question_type'],
                'answer': questionData['answer'],
                'points': questionData['points'],
                'choices': questionData['choices'] ?? [],
              };

              final questionResponse = await _supabase
                  .from('questions')
                  .insert(questionToInsert)
                  .select()
                  .single();

              if (questionResponse == null) {
                throw Exception('Échec de la création de la question');
              }
            }
          }
        }
      }
    }

    return courseResponse;
  } catch (e) {
    throw Exception('Erreur lors de la création du cours : $e');
  }
}
  /* Future<Map<String, dynamic>> createCourseWithModules({
    required String name,
    required String category,
    required List<Module> modules,
    required String userId,
    //required String userId,
  }) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) throw Exception('Utilisateur non connecté');

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

      // creer l'association
      await _supabase.from('teacher_courses').insert({
        'teacher_id': userId,
        'course_id': courseId,
      });

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
                'module_id': moduleId,
              })
              .select()
              .single();

          final quizId = quizResponse['id'];

          for (var question in quiz.description) {
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
  } */

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
