import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';

class RegisterUseCase {
  final AuthRemoteDataSource authRemoteDataSource;

  RegisterUseCase(this.authRemoteDataSource);

  Future<void> execute(String name, String login, String password, String phoneNumber) async {
    await authRemoteDataSource.registerUser(name, login, password, phoneNumber);
  }
}
