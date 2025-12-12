import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final List<User> _users = [];
  User? _currentUser;

  User? get currentUser => _currentUser;

  void registerUser(String name, String login, String password) {
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
