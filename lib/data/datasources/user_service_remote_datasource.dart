import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/user_service_local_datasource.dart';
import 'package:flutter5/domain/models/user_service.dart';

class UserServiceRemoteDataSource {
  final UserServiceLocalDataSource localDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  UserServiceRemoteDataSource(this.localDataSource, this.authRemoteDataSource);

  Future<String> _getCurrentUserId() async {
    final user = await authRemoteDataSource.getCurrentUser();
    return user?.id ?? '';
  }

  Future<List<UserService>> getUserServicesByStatus(UserServiceStatus? status) async {
    final userId = await _getCurrentUserId();
    return localDataSource.getUserServicesByStatus(userId, status);
  }

  Future<void> updateUserServiceStatus({
    required String userServiceId,
    required UserServiceStatus status,
  }) async {
    final userId = await _getCurrentUserId();
    return localDataSource.updateUserServiceStatus(
      userId: userId,
      userServiceId: userServiceId,
      status: status,
    );
  }

  Future<void> addUserService(UserService userService) async {
    final userId = await _getCurrentUserId();
    return localDataSource.addUserService(userId, userService);
  }
}

