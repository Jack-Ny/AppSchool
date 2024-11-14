import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _supabase
        .from('users')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<AppUser> createUser({
    required String email,
    required String name,
    required String userType,
    String? studentId,
  }) async {
    try {
      // creer un utilisateur dans auth.users
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: 'Password123!', // Mot de passe temporaire
      );

      if (authResponse.user == null) {
        throw Exception('Échec de création de l\'utilisateur dans auth');
      }

      // Créer l'entrée dans la table users
      final userData = {
        'id': authResponse.user!.id,
        'email': email,
        'name': name,
        'user_type': userType.toLowerCase(),
        'created_at': DateTime.now().toIso8601String(),
      };

      final result =
          await _supabase.from('users').insert(userData).select().single();

      // Créer l'entrée spécifique selon le type
      switch (userType.toLowerCase()) {
        case 'student':
          await _supabase.from('students').insert({
            'user_id': authResponse.user!.id,
            'registration_number':
                'STD${DateTime.now().millisecondsSinceEpoch}',
            'class_level': 'Nouveau',
          });
          break;
        case 'teacher':
          await _supabase.from('teachers').insert({
            'user_id': authResponse.user!.id,
            'specialization': 'À définir',
          });
          break;
        case 'parent':
          if (studentId == null) {
            throw Exception('ID étudiant requis pour créer un parent');
          }
          await _supabase.from('parents').insert({
            'user_id': authResponse.user!.id,
            'student_id': studentId,
          });
          break;
      }

      return AppUser.fromJson(result);
    } catch (e) {
      throw Exception('Erreur création utilisateur: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    return await _supabase
        .from('students')
        .select('id, user_id, users!inner(name, email)');
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _supabase.from('users').delete().eq('id', userId);
    } catch (e) {
      throw Exception('Erreur suppression utilisateur: $e');
    }
  }

  Future<AppUser> updateUser({
    required String userId,
    String? name,
    String? email,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;

      final result = await _supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return AppUser.fromJson(result);
    } catch (e) {
      throw Exception('Erreur mise à jour utilisateur: $e');
    }
  }

  // Fonction utilitaire pour envoyer un email de bienvenue
  Future<void> sendWelcomeEmail(String email, String password) async {
    // TODO: Implémenter l'envoi d'email avec un service tiers
  }
}
