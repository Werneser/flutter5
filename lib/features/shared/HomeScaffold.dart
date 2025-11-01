import 'package:flutter/material.dart';
import 'package:flutter5/features/shared/widgets/bottom_nav_bar.dart';

import '../../app.dart';
import '../profile/screens/profile_screen.dart';
import '../services/screens/service_list_screen.dart';
import '../user_services/screens/user_service_list_screen.dart';


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
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: appState.currentTabIndex,
            onTap: appState.setTab,
          ),
        );
      },
    );
  }
}