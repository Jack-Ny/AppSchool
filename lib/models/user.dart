class User {
  final String id;
  final String email;
  final String userType;
  final String name;
  final String? profilePicture;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.userType,
    required this.name,
    this.profilePicture,
    required this.createdAt,
  });

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      email: data['email'] ?? '',
      userType: data['userType'] ?? '',
      name: data['name'] ?? '',
      profilePicture: data['profilePicture'],
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userType': userType,
      'name': name,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? userType,
    String? name,
    String? profilePicture,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
