import 'package:flutter5/domain/models/user.dart';


class AuthRemoteDataSource {
  final List<User> _users = [];
  User? _currentUser;

  Future<void> registerUser(String name, String login, String password) async {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      login: login,
      password: password,
    );
    _users.add(user);
  }

  bool loginUser(String login, String password) {
    final user = _users.firstWhere(
          (user) => user.login == login && user.password == password,
      orElse: () => User(id: '', name: '', login: '', password: ''),
    );
    if (user.id.isNotEmpty) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
  }
}

