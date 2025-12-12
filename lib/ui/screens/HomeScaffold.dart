import 'package:flutter/material.dart';
import 'package:flutter5/data/datasources/auth_remote_datasource.dart';
import 'package:flutter5/ui/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../screens/invoice_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/service_list_screen.dart';
import '../screens/support_screen.dart';
import '../screens/user_service_list_screen.dart';

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
