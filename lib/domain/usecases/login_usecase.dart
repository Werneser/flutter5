import 'package:flutter5/data/datasources/auth_remote_datasource.dart';


class LoginUseCase {
  final AuthRemoteDataSource authRemoteDataSource;

  LoginUseCase(this.authRemoteDataSource);

  Future<bool> execute(String login, String password) async {
    return await authRemoteDataSource.loginUser(login, password);
  }
}