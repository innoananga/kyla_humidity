import 'package:flutter/material.dart';

import '../resources /colors.dart';
import 'humidity_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedPageIndex = 1;

  final pages = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.show_chart),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.opacity),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: const HumidityScreen(),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        items: pages,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        backgroundColor: Palette.transparent,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Palette.white,
        unselectedItemColor: Palette.darkGrey,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
