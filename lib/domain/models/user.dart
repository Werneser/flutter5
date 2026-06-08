// flutter5/domain/models/user.dart

enum UserRole {
  user,    // Обычный пользователь
  employee // Сотрудник
}

class User {
  final String id;
  final String name;
  final String login;
  final String password;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.login,
    required this.password,
    this.role = UserRole.user,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      login: json['login'],
      password: json['password'],
      role: UserRole.values[json['role'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'password': password,
      'role': role.index,
    };
  }
}