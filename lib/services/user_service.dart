import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getStudents() async {
    final students = await _supabase.from('users').select('''
        id,
        name,
        email
      ''').eq('user_type', 'student').order('created_at');

    return List<Map<String, dynamic>>.from(students);
  }

  Future<AppUser> createUser({
    required String email,
    required String name,
    required String userType,
    List<String>? studentIds, // Changé pour gérer plusieurs étudiants
  }) async {
    AuthResponse? authResponse;
    try {
      // Créer un utilisateur dans auth.users
      authResponse = await _supabase.auth.signUp(
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
          if (studentIds == null || studentIds.isEmpty) {
            throw Exception(
                'Au moins un étudiant doit être sélectionné pour créer un parent');
          }

          // Créer le parent
          final parentInsert = await _supabase
              .from('parents')
              .insert({
                'user_id': authResponse.user!.id,
              })
              .select()
              .single();

          // recuperer les IDs des etudiants depuis la table students
          final studentsData = await _supabase
              .from('students')
              .select('id, user_id')
              .in_('user_id', studentIds);

          // Créer les associations parent-étudiants
          for (var student in studentsData) {
            await _supabase.from('student_parents').insert({
              'parent_id': parentInsert['id'],
              'student_id': student['id'],
            });
          }
          break;
      }

      return AppUser.fromJson(result);
    } catch (e) {
      // En cas d'erreur, essayer de nettoyer l'utilisateur créé partiellement
      if (authResponse?.user != null) {
        try {
          await deleteUser(authResponse!.user!.id);
        } catch (_) {
          // Ignorer les erreurs de nettoyage
        }
      }
      throw Exception('Erreur création utilisateur: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      // 1. D'abord vérifier si l'utilisateur existe
      final userExists = await _supabase
          .from('users')
          .select('user_type')
          .eq('id', userId)
          .maybeSingle();

      if (userExists == null) {
        throw Exception('Utilisateur non trouvé');
      }

      // 2. Supprimer de auth.users en premier
      try {
        // Utiliser la fonction rpc personnalisée pour supprimer l'utilisateur auth
        await _supabase.rpc('delete_user_auth', params: {'userid': userId});
      } catch (e) {
        print('Erreur suppression auth user: $e');
        // Continuer même si la suppression auth échoue
      }

      // 3. Supprimer les entrées spécifiques selon le type
      switch (userExists['user_type'].toString().toLowerCase()) {
        case 'student':
          await _supabase.from('students').delete().eq('user_id', userId);
          break;
        case 'teacher':
          await _supabase.from('teachers').delete().eq('user_id', userId);
          break;
        case 'parent':
          await _supabase.from('parents').delete().eq('user_id', userId);
          break;
      }

      // 4. Supprimer de la table users
      await _supabase.from('users').delete().eq('id', userId);
    } catch (e) {
      throw Exception('Erreur suppression utilisateur : $e');
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
