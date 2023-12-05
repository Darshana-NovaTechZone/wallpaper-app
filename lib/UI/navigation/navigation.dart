import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wall_app/Color/color.dart';

import '../home/favorite/favorite.dart';
import '../home/home.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
List imglist = [
  'assets/j1.jpg',
  'assets/j2.jpg',
  'assets/j3.jpg',
  'assets/j4.jpg',
  'assets/j.jpg',
];

int _selectedIndex = 0;

class _NavigationScreenState extends State<NavigationScreen> {
  static List<Widget> _pages = <Widget>[Home(), Favorites()];
  void _onItemTapped(int index) {
    log('ffff');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: navColor,
        // unselectedLabelStyle: TextStyle(fontSize: 11.sp),
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        unselectedIconTheme: IconThemeData(
          color: navUnSelect,
        ),
        unselectedLabelStyle: TextStyle(color: navUnSelect),
        unselectedItemColor: navUnSelect,
        selectedIconTheme: IconThemeData(
          color: navSelect,
        ),
        selectedItemColor: navSelect,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.copy_rounded,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
    );
  }
}
