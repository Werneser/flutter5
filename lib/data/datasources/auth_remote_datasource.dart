import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRemoteDataSource(this._dio, this._storage);

  Future<void> registerUser(String name, String login, String password, String phoneNumber) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'userName': name,
          'login': login,
          'password': password,
          'phoneNumber': phoneNumber,
        },
      );
      if (response.statusCode != 201) {
        throw Exception('Registration failed: ${response.data}');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  Future<String?> loginUser(String login, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'login': login,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storage.write(key: 'current_user_login', value: login);
        return token;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<String?> getCurrentUserLogin() async {
    return await _storage.read(key: 'current_user_login');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'current_user_login');
  }
}
