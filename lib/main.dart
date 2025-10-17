import 'package:flutter/material.dart';

import 'app.dart';
import 'app_theme.dart';
import 'bottom_nav_bar.dart';
import 'profile_screen.dart';
import 'service_list_screen.dart';
import 'service_form_screen.dart';
import 'user_service_list_screen.dart';

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

/// Каркас приложения с нижней навигацией и переключением вкладок
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