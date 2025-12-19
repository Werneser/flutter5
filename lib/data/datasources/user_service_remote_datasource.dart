import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/user_service_local_datasource.dart';
import 'package:flutter5/domain/models/user_service.dart';

class UserServiceRemoteDataSource {
  final UserServiceLocalDataSource localDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  UserServiceRemoteDataSource(this.localDataSource, this.authRemoteDataSource);

  Future<String?> _getCurrentUserLogin() async {
    return await authRemoteDataSource.getCurrentUserLogin();
  }

  Future<List<UserService>> getUserServicesByStatus(UserServiceStatus? status) async {
    final login = await _getCurrentUserLogin();
    if (login == null) {
      return [];
    }
    return localDataSource.getUserServicesByStatus(login, status);
  }

  Future<void> updateUserServiceStatus({
    required String userServiceId,
    required UserServiceStatus status,
  }) async {
    final login = await _getCurrentUserLogin();
    if (login == null) {
      throw Exception('User not logged in');
    }
    return localDataSource.updateUserServiceStatus(
      userId: login,
      userServiceId: userServiceId,
      status: status,
    );
  }

  Future<void> addUserService(UserService userService) async {
    final login = await _getCurrentUserLogin();
    if (login == null) {
      throw Exception('User not logged in');
    }
    return localDataSource.addUserService(login, userService);
  }
}
