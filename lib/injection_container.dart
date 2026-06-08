import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/Local/invoice_local_datasource.dart';
import 'package:flutter5/data/datasources/Local/link_gosuslugi_local_datasource.dart';
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
import 'data/datasources/Remote/profile_remote_datasource.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  String baseUrl;
  if (kIsWeb) {
    baseUrl = 'http://127.0.0.1:8080';
  } else if (Platform.isAndroid) {
    baseUrl = 'http://10.0.2.2:8080';
  } else if (Platform.isIOS) {
    baseUrl = 'http://localhost:8080';
  } else {
    baseUrl = 'http://127.0.0.1:8080';
  }

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  final storage = const FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<Dio>(dio);
  getIt.registerLazySingleton<FlutterSecureStorage>(() => storage);
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(dio, storage));
  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSource(dio, storage));

  getIt.registerSingleton<InvoiceLocalDataSource>(InvoiceLocalDataSource());

  getIt.registerLazySingleton<AppointmentLocalDataSource>(() => AppointmentLocalDataSource(getIt<FlutterSecureStorage>()));

  getIt.registerLazySingleton<AppointmentRemoteDataSource>(() => AppointmentRemoteDataSource(dio, getIt<AuthRemoteDataSource>()));

  getIt.registerLazySingleton<InvoiceRemoteDataSource>(() => InvoiceRemoteDataSource(dio, getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<LinkGosuslugiRemoteDataSource>(() => LinkGosuslugiRemoteDataSource());
  getIt.registerLazySingleton<ServiceRemoteDataSource>(() => ServiceRemoteDataSource());
  getIt.registerLazySingleton<SupportRemoteDataSource>(() => SupportRemoteDataSource());
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<GetInvoicesUseCase>(() => GetInvoicesUseCase(getIt<InvoiceRemoteDataSource>()));
  getIt.registerLazySingleton<AddInvoiceUseCase>(() => AddInvoiceUseCase(getIt<InvoiceRemoteDataSource>()));
  getIt.registerLazySingleton<UpdateInvoiceUseCase>(() => UpdateInvoiceUseCase(getIt<InvoiceRemoteDataSource>()));
  getIt.registerLazySingleton<DeleteInvoiceUseCase>(() => DeleteInvoiceUseCase(getIt<InvoiceRemoteDataSource>()));

  print('DI container initialized successfully');
  print('AuthRemoteDataSource: ${getIt.isRegistered<AuthRemoteDataSource>()}');
  print('ProfileRemoteDataSource: ${getIt.isRegistered<ProfileRemoteDataSource>()}');
  print('FlutterSecureStorage: ${getIt.isRegistered<FlutterSecureStorage>()}');
}