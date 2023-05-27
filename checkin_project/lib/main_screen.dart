import 'package:checkin_project/checkin_screen.dart';
import 'package:checkin_project/profile_screen.dart';
import 'package:checkin_project/user.dart';
import 'package:flutter/material.dart';

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
      CheckinTabScreen(user: widget.user),
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
                  Icons.check,
                ),
                label: "Checkin")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Profile";
      }
      else if (_currentIndex == 1) {
        maintitle = "Checkin";
      }
    });
  }
}