import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/services/models/service.dart';
import 'features/services/screens/service_form_screen.dart';
import 'features/services/screens/service_list_screen.dart';
import 'features/shared/app_theme.dart';
import 'features/shared/widgets/bottom_nav_bar.dart';
import 'features/user_services/screens/user_service_list_screen.dart';

void main() {
  runApp(AppRoot());
}

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        Widget body;
        switch (appState.currentTabIndex) {
          case 0:
            body = const ServiceListScreen();
            break;
          case 1:
            body = const UserServiceListScreen();
            break;
          case 2:
          default:
            body = const ProfileScreen();
            break;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Госуслуги'),
            centerTitle: true,
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            child: body,
          ),
        );
      },
    );
  }
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
          name: 'serviceForm',
          path: '/serviceForm',
          builder: (context, state) {
            final service = state.extra as Service?;
            return ServiceFormScreen(service: service);
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