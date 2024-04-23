import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a9_2_adminverifylist.dart';
import 'package:local_service_marketplace/a9_3_adminnotifylist.dart';
import 'package:local_service_marketplace/model/admin.dart';


class AdminMainScreen extends StatefulWidget {
  final Admin admin;
  const AdminMainScreen({super.key, required this.admin});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Admin Main Screen";
 // List<Product> productList = <Product>[];
  
  @override
  void initState() {
    super.initState();
    print(widget.admin.name);
    print("MainScreen");
    tabchildren = [
      AdminVerifyList(admin: widget.admin),
      AdminNotifyList(admin: widget.admin),

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
                label: "Service Provider"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                ),
                label: "Notifications"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Service Provider";
      } else if (_currentIndex == 1) {
        maintitle = "Notifications";
      }
    });
  }
}