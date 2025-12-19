import 'package:dio/dio.dart';
import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/Local/invoice_local_datasource.dart';
import 'package:flutter5/data/datasources/Local/link_gosuslugi_local_datasource.dart';
import 'package:flutter5/data/datasources/Local/profile_local_datasource.dart';
import 'package:flutter5/data/datasources/Remote/invoice_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/service_remote_datasource.dart';
import 'package:flutter5/data/datasources/Local/support_local_datasource.dart';
import 'package:flutter5/data/datasources/Remote/appointment_remote_datasource.dart';
import 'package:flutter5/data/datasources/Local/appointment_local_datasource.dart';
import 'package:flutter5/domain/usecases/add_invoices_usecase.dart';
import 'package:flutter5/domain/usecases/delete_invoices_usecase.dart';
import 'package:flutter5/domain/usecases/update_invoices_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/usecases/get_invoices_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8080'));
  final storage = const FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<InvoiceLocalDataSource>(InvoiceLocalDataSource());
  getIt.registerLazySingleton<FlutterSecureStorage>(() => storage);
  getIt.registerLazySingleton<AppointmentLocalDataSource>(() => AppointmentLocalDataSource(getIt<FlutterSecureStorage>()),);
  getIt.registerLazySingleton<AppointmentRemoteDataSource>(() => AppointmentRemoteDataSource(dio, getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(dio, storage));
  getIt.registerLazySingleton<InvoiceRemoteDataSource>(() => InvoiceRemoteDataSource(dio, getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<LinkGosuslugiRemoteDataSource>(() => LinkGosuslugiRemoteDataSource());
  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSource());
  getIt.registerLazySingleton<ServiceRemoteDataSource>(() => ServiceRemoteDataSource());
  getIt.registerLazySingleton<SupportRemoteDataSource>(() => SupportRemoteDataSource());

  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<GetInvoicesUseCase>(() => GetInvoicesUseCase(getIt<InvoiceRemoteDataSource>()));
  getIt.registerLazySingleton<AddInvoiceUseCase>(() => AddInvoiceUseCase(getIt<InvoiceRemoteDataSource>()));
  getIt.registerLazySingleton<UpdateInvoiceUseCase>(() => UpdateInvoiceUseCase(getIt<InvoiceRemoteDataSource>()));
  getIt.registerLazySingleton<DeleteInvoiceUseCase>(() => DeleteInvoiceUseCase(getIt<InvoiceRemoteDataSource>()));
}
