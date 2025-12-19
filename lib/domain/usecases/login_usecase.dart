import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';


class LoginUseCase {
  final AuthRemoteDataSource authRemoteDataSource;

  LoginUseCase(this.authRemoteDataSource);

  Future<String?> execute(String login, String password) async {
    return await authRemoteDataSource.loginUser(login, password);
  }
}
