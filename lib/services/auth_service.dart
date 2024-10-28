// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String email;
  final String userType;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.userType,
    required this.name,
  });
}

class AuthService {
  // Données de test pour les utilisateurs
  static final Map<String, User> _users = {
    'admin@tpsc.com': User(
      id: '1',
      email: 'admin@tpsc.com',
      userType: 'admin',
      name: 'Admin Principal',
    ),
    'student@tpsc.com': User(
      id: '2',
      email: 'student@tpsc.com',
      userType: 'student',
      name: 'Étudiant Test',
    ),
    'teacher@tpsc.com': User(
      id: '3',
      email: 'teacher@tpsc.com',
      userType: 'teacher',
      name: 'Mr Ouédraogo',
    ),
    'parent@tpsc.com': User(
      id: '4',
      email: 'parent@tpsc.com',
      userType: 'parent',
      name: 'Parent Test',
    ),
  };

  // Mots de passe de test
  static final Map<String, String> _passwords = {
    'admin@tpsc.com': 'admin123',
    'student@tpsc.com': 'student123',
    'teacher@tpsc.com': 'teacher123',
    'parent@tpsc.com': 'parent123',
  };

  // Méthode de connexion
  Future<User?> login(String email, String password) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      // Vérifier si l'email existe et si le mot de passe correspond
      if (_passwords[email] == password) {
        return _users[email];
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de connexion: $e');
      }
      return null;
    }
  }

  // Obtenir la route initiale selon le type d'utilisateur
  String getInitialRoute(String userType) {
    switch (userType.toLowerCase()) {
      case 'admin':
        return '/admin-dashboard';
      case 'student':
        return '/student-dashboard';
      case 'teacher':
        return '/teacher-dashboard';
      case 'parent':
        return '/parent-dashboard';
      default:
        return '/login';
    }
  }

  // Obtenir une route spécifique pour un type d'utilisateur
  String getRouteForUser(String userType, String route) {
    if (userType.isEmpty || route.isEmpty) return '/login';

    switch (userType.toLowerCase()) {
      case 'admin':
        return '/admin/$route';
      case 'student':
        return '/student/$route';
      case 'teacher':
        return '/teacher/$route';
      case 'parent':
        return '/parent/$route';
      default:
        return '/login';
    }
  }

  // Validation de l'email
  bool validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validation du mot de passe
  bool validatePassword(String password) {
    // Au moins 6 caractères
    return password.length >= 6;
  }

  // Vérifier si un utilisateur est connecté (à implémenter avec persistance)
  Future<bool> isLoggedIn() async {
    // Implémenter la vérification de session
    return false;
  }

  // Déconnexion (à implémenter avec persistance)
  Future<void> logout() async {
    // Implémenter la déconnexion
    // Effacer les données de session
  }

  // Obtenir les informations de l'utilisateur actuel (à implémenter avec persistance)
  Future<User?> getCurrentUser() async {
    // Implémenter la récupération de l'utilisateur actuel
    return null;
  }

  // Obtenir le type d'utilisateur à partir d'une route
  String getUserTypeFromRoute(String route) {
    if (route.startsWith('/admin')) return 'admin';
    if (route.startsWith('/student')) return 'student';
    if (route.startsWith('/teacher')) return 'teacher';
    if (route.startsWith('/parent')) return 'parent';
    return '';
  }
}
