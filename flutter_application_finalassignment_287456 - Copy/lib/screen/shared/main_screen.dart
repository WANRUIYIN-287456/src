import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/barter_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/message_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/product/product_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/shared/profile_screen.dart';



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
  List<Product> productList = <Product>[];
  
  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("MainScreen");
    tabchildren = [
      //key?
      ProfileTabScreen(user: widget.user),
      BarterTabScreen(user: widget.user),
      ProductTabScreen(user: widget.user),
      const MessageTabScreen(),
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
                  Icons.person,
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_grocery_store,
                ),
                label: "Barter"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.backpack,
                ),
                label: "Product"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: "Message"),
            
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Profile";
      } else if (_currentIndex == 1) {
        maintitle = "Barter";
      } else if (_currentIndex == 2) {
        maintitle = "Product";
      } else if (_currentIndex == 3) {
        maintitle = "Message";
      } 
    });
  }
}

