import 'package:flutter/material.dart';
import 'package:flutter5/features/user_services/screens/user_service_list_screen.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/services/models/service.dart';
import 'features/services/screens/service_form_screen.dart';
import 'features/shared/HomeScaffold.dart';
import 'features/shared/app_theme.dart';
import 'features/services/screens/search_service_screen.dart';
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
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScaffold(),
        ),
        GoRoute(
          path: '/userServiceList',
          builder: (context, state) => const UserServiceListScreen(),
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
          name: 'profile',
          pageBuilder: (context, state) => const MaterialPage(child: ProfileScreen()),
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