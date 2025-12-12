import 'package:flutter/material.dart';

import 'app.dart';
import 'features/profile/screens/profile_screen.dart' hide ServiceListScreen;
import 'features/services/screens/service_form_screen.dart';
import 'features/services/screens/service_list_screen.dart';
import 'features/shared/app_theme.dart';
import 'features/shared/widgets/bottom_nav_bar.dart';
import 'features/user_services/screens/user_service_list_screen.dart';

void main() {
  final appState = AppState.initial();
  setupDependencies(appState);

  runApp(AppRoot(appState: appState));
}

class AppRoot extends StatelessWidget {
  final AppState appState;

  const AppRoot({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {


    return AppStateScope(
      appState: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Госуслуги — Заявления',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routes: {
          '/': (_) => const HomeScaffold(),
          '/serviceForm': (_) => const ServiceFormScreen(),
        },
      ),
    );
  }
}

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final appStateFromScope = AppStateScope.of(context);
    final appStateFromDi = getIt<AppState>();

    final appState = appStateFromScope;

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
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: appState.currentTabIndex,
            onTap: appState.setTab,
          ),
        );
      },
    );
  }
}