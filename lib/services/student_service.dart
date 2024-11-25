import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class StudentService {
  final _supabase = SupabaseConfig.client;

  Future<List<Map<String, dynamic>>> getEnrolledStudents(String courseId) async {
    final response = await _supabase
        .from('course_enrollments')
        .select('*, student:students(*, user:users(*))')
        .eq('course_id', courseId);
    return List<Map<String, dynamic>>.from(response);
  }

// obtenir les etudiants associer
  Future<List<Map<String, dynamic>>> getAvailableStudents(String courseId) async {
    final response = await _supabase
        .from('students')
        .select('*, user:users(*)')
        .not('id', 'in', (query) => query
            .from('course_enrollments')
            .select('student_id')
            .eq('course_id', courseId));
    return List<Map<String, dynamic>>.from(response);
  }

// inscrire un étudiant à un cours
  Future<void> enrollStudent(String courseId, String studentId) async {
    await _supabase.from('course_enrollments').insert({
      'course_id': courseId,
      'student_id': studentId,
    });
  }


// retirer un étudiant d'un cours
  Future<void> unenrollStudent(String courseId, String studentId) async {
    await _supabase
        .from('course_enrollments')
        .delete()
        .match({'course_id': courseId, 'student_id': studentId});
  }
}