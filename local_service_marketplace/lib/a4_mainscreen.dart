import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a5_0_hometabscreen.dart';
import 'package:local_service_marketplace/a6_0_servicetabscreen.dart';
import 'package:local_service_marketplace/a8_0_accounttabscreen.dart';
import 'package:local_service_marketplace/a7_notificationtabscreen.dart';
import 'package:local_service_marketplace/model/user.dart';




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
 // List<Product> productList = <Product>[];
  
  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("MainScreen");
    tabchildren = [
      //key?
      
      //BarterTabScreen(user: widget.user),
      //ProductTabScreen(user: widget.user),
      HomeTabScreen(user: widget.user),
      ServiceTabScreen(user: widget.user),
      const NotificationTabScreen(),
      AccountTabScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_repair_service,
                ),
                label: "Services"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                ),
                label: "Notifications"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Account"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      } else if (_currentIndex == 1) {
        maintitle = "Services";
      } else if (_currentIndex == 2) {
        maintitle = "Notifications";
      } else if (_currentIndex == 3) {
        maintitle = "Account";
      } 
    });
  }
}