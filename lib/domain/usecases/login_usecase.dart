import 'package:flutter5/data/datasources/auth_remote_datasource.dart';


class LoginUseCase {
  final AuthRemoteDataSource authRemoteDataSource;

  LoginUseCase(this.authRemoteDataSource);

  bool execute(String login, String password) {
    return authRemoteDataSource.loginUser(login, password);
  }
}