import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/user.dart';

class AuthRemoteDataSource {
  final FlutterSecureStorage _storage;
  static const _keyPrefix = 'user_';

  AuthRemoteDataSource(this._storage);

  Future<void> registerUser(String name, String login, String password) async {
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final user = User(
      id: userId,
      name: name,
      login: login,
      password: password,
    );

    await _storage.write(key: '${_keyPrefix}${user.id}_id', value: user.id);
    await _storage.write(key: '${_keyPrefix}${user.id}_name', value: user.name);
    await _storage.write(key: '${_keyPrefix}${user.id}_login', value: user.login);
    await _storage.write(key: '${_keyPrefix}${user.id}_password', value: user.password);
  }

  Future<bool> loginUser(String login, String password) async {
    final allUsers = await _getAllUsers();
    for (var user in allUsers) {
      if (user.login == login && user.password == password) {
        await _storage.write(key: 'current_user_id', value: user.id);
        return true;
      }
    }
    return false;
  }

  Future<List<User>> _getAllUsers() async {
    final allKeys = await _storage.readAll();
    final users = <User>[];
    final userIds = <String>{};

    for (var key in allKeys.keys) {
      if (key.startsWith(_keyPrefix) && key.endsWith('_id')) {
        final userId = allKeys[key];
        userIds.add(userId!);
      }
    }

    for (var userId in userIds) {
      final user = await getUserById(userId);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  Future<User?> getUserById(String userId) async {
    final id = await _storage.read(key: '${_keyPrefix}${userId}_id');
    final name = await _storage.read(key: '${_keyPrefix}${userId}_name');
    final login = await _storage.read(key: '${_keyPrefix}${userId}_login');
    final password = await _storage.read(key: '${_keyPrefix}${userId}_password');

    if (id != null && name != null && login != null && password != null) {
      return User(
        id: id,
        name: name,
        login: login,
        password: password,
      );
    }
    return null;
  }

  Future<User?> getCurrentUser() async {
    final currentUserId = await _storage.read(key: 'current_user_id');
    if (currentUserId == null) return null;
    return await getUserById(currentUserId);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'current_user_id');
  }
}

