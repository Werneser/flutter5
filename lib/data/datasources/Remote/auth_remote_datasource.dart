// flutter5/data/datasources/Remote/auth_remote_datasource.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/models/user.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRemoteDataSource(this._dio, this._storage);

  Future<void> registerUser(
      String name,
      String login,
      String password,
      String phoneNumber, {
        int role = 0,
      }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'userName': name,
          'login': login,
          'password': password,
          'phoneNumber': phoneNumber,
          'role': role,
        },
      );
      if (response.statusCode != 201) {
        throw Exception('Registration failed: ${response.data}');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<Map<String, dynamic>?> loginUser(String login, String password) async {
    try {
      print('Attempting login for user: $login');
      final response = await _dio.post(
        '/login',
        data: {
          'login': login,
          'password': password,
        },
      );

      print('Login response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final role = response.data['role'] ?? UserRole.user.index;

        if (token != null) {
          await _storage.write(key: 'auth_token', value: token);
          await _storage.write(key: 'current_user_login', value: login);
          await _storage.write(key: 'user_role', value: role.toString());
          print('Token saved successfully: $token');
          print('Role saved: $role');

          return {
            'token': token,
            'role': role,
          };
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login error: $e');
    }
  }

  Future<String?> getCurrentUserLogin() async {
    return await _storage.read(key: 'current_user_login');
  }

  Future<UserRole> getUserRole() async {
    final roleStr = await _storage.read(key: 'user_role');
    if (roleStr != null) {
      final roleIndex = int.tryParse(roleStr) ?? 0;
      return UserRole.values[roleIndex];
    }
    return UserRole.user;
  }

  Future<bool> isEmployee() async {
    final role = await getUserRole();
    return role == UserRole.employee;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'current_user_login');
    await _storage.delete(key: 'user_role');
  }

}