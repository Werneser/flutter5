import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';

class RegisterUseCase {
  final AuthRemoteDataSource authRemoteDataSource;

  RegisterUseCase(this.authRemoteDataSource);

  Future<void> execute(
      String name,
      String login,
      String password,
      String phoneNumber, {
        int role = 0,
      }) async {
    await authRemoteDataSource.registerUser(
      name,
      login,
      password,
      phoneNumber,
      role: role,
    );
  }
}