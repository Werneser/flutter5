import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isEmployee;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isEmployee = false,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: isEmployee ? _employeeItems : _userItems,
    );
  }

  static const List<BottomNavigationBarItem> _userItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: 'Каталог',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment),
      label: 'Мои услуги',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt),
      label: 'Квитанции',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.support_agent),
      label: 'Поддержка',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Профиль',
    ),
  ];

  static const List<BottomNavigationBarItem> _employeeItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt),
      label: 'Все заявки',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt),
      label: 'Квитанции',
    ),
  ];
}