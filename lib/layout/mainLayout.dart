import 'package:fixit/pages/historyPage.dart';
import 'package:fixit/pages/home.dart';
import 'package:fixit/pages/partnerPage.dart';
import 'package:fixit/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({ Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List<Widget> _pages = <Widget>[
    HomeScreen(),
    History(),
    UserProfile(),
    PartnerPage()
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,  color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history,  color: Colors.blue),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,  color: Colors.blue),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service, color: Colors.blue),
            label: 'Mitra',
          ),
        ],
      ),
    );
  }
}
