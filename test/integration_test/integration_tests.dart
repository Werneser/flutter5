import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter5/data/datasources/Remote/auth_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/invoice_remote_datasource.dart';
import 'package:flutter5/data/datasources/Remote/appointment_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';
import 'package:flutter5/domain/models/appointment.dart';
import 'package:flutter5/domain/models/service.dart';

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
  Future<bool> isCupertinoProtectedDataAvailable() async {
    return true;
  }

  @override
  void registerListener({
    required String key,
    required void Function(String? value) listener,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) {}

  @override
  void unregisterAllListeners() {}

  @override
  void unregisterAllListenersForKey({required String key}) {}

  @override
  void unregisterListenerForOptions({
    required String key,
    required void Function(String? value) listener,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) {}

  @override
  Future<String?> readCupertinoProtectedData({required String key}) async {
    return _storage[key];
  }

  @override
  Future<Map<String, String>> readAllCupertinoProtectedData() async {
    return Map.from(_storage);
  }

  @override
  Future<void> writeCupertinoProtectedData({
    required String key,
    required String? value,
  }) async {
    if (value != null) {
      _storage[key] = value;
    } else {
      _storage.remove(key);
    }
  }

  @override
  Future<void> deleteCupertinoProtectedData({required String key}) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAllCupertinoProtectedData() async {
    _storage.clear();
  }

  @override
  Future<bool> containsKeyCupertinoProtectedData({required String key}) async {
    return _storage.containsKey(key);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {

  late Dio dio;
  late MockFlutterSecureStorage mockSecureStorage;
  late AuthRemoteDataSource authRemoteDataSource;
  late InvoiceRemoteDataSource invoiceRemoteDataSource;
  late AppointmentRemoteDataSource appointmentRemoteDataSource;

  final List<String> createdUsers = [];

  setUp(() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:8080',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    mockSecureStorage = MockFlutterSecureStorage();
    authRemoteDataSource = AuthRemoteDataSource(dio, mockSecureStorage);
    invoiceRemoteDataSource = InvoiceRemoteDataSource(dio, authRemoteDataSource);
    appointmentRemoteDataSource = AppointmentRemoteDataSource(dio, authRemoteDataSource);
  });

  Future<void> registerTestUser(String login, String password, String phoneNumber, String userName) async {
    await authRemoteDataSource.registerUser(userName, login, password, phoneNumber);
    createdUsers.add(login);
  }


  testWidgets('Интеграционный тест 1: Полный цикл регистрации и авторизации',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'integration_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7900${timestamp.toString().substring(0, 7)}';
        final userName = 'Тестовый Пользователь';



        await registerTestUser(login, password, phoneNumber, userName);

        final token = await authRemoteDataSource.loginUser(login, password);

        expect(token, isNotNull);
        expect(token, isNotEmpty);

        final savedLogin = await authRemoteDataSource.getCurrentUserLogin();
        expect(savedLogin, equals(login));
      });

  testWidgets('Интеграционный тест 2: Создание и получение квитанций',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'invoice_int_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7901${timestamp.toString().substring(0, 7)}';
        final userName = 'Тестовый Пользователь Квитанций';

        await registerTestUser(login, password, phoneNumber, userName);
        await authRemoteDataSource.loginUser(login, password);

        final invoice = Invoice(
          id: 'inv_$timestamp',
          serviceName: 'Оплата налога на имущество',
          invoiceNumber: 'INV-INT-001',
          status: InvoiceStatus.unpaid,
          amount: 2500.50,
          issueAddress: 'г. Москва, ул. Тестовая, д. 1',
          destinationAddress: 'г. Москва, ул. Проверочная, д. 2, кв. 3',
        );

        await invoiceRemoteDataSource.addInvoice(invoice);

        final invoices = await invoiceRemoteDataSource.getInvoices();

        expect(invoices, isNotEmpty);
        expect(invoices.any((inv) => inv.invoiceNumber == 'INV-INT-001'), isTrue);

        final createdInvoice = invoices.firstWhere((inv) => inv.invoiceNumber == 'INV-INT-001');
        expect(createdInvoice.serviceName, equals('Оплата налога на имущество'));
        expect(createdInvoice.amount, equals(2500.50));
        expect(createdInvoice.status, equals(InvoiceStatus.unpaid));
      });

  testWidgets('Интеграционный тест 3: Обновление статуса квитанции',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'status_int_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7902${timestamp.toString().substring(0, 7)}';
        final userName = 'Тестовый Пользователь Статус';

        await registerTestUser(login, password, phoneNumber, userName);
        await authRemoteDataSource.loginUser(login, password);

        final invoice = Invoice(
          id: 'inv_status_$timestamp',
          serviceName: 'Штраф ГИБДД',
          invoiceNumber: 'INV-INT-002',
          status: InvoiceStatus.unpaid,
          amount: 500.00,
          issueAddress: 'г. Москва, ул. Штрафная, д. 5',
          destinationAddress: 'г. Москва, ул. Оплаченная, д. 6',
        );

        await invoiceRemoteDataSource.addInvoice(invoice);

        var invoices = await invoiceRemoteDataSource.getInvoices();
        var targetInvoice = invoices.firstWhere((inv) => inv.invoiceNumber == 'INV-INT-002');
        expect(targetInvoice.status, equals(InvoiceStatus.unpaid));

        await invoiceRemoteDataSource.updateInvoiceStatus(
          invoiceId: targetInvoice.id,
          status: InvoiceStatus.paid,
        );

        invoices = await invoiceRemoteDataSource.getInvoices();
        targetInvoice = invoices.firstWhere((inv) => inv.invoiceNumber == 'INV-INT-002');
        expect(targetInvoice.status, equals(InvoiceStatus.paid));
      });

  testWidgets('Интеграционный тест 4: Создание заявления и получение списка',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'appointment_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7903${timestamp.toString().substring(0, 7)}';
        final userName = 'Тестовый Пользователь Заявлений';

        await registerTestUser(login, password, phoneNumber, userName);
        await authRemoteDataSource.loginUser(login, password);

        final service = Service(
          id: 'svc_tr_1',
          title: 'Оформление водительского удостоверения',
          description: 'Подача заявления на получение или замену ВУ.',
          category: ServiceCategory.transport,
          requiredFields: ['Категория ВУ'],
        );

        final appointment = Appointment(
          id: 'temp_id',
          service: service,
          appliedAt: DateTime.now(),
          status: AppointmentStatus.submitted,
          formData: {'Категория ВУ': 'B'},
        );

        await appointmentRemoteDataSource.addAppointment(appointment);

        await Future.delayed(const Duration(milliseconds: 500));

        final appointments = await appointmentRemoteDataSource.getAppointmentsByStatus(null);

        expect(appointments, isNotEmpty);

        final createdAppointment = appointments.firstWhere(
              (app) => app.service.id == 'svc_tr_1' &&
              app.service.title == 'Оформление водительского удостоверения',
          orElse: () => throw Exception('Appointment not found'),
        );

        expect(createdAppointment.service.id, equals('svc_tr_1'));
        expect(createdAppointment.service.title, equals('Оформление водительского удостоверения'));
        expect(createdAppointment.service.category, equals(ServiceCategory.transport));
        expect(createdAppointment.status, equals(AppointmentStatus.submitted));
        expect(createdAppointment.formData['Категория ВУ'], equals('B'));

        print('Created appointment with server ID: ${createdAppointment.id}');
      });

  testWidgets('Интеграционный тест 5: Обновление статуса заявления',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'app_status_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7904${timestamp.toString().substring(0, 7)}';
        final userName = 'Тестовый Пользователь Статус Заявления';

        await registerTestUser(login, password, phoneNumber, userName);
        await authRemoteDataSource.loginUser(login, password);

        final service = Service(
          id: 'svc_hc_1',
          title: 'Запись к врачу',
          description: 'Электронная запись на прием к врачу по полису ОМС.',
          category: ServiceCategory.healthcare,
          requiredFields: ['Поликлиника', 'Специализация'],
        );

        final appointment = Appointment(
          id: 'temp_id',
          service: service,
          appliedAt: DateTime.now(),
          status: AppointmentStatus.submitted,
          formData: {
            'Поликлиника': 'Городская поликлиника №1',
            'Специализация': 'Терапевт',
          },
        );

        await appointmentRemoteDataSource.addAppointment(appointment);

        await Future.delayed(const Duration(milliseconds: 500));

        var appointments = await appointmentRemoteDataSource.getAppointmentsByStatus(null);

        expect(appointments, isNotEmpty);

        var targetAppointment = appointments.firstWhere(
              (app) => app.service.id == 'svc_hc_1' &&
              app.formData['Поликлиника'] == 'Городская поликлиника №1',
          orElse: () => throw Exception('Appointment not found in list: ${appointments.map((a) => a.service.id).toList()}'),
        );

        final serverAppointmentId = targetAppointment.id;
        print('Server generated appointment ID: $serverAppointmentId');

        expect(targetAppointment.service.id, equals('svc_hc_1'));
        expect(targetAppointment.service.title, equals('Запись к врачу'));
        expect(targetAppointment.status, equals(AppointmentStatus.submitted));

        await appointmentRemoteDataSource.updateAppointmentStatus(
          appointmentId: serverAppointmentId,
          status: AppointmentStatus.approved,
        );

        await Future.delayed(const Duration(milliseconds: 500));

        appointments = await appointmentRemoteDataSource.getAppointmentsByStatus(null);

        targetAppointment = appointments.firstWhere(
              (app) => app.id == serverAppointmentId,
          orElse: () => throw Exception('Appointment not found after status update'),
        );

        expect(targetAppointment.status, equals(AppointmentStatus.approved));
        expect(targetAppointment.formData['Поликлиника'], equals('Городская поликлиника №1'));
        expect(targetAppointment.formData['Специализация'], equals('Терапевт'));
      });

  testWidgets('Интеграционный тест 6: Изоляция данных между пользователями',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;

        final login1 = 'user1_$timestamp';
        final password1 = 'Pass1_$timestamp';
        final phone1 = '+7905${timestamp.toString().substring(0, 7)}';

        final login2 = 'user2_$timestamp';
        final password2 = 'Pass2_$timestamp';
        final phone2 = '+7906${timestamp.toString().substring(0, 7)}';

        await registerTestUser(login1, password1, phone1, 'Пользователь 1');
        await registerTestUser(login2, password2, phone2, 'Пользователь 2');

        await authRemoteDataSource.loginUser(login1, password1);

        final invoice1 = Invoice(
          id: 'inv_user1_$timestamp',
          serviceName: 'Квитанция пользователя 1',
          invoiceNumber: 'INV-USER1-001',
          status: InvoiceStatus.unpaid,
          amount: 1111.11,
          issueAddress: 'Адрес 1',
          destinationAddress: 'Адрес доставки 1',
        );
        await invoiceRemoteDataSource.addInvoice(invoice1);

        await authRemoteDataSource.logout();

        await authRemoteDataSource.loginUser(login2, password2);

        final invoice2 = Invoice(
          id: 'inv_user2_$timestamp',
          serviceName: 'Квитанция пользователя 2',
          invoiceNumber: 'INV-USER2-001',
          status: InvoiceStatus.unpaid,
          amount: 2222.22,
          issueAddress: 'Адрес 2',
          destinationAddress: 'Адрес доставки 2',
        );
        await invoiceRemoteDataSource.addInvoice(invoice2);

        final user2Invoices = await invoiceRemoteDataSource.getInvoices();
        expect(user2Invoices.any((inv) => inv.invoiceNumber == 'INV-USER2-001'), isTrue);
        expect(user2Invoices.any((inv) => inv.invoiceNumber == 'INV-USER1-001'), isFalse);

        await authRemoteDataSource.logout();

        await authRemoteDataSource.loginUser(login1, password1);

        final user1Invoices = await invoiceRemoteDataSource.getInvoices();
        expect(user1Invoices.any((inv) => inv.invoiceNumber == 'INV-USER1-001'), isTrue);
        expect(user1Invoices.any((inv) => inv.invoiceNumber == 'INV-USER2-001'), isFalse);
      });

  testWidgets('Интеграционный тест 7: Создание нескольких заявлений и фильтрация',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'multi_app_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7907${timestamp.toString().substring(0, 7)}';
        final userName = 'Множественные Заявления';

        await registerTestUser(login, password, phoneNumber, userName);
        await authRemoteDataSource.loginUser(login, password);

        final services = [
          Service(
            id: 'svc_multi_1',
            title: 'Услуга 1',
            description: 'Описание 1',
            category: ServiceCategory.transport,
            requiredFields: [],
          ),
          Service(
            id: 'svc_multi_2',
            title: 'Услуга 2',
            description: 'Описание 2',
            category: ServiceCategory.education,
            requiredFields: [],
          ),
          Service(
            id: 'svc_multi_3',
            title: 'Услуга 3',
            description: 'Описание 3',
            category: ServiceCategory.taxes,
            requiredFields: [],
          ),
        ];

        for (var i = 0; i < services.length; i++) {
          final appointment = Appointment(
            id: 'app_multi_${i}_$timestamp',
            service: services[i],
            appliedAt: DateTime.now(),
            status: i == 0 ? AppointmentStatus.approved : AppointmentStatus.submitted,
            formData: {},
          );
          await appointmentRemoteDataSource.addAppointment(appointment);
        }

        final allAppointments = await appointmentRemoteDataSource.getAppointmentsByStatus(null);
        expect(allAppointments.length, greaterThanOrEqualTo(3));
        expect(allAppointments.any((app) => app.service.id == 'svc_multi_1'), isTrue);
        expect(allAppointments.any((app) => app.service.id == 'svc_multi_2'), isTrue);
        expect(allAppointments.any((app) => app.service.id == 'svc_multi_3'), isTrue);
      });

  testWidgets('Интеграционный тест 8: Выход из системы и очистка локальных данных',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'logout_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7908${timestamp.toString().substring(0, 7)}';
        final userName = 'Тест Выхода';

        await registerTestUser(login, password, phoneNumber, userName);
        await authRemoteDataSource.loginUser(login, password);

        var savedLogin = await authRemoteDataSource.getCurrentUserLogin();
        expect(savedLogin, equals(login));

        final invoice = Invoice(
          id: 'inv_logout_$timestamp',
          serviceName: 'Квитанция до выхода',
          invoiceNumber: 'INV-LOGOUT-001',
          status: InvoiceStatus.unpaid,
          amount: 999.99,
          issueAddress: 'Адрес',
          destinationAddress: 'Адрес доставки',
        );
        await invoiceRemoteDataSource.addInvoice(invoice);

        var invoices = await invoiceRemoteDataSource.getInvoices();
        expect(invoices, isNotEmpty);

        await authRemoteDataSource.logout();

        savedLogin = await authRemoteDataSource.getCurrentUserLogin();
        expect(savedLogin, isNull);

        invoices = await invoiceRemoteDataSource.getInvoices();
        expect(invoices, isEmpty);
      });

  testWidgets('Интеграционный тест 9: Обработка ошибок при неверных учетных данных',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'error_$timestamp';
        final password = 'CorrectPass123';
        final phoneNumber = '+7909${timestamp.toString().substring(0, 7)}';
        final userName = 'Тест Ошибок';

        await registerTestUser(login, password, phoneNumber, userName);

        try {
          await authRemoteDataSource.loginUser(login, 'WrongPassword123');
          fail('Должно быть выброшено исключение при неверном пароле');
        } catch (e) {
          expect(e.toString(), contains('Login error'));
        }

        try {
          await authRemoteDataSource.loginUser('nonexistent_user_$timestamp', password);
          fail('Должно быть выброшено исключение при несуществующем пользователе');
        } catch (e) {
          expect(e.toString(), contains('Login error'));
        }

        final token = await authRemoteDataSource.loginUser(login, password);
        expect(token, isNotNull);
      });

  testWidgets('Интеграционный тест 10: Создание квитанций с разными статусами',
          (WidgetTester tester) async {

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final login = 'invoice_statuses_$timestamp';
        final password = 'TestPass123';
        final phoneNumber = '+7910${timestamp.toString().substring(0, 7)}';
        final userName = 'Тест Статусов Квитанций';

        await registerTestUser(login, password, phoneNumber, userName);
        await authRemoteDataSource.loginUser(login, password);

        final statusesToTest = [
          InvoiceStatus.unpaid,
          InvoiceStatus.paid,
          InvoiceStatus.overdue,
        ];

        for (var i = 0; i < statusesToTest.length; i++) {
          final invoice = Invoice(
            id: 'inv_status_${i}_$timestamp',
            serviceName: 'Услуга со статусом ${statusesToTest[i].index}',
            invoiceNumber: 'INV-STATUS-00$i',
            status: statusesToTest[i],
            amount: 1000.00 * (i + 1),
            issueAddress: 'Адрес $i',
            destinationAddress: 'Адрес доставки $i',
          );
          await invoiceRemoteDataSource.addInvoice(invoice);
        }

        final invoices = await invoiceRemoteDataSource.getInvoices();

        expect(invoices.length, greaterThanOrEqualTo(3));
        expect(invoices.any((inv) => inv.status == InvoiceStatus.unpaid), isTrue);
        expect(invoices.any((inv) => inv.status == InvoiceStatus.paid), isTrue);
        expect(invoices.any((inv) => inv.status == InvoiceStatus.overdue), isTrue);

        final unpaidInvoice = invoices.firstWhere((inv) => inv.status == InvoiceStatus.unpaid);
        await invoiceRemoteDataSource.updateInvoiceStatus(
          invoiceId: unpaidInvoice.id,
          status: InvoiceStatus.paid,
        );

        final updatedInvoices = await invoiceRemoteDataSource.getInvoices();
        final updatedInvoice = updatedInvoices.firstWhere((inv) => inv.id == unpaidInvoice.id);
        expect(updatedInvoice.status, equals(InvoiceStatus.paid));
      });
}