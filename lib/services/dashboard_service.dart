import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, int>> getDashboardStats() async {
    try {
      // obtenir les compteurs pour chaque table
      final Map<String, dynamic> counts = {};

      // Compteur d'utilisateurs
      final usersData = await _supabase.from('users').select('id, user_type');
      counts['users'] = usersData.length;

      // Compteur de cours
      final coursesData =
          await _supabase.from('courses').select('id').eq('is_active', true);
      counts['courses'] = coursesData.length;

      // Compteur de TPs
      final tpsData =
          await _supabase.from('tps').select('id').eq('is_active', true);
      counts['tps'] = tpsData.length;

      // Compteur de Quiz
      final quizzesData =
          await _supabase.from('quizzes').select('id').eq('is_active', true);
      counts['quizzes'] = quizzesData.length;

      print('Statistiques obtenues: $counts');

      return {
        'users': counts['users'] ?? 0,
        'courses': counts['courses'] ?? 0,
        'tps': counts['tps'] ?? 0,
        'quizzes': counts['quizzes'] ?? 0,
      };
    } catch (e) {
      print('Erreur statistiques: $e');
      throw Exception('Erreur lors de la récupération des statistiques: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRecentCourses() async {
    try {
      final courses = await _supabase
          .from('courses')
          .select('''
            id,
            name,
            description,
            created_by,
            created_at,
            is_active,
            teacher_courses (
              teacher:teachers (
                id,
                user:users (
                  name
                )
              )
            ),
            enrollments:course_enrollments(count)
          ''')
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(5);

      print('Cours récents obtenus: $courses'); // Pour débogage
      return List<Map<String, dynamic>>.from(courses);
    } catch (e) {
      print('Erreur lors de la récupération des cours: $e');
      throw Exception('Erreur lors de la récupération des cours: $e');
    }
  }
}
