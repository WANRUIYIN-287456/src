import 'package:flutter/material.dart';
import 'package:my_nelayan/screens/BuyerTabScreen.dart';
import 'package:my_nelayan/screens/NewsTabScreen.dart';
import 'package:my_nelayan/screens/ProfileTabScreen.dart';

void main() => runApp(const SellerTabScreen());

class SellerTabScreen extends StatefulWidget {
  const SellerTabScreen({Key? key}) : super(key: key);
  @override
  _SellerTabScreenState createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  @override
  late List<Widget> tabchildren;
  int _currentIndex = 1;
  String maintitle = "Seller";
  void initState() {
    super.initState();
    tabchildren = const [
      BuyerTabScreen(),
      SellerTabScreen(),
      ProfileTabScreen(),
      NewsTabScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
              ),
              label: "Buyer"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.store_mall_directory,
              ),
              label: "Seller"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.newspaper,
              ),
              label: "News"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Buyer";
      }
      if (_currentIndex == 1) {
        maintitle = "Seller";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
      if (_currentIndex == 3) {
        maintitle = "News";
      }
    });
  }
}
