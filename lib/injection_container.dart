import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/invoice_remote_datasource.dart';
import 'package:flutter5/data/datasources/link_gosuslugi_remote_datasource.dart';
import 'package:flutter5/data/datasources/profile_remote_datasource.dart';
import 'package:flutter5/data/datasources/service_remote_datasource.dart';
import 'package:flutter5/data/datasources/support_remote_datasource.dart';
import 'package:flutter5/data/datasources/user_service_remote_datasource.dart';
import 'package:get_it/get_it.dart';

import '../domain/usecases/get_invoices_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  getIt.registerLazySingleton<InvoiceRemoteDataSource>(() => InvoiceRemoteDataSource());
  getIt.registerLazySingleton<LinkGosuslugiRemoteDataSource>(() => LinkGosuslugiRemoteDataSource());
  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSource());
  getIt.registerLazySingleton<ServiceRemoteDataSource>(() => ServiceRemoteDataSource());
  getIt.registerLazySingleton<SupportRemoteDataSource>(() => SupportRemoteDataSource());
  getIt.registerLazySingleton<UserServiceRemoteDataSource>(() => UserServiceRemoteDataSource());

  // Use cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<GetInvoicesUseCase>(() => GetInvoicesUseCase(getIt<InvoiceRemoteDataSource>()));
}
