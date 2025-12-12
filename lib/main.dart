import 'package:flutter/material.dart';
import 'package:flutter5/features/user_services/screens/user_service_list_screen.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/profile/screens/about_govservices_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/profile_screen_change.dart';
import 'features/services/models/service.dart';
import 'features/services/screens/service_form_screen.dart';
import 'features/services/screens/service_list_screen.dart';
import 'features/shared/HomeScaffold.dart';
import 'features/shared/app_theme.dart';
import 'features/services/screens/search_service_screen.dart';
import 'features/support/screens/support_screen.dart';
import 'features/user_services/models/user_service.dart';
import 'features/user_services/screens/status_change_screen.dart';
import 'features/user_services/screens/user_service_detail_screen.dart';

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
          path: '/govads',
          pageBuilder: (context, state) => const MaterialPage(child: GovAdsScreen()),
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
