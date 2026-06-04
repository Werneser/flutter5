import 'package:flutter/material.dart';
import 'package:flutter5/app.dart';
import 'package:flutter5/data/datasources/Local/link_gosuslugi_local_datasource.dart';
import 'package:flutter5/main.dart';
import 'package:flutter5/ui/features/authentication/screens/login_screen.dart';
import 'package:flutter5/ui/features/authentication/screens/register_screen.dart';
import 'package:flutter5/ui/features/gosuslugi/screens/link_gosuslugi_screen.dart';
import 'package:flutter5/ui/features/service/screens/service_list_screen.dart';
import 'package:flutter5/ui/features/service/screens/search_service_screen.dart';
import 'package:flutter5/ui/features/invoice/screens/invoice_list_screen.dart';
import 'package:flutter5/ui/features/invoice/screens/invoice_add_screen.dart';
import 'package:flutter5/ui/features/profile/screens/profile_screen.dart';
import 'package:flutter5/ui/features/profile/screens/profile_screen_change.dart';
import 'package:flutter5/ui/features/support/screens/support_screen.dart';
import 'package:flutter5/ui/features/application/screens/appointment_list_screen.dart';
import 'package:flutter5/data/datasources/Remote/service_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/invoice_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/appointment_remote_datasource.dart';
import 'package:flutter5/data/datasources/Local/profile_local_datasource.dart';
import 'package:flutter5/data/datasources/Local/support_local_datasource.dart';
import 'package:flutter5/domain/usecases/login_usecase.dart';
import 'package:flutter5/domain/usecases/register_usecase.dart';
import 'package:flutter5/domain/usecases/get_invoices_usecase.dart';
import 'package:flutter5/domain/usecases/delete_invoices_usecase.dart';
import 'package:flutter5/domain/usecases/add_invoices_usecase.dart';
import 'package:flutter5/domain/usecases/update_invoices_usecase.dart';
import 'package:flutter5/domain/models/invoice.dart';
import 'package:flutter5/domain/models/appointment.dart';
import 'package:flutter5/domain/models/userProfile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLoginUseCase implements LoginUseCase {
  bool shouldSucceed = true;
  int callCount = 0;
  String? lastLogin;
  String? lastPassword;

  @override
  Future<String?> execute(String login, String password) async {
    callCount++;
    lastLogin = login;
    lastPassword = password;
    return shouldSucceed ? 'fake-token' : null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRegisterUseCase implements RegisterUseCase {
  bool shouldSucceed = true;

  @override
  Future<void> execute(String name, String login, String password, String phoneNumber) async {
    if (!shouldSucceed) {
      throw Exception('Registration failed');
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGetInvoicesUseCase implements GetInvoicesUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource = MockInvoiceRemoteDataSource();

  @override
  Future<List<Invoice>> execute() async => [];
}

class MockDeleteInvoiceUseCase implements DeleteInvoiceUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource = MockInvoiceRemoteDataSource();

  @override
  Future<void> execute(String invoiceId) async {}
}

class MockAddInvoiceUseCase implements AddInvoiceUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource = MockInvoiceRemoteDataSource();

  @override
  Future<void> execute(Invoice invoice) async {}
}

class MockUpdateInvoiceUseCase implements UpdateInvoiceUseCase {
  final InvoiceRemoteDataSource invoiceRemoteDataSource = MockInvoiceRemoteDataSource();

  @override
  Future<void> execute(Invoice invoice) async {}
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  bool logoutCalled = false;
  final FlutterSecureStorage _storage;
  final Dio _dio = MockDio();

  MockAuthRemoteDataSource(this._storage);

  @override
  Future<String?> getCurrentUserLogin() async {
    return await _storage.read(key: 'current_user_login');
  }

  @override
  Future<String?> loginUser(String login, String password) async {
    await _storage.write(key: 'current_user_login', value: login);
    return 'fake-token';
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
    await _storage.delete(key: 'current_user_login');
  }

  @override
  Future<void> registerUser(String name, String login, String password, String phoneNumber) async {}

  @override
  Future<void> deleteUser(String login) async {}
}

class MockInvoiceRemoteDataSource implements InvoiceRemoteDataSource {
  @override
  Dio get dio => MockDio();

  @override
  AuthRemoteDataSource get authRemoteDataSource => MockAuthRemoteDataSource(MockFlutterSecureStorage());

  @override
  Future<List<Invoice>> getInvoices() async => [];

  @override
  Future<void> updateInvoiceStatus({required String invoiceId, required InvoiceStatus status}) async {}

  @override
  Future<void> addInvoice(Invoice invoice) async {}
}

class MockAppointmentRemoteDataSource implements AppointmentRemoteDataSource {
  @override
  Dio get dio => MockDio();

  @override
  AuthRemoteDataSource get authRemoteDataSource => MockAuthRemoteDataSource(MockFlutterSecureStorage());

  @override
  Future<List<Appointment>> getAppointmentsByStatus(AppointmentStatus? status) async => [];

  @override
  Future<void> updateAppointmentStatus({required String appointmentId, required AppointmentStatus status}) async {}

  @override
  Future<void> addAppointment(Appointment appointment) async {}
}

class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  @override
  UserProfile getProfile() => const UserProfile();

  @override
  void updateProfile(UserProfile profile) {}
}

