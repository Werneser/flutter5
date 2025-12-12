class User {
  final String id;
  final String name;
  final String login;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.login,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      login: json['login'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'password': password,
    };
  }
}
