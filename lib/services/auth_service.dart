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
  // Données de test pour la connexion
  static final Map<String, User> _testUsers = {
    'admin@tpsc.com': User(
      id: '1',
      email: 'admin@tpsc.com',
      userType: 'admin',
      name: 'Admin Principal',
    ),
    'teacher@tpsc.com': User(
      id: '2',
      email: 'teacher@tpsc.com',
      userType: 'teacher',
      name: 'Mr Ouédraogo',
    ),
    'student@tpsc.com': User(
      id: '3',
      email: 'student@tpsc.com',
      userType: 'student',
      name: 'John Doe',
    ),
    'parent@tpsc.com': User(
      id: '4',
      email: 'parent@tpsc.com',
      userType: 'parent',
      name: 'Parent Test',
    ),
  };

  static final Map<String, String> _passwords = {
    'admin@tpsc.com': 'admin123',
    'teacher@tpsc.com': 'teacher123',
    'student@tpsc.com': 'student123',
    'parent@tpsc.com': 'parent123',
  };

  Future<User?> login(String email, String password) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(seconds: 1));

    if (_passwords[email] == password) {
      return _testUsers[email];
    }
    return null;
  }

  String getInitialRoute(String userType) {
    switch (userType) {
      case 'admin':
        return '/admin-dashboard';
      case 'teacher':
        return '/teacher-dashboard';
      case 'student':
        return '/student-dashboard';
      case 'parent':
        return '/parent-dashboard';
      default:
        return '/login';
    }
  }
}
