import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:flutter5/domain/models/invoice.dart';
import 'package:flutter5/domain/models/service.dart';
import 'package:flutter5/domain/models/appointment.dart';
import 'package:flutter5/injection_container.dart' as di;
import 'package:flutter5/ui/features/authentication/screens/login_screen.dart';
import 'package:flutter5/ui/features/authentication/screens/register_screen.dart';
import 'package:flutter5/ui/features/gosuslugi/screens/link_gosuslugi_screen.dart';
import 'package:flutter5/ui/features/invoice/screens/invoice_add_screen.dart';
import 'package:flutter5/ui/features/invoice/screens/invoice_edit_screen.dart';
import 'package:flutter5/ui/features/invoice/screens/invoice_list_screen.dart';
import 'package:flutter5/ui/features/profile/screens/profile_screen.dart';
import 'package:flutter5/ui/features/profile/screens/profile_screen_change.dart';
import 'package:flutter5/ui/features/service/screens/search_service_screen.dart';
import 'package:flutter5/ui/features/service/screens/service_form_screen.dart';
import 'package:flutter5/ui/features/service/screens/service_list_screen.dart';
import 'package:flutter5/ui/features/support/screens/support_screen.dart';
import 'package:flutter5/ui/features/application/screens/status_change_screen.dart';
import 'package:flutter5/ui/features/application/screens/appointment_detail_screen.dart';
import 'package:flutter5/ui/features/application/screens/appointment_list_screen.dart';
import 'package:flutter5/ui/shared/app_theme.dart';
import 'package:flutter5/ui/shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
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
          builder: (context, state) => SearchServiceScreen(initialQuery: state.extra as String? ?? ''),
        ),
        GoRoute(
          path: '/serviceDetail',
          builder: (context, state) {
            final service = state.extra as Appointment;
            return ServiceDetailScreen(userService: service);
          },
        ),
        GoRoute(
          path: '/statusChange',
          builder: (context, state) {
            final service = state.extra as Appointment;
            return StatusChangeScreen(service: service);
          },
        ),
        GoRoute(
          path: '/serviceForm',
          builder: (context, state) {
            final service = state.extra as Service?;
            return ServiceFormScreen(service: service);
          },
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
          path: '/linkGosuslugi',
          builder: (context, state) => const LinkGosuslugiScreen(),
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
          path: '/invoiceEdit',
          builder: (context, state) {
            final invoice = state.extra as Invoice;
            return InvoiceEditScreen(invoice: invoice);
          },
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Госуслуги — Заявления',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key}) : super(key: key);

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authRemoteDataSource = GetIt.I<AuthRemoteDataSource>();

    Widget _getBody() {
      switch (_currentIndex) {
        case 0:
          return const ServiceListScreen();
        case 1:
          return const UserServiceListScreen();
        case 2:
          return const InvoiceListScreen();
        case 3:
          return const SupportScreen();
        case 4:
        default:
          return const ProfileScreen();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Госуслуги'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              authRemoteDataSource.logout();
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
