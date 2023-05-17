import 'package:flutter/material.dart';
import 'package:flutter_application_labassignment2_287456/profile_screen.dart';
import 'package:flutter_application_labassignment2_287456/user.dart';

import 'barter_screen.dart';


//for buyer screen

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Menu";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("MainScreen");

    tabchildren = [
                    //key?
      ProfileTabScreen(user: widget.user),
      const BarterTabScreen(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(maintitle)),
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_grocery_store,
                ),
                label: "Barter")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Profile";
      }
      if (_currentIndex == 1) {
        maintitle = "Barter";
      }
    });
  }
}