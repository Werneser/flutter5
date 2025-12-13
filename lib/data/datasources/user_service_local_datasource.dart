import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter5/domain/models/user_service.dart';

class UserServiceLocalDataSource {
  static const _keyPrefix = 'user_services_';
  final FlutterSecureStorage _storage;

  UserServiceLocalDataSource(this._storage);

  Future<List<UserService>> getUserServices(String userId) async {
    final jsonString = await _storage.read(key: '${_keyPrefix}$userId');
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => UserService.fromJson(json)).toList();
  }

  Future<void> saveUserServices(String userId, List<UserService> userServices) async {
    final jsonString = json.encode(userServices.map((e) => e.toJson()).toList());
    await _storage.write(key: '${_keyPrefix}$userId', value: jsonString);
  }

  Future<void> addUserService(String userId, UserService userService) async {
    final userServices = await getUserServices(userId);
    userServices.add(userService);
    await saveUserServices(userId, userServices);
  }

  Future<void> updateUserServiceStatus({
    required String userId,
    required String userServiceId,
    required UserServiceStatus status,
  }) async {
    final userServices = await getUserServices(userId);
    final index = userServices.indexWhere((e) => e.id == userServiceId);
    if (index != -1) {
      userServices[index] = userServices[index].copyWith(status: status);
      await saveUserServices(userId, userServices);
    }
  }

  Future<List<UserService>> getUserServicesByStatus(String userId, UserServiceStatus? status) async {
    final userServices = await getUserServices(userId);
    if (status == null) return userServices;
    return userServices.where((e) => e.status == status).toList();
  }
}
