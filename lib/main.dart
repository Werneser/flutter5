import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter5/data/statechange/AppStateScope.dart';
import 'package:flutter5/ui/screens/user_service_list_screen.dart';
import 'package:flutter5/ui/screens/login_screen.dart';
import 'package:flutter5/ui/screens/register_screen.dart';
import 'package:go_router/go_router.dart';
import 'data/state/app.dart';
import 'ui/screens/invoice_list_screen.dart';
import 'ui/screens/link_gosuslugi_screen.dart';
import 'domain/models/invoice.dart';
import 'ui/screens/invoice_add_screen.dart';
import 'ui/screens/invoice_edit_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/profile_screen_change.dart';
import 'domain/models/service.dart';
import 'ui/screens/service_form_screen.dart';
import 'ui/screens/HomeScaffold.dart';
import 'ui/screens/service_list_screen.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/search_service_screen.dart';
import 'ui/screens/support_screen.dart';
import 'domain/models/user_service.dart';
import 'ui/screens/status_change_screen.dart';
import 'ui/screens/user_service_detail_screen.dart';

void main() {
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  AppRoot({Key? key}) : super(key: key);

  final AppState _appState = AppState.initial();

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
          builder: (context, state) => HomeScaffold(),
        ),
        GoRoute(
          path: '/ServiceList',
          builder: (context, state) => ServiceListScreen(),
        ),
        GoRoute(
          path: '/userServiceList',
          builder: (context, state) => const UserServiceListScreen(),
        ),
        GoRoute(
          path: '/searchService',
          builder: (context, state) => SearchServiceScreen(),
        ),
        GoRoute(
          path: '/serviceDetail',
          builder: (context, state) {
            final service = state.extra as UserService;
            return ServiceDetailScreen(userService: service);
          },
        ),
        GoRoute(
          path: '/statusChange',
          builder: (context, state) {
            final service = state.extra as UserService;
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
          pageBuilder: (context, state) => const MaterialPage(child: ProfileScreen()),
        ),
        GoRoute(
          path: '/profile/edit',
          pageBuilder: (context, state) => MaterialPage(
            child: ProfileScreenChange(
              initialFullName: state.extra != null ? (state.extra as Map)['fullName'] : '',
              initialPassport: state.extra != null ? (state.extra as Map)['passport'] : '',
              initialSnils: state.extra != null ? (state.extra as Map)['snils'] : '',
              initialPhone: state.extra != null ? (state.extra as Map)['phone'] : '',
              initialEmail: state.extra != null ? (state.extra as Map)['email'] : '',
            ),
          ),
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

    return AppStateScope(
      appState: _appState,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Госуслуги — Заявления',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}