class MockSupportRemoteDataSource implements SupportRemoteDataSource {
  @override
  List<Map<String, String>> getFAQ() => [
    {'question': 'Как войти?', 'answer': 'Используйте логин и пароль'},
  ];

  @override
  List<Map<String, String>> getMessages() => [];

  @override
  void sendMessage(String message) {}
}

class MockFlutterSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    } else {
      _storage.remove(key);
    }
  }

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll({
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _storage.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return Map.from(_storage);
  }

  @override
  Future<bool> containsKey({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage.containsKey(key);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDio implements Dio {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}



class MockLinkGosuslugiRemoteDataSource implements LinkGosuslugiRemoteDataSource {  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockFlutterSecureStorage mockSecureStorage;
  late GoRouter testRouter;

  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScaffold(),
        ),
        GoRoute(
          path: '/ServiceList',
          builder: (context, state) => const ServiceListScreen(),
        ),
        GoRoute(
          path: '/userServiceList',
          builder: (context, state) => const UserServiceListScreen(),
        ),
        GoRoute(
          path: '/searchService',
          builder: (context, state) => SearchServiceScreen(
            initialQuery: state.extra as String? ?? '',
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/profile/edit',
          builder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            return ProfileScreenChange(
              initialFullName: extra?['fullName'] ?? '',
              initialPassport: extra?['passport'] ?? '',
              initialSnils: extra?['snils'] ?? '',
              initialPhone: extra?['phone'] ?? '',
              initialEmail: extra?['email'] ?? '',
            );
          },
        ),
        GoRoute(
          path: '/support',
          builder: (context, state) => const SupportScreen(),
        ),
        GoRoute(
          path: '/invoices',
          builder: (context, state) => const InvoiceListScreen(),
        ),
        GoRoute(
          path: '/invoiceAdd',
          builder: (context, state) => const InvoiceAddScreen(),
        ),
        GoRoute(
          path: '/linkGosuslugi',
          builder: (context, state) => const LinkGosuslugiScreen(),
        ),
      ],
    );
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() async {
    mockSecureStorage = MockFlutterSecureStorage();
    mockLoginUseCase = MockLoginUseCase();
    mockAuthRemoteDataSource = MockAuthRemoteDataSource(mockSecureStorage);
    testRouter = createTestRouter();

    final getIt = GetIt.instance;
    await getIt.reset();

    final sharedPreferences = await SharedPreferences.getInstance();

    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerSingleton<Dio>(MockDio());
    getIt.registerSingleton<FlutterSecureStorage>(mockSecureStorage);

    getIt.registerSingleton<LoginUseCase>(mockLoginUseCase);
    getIt.registerSingleton<RegisterUseCase>(MockRegisterUseCase());
    getIt.registerSingleton<GetInvoicesUseCase>(MockGetInvoicesUseCase());
    getIt.registerSingleton<DeleteInvoiceUseCase>(MockDeleteInvoiceUseCase());
    getIt.registerSingleton<AddInvoiceUseCase>(MockAddInvoiceUseCase());
    getIt.registerSingleton<UpdateInvoiceUseCase>(MockUpdateInvoiceUseCase());

    getIt.registerSingleton<AuthRemoteDataSource>(mockAuthRemoteDataSource);
    getIt.registerSingleton<InvoiceRemoteDataSource>(MockInvoiceRemoteDataSource());
    getIt.registerSingleton<AppointmentRemoteDataSource>(MockAppointmentRemoteDataSource());
    getIt.registerSingleton<ServiceRemoteDataSource>(ServiceRemoteDataSource());
    getIt.registerSingleton<ProfileRemoteDataSource>(MockProfileRemoteDataSource());
    getIt.registerSingleton<SupportRemoteDataSource>(MockSupportRemoteDataSource());
    getIt.registerSingleton<LinkGosuslugiRemoteDataSource>(MockLinkGosuslugiRemoteDataSource());

  });

  Future<void> pumpTestApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: testRouter,
        theme: ThemeData.light(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('1. Успешный вход в систему перенаправляет на главный экран',
          (WidgetTester tester) async {
        mockLoginUseCase.shouldSucceed = true;
        await pumpTestApp(tester);

        await tester.enterText(find.byType(TextField).first, 'testuser');
        await tester.enterText(find.byType(TextField).last, 'password');
        await tester.tap(find.text('Войти'));
        await tester.pumpAndSettle();

        expect(find.text('Госуслуги'), findsOneWidget);
        expect(mockLoginUseCase.callCount, equals(1));
        expect(mockLoginUseCase.lastLogin, equals('testuser'));
        expect(mockLoginUseCase.lastPassword, equals('password'));
      });

  testWidgets('2. Неудачный вход показывает сообщение об ошибке',
          (WidgetTester tester) async {
        mockLoginUseCase.shouldSucceed = false;
        await pumpTestApp(tester);

        await tester.enterText(find.byType(TextField).first, 'wrong');
        await tester.enterText(find.byType(TextField).last, 'credentials');
        await tester.tap(find.text('Войти'));
        await tester.pump();

        expect(find.text('Неверный логин или пароль'), findsOneWidget);
        expect(find.text('Госуслуги'), findsNothing);
      });

  testWidgets('3. Валидация пустых полей на экране входа',
          (WidgetTester tester) async {
        await pumpTestApp(tester);

        await tester.tap(find.text('Войти'));
        await tester.pump();

        expect(find.text('Пожалуйста, введите логин'), findsOneWidget);
        expect(find.text('Пожалуйста, введите пароль'), findsOneWidget);
      });

  testWidgets('4. Навигация с экрана входа на экран регистрации',
          (WidgetTester tester) async {
        await pumpTestApp(tester);

        await tester.tap(find.text('Зарегистрироваться'));
        await tester.pumpAndSettle();

        expect(find.text('Регистрация'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Имя'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Логин'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Номер телефона'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Пароль'), findsOneWidget);
      });

  testWidgets('5. Переход на экран редактирования профиля',
          (WidgetTester tester) async {
        testRouter.go('/');
        await pumpTestApp(tester);

        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.text('Изменить профиль'), findsOneWidget);
        expect(find.byType(TextFormField), findsAtLeast(5));
      });

  testWidgets('6. Навигация на экран поиска услуг',
          (WidgetTester tester) async {
        testRouter.go('/ServiceList');
        await pumpTestApp(tester);

        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        expect(find.text('Поиск услуг'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

  testWidgets('7. Отображение списка квитанций',
          (WidgetTester tester) async {
        testRouter.go('/invoices');
        await pumpTestApp(tester);

        expect(find.text('Квитанции к оплате'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

  testWidgets('8. Переход на экран добавления квитанции',
          (WidgetTester tester) async {
        testRouter.go('/invoices');
        await pumpTestApp(tester);

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(InvoiceAddScreen), findsOneWidget);
      });

  testWidgets('9. Навигация между вкладками нижнего меню',
          (WidgetTester tester) async {
        await mockSecureStorage.write(key: 'current_user_login', value: 'testuser');
        testRouter.go('/');
        await pumpTestApp(tester);

        expect(find.byType(ServiceListScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Услуги'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.assignment));
        await tester.pumpAndSettle();
        expect(find.byType(UserServiceListScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Мои заявки'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.receipt));
        await tester.pumpAndSettle();
        expect(find.byType(InvoiceListScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Квитанции к оплате'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.support_agent));
        await tester.pumpAndSettle();
        expect(find.byType(SupportScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Техническая поддержка'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();
        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Профиль'), findsOneWidget);
      });

  testWidgets('10. Отображение экрана поддержки с вкладками',
          (WidgetTester tester) async {
        testRouter.go('/support');
        await pumpTestApp(tester);

        expect(find.text('Техническая поддержка'), findsOneWidget);
        expect(find.text('Чат'), findsOneWidget);
        expect(find.text('FAQ'), findsOneWidget);

        await tester.tap(find.text('FAQ'));
        await tester.pumpAndSettle();

        expect(find.byType(ExpansionTile), findsWidgets);
      });
}