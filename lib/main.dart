import 'package:flutter/material.dart';

import 'app.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/services/screens/service_form_screen.dart';
import 'features/services/screens/service_list_screen.dart';
import 'features/shared/app_theme.dart';
import 'features/shared/widgets/bottom_nav_bar.dart';
import 'features/user_services/screens/user_service_list_screen.dart';


void main() {
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  AppRoot({super.key});

  final AppState _appState = AppState.initial();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _appState,
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
    final appState = AppStateScope.of(context);

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
      body: body,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: appState.currentTabIndex,
        onTap: appState.setTab,
      ),
    );
  }
}