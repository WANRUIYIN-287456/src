import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a8_4_userordercompletedlist.dart';
import 'package:local_service_marketplace/a8_7_userordercancellist.dart';
import 'package:local_service_marketplace/model/user.dart';

class HistoryScreen extends StatefulWidget {
  final User user;
  const HistoryScreen({super.key, required this.user});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
@override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.white, // Set the background color of the TabBar
              child: const TabBar(
                tabs: [
                  Tab(text: 'Completed'), // Text label for Tab 2
                  Tab(text: 'Cancelled'), // Text label for Tab 3
                ],
                // Customizing the appearance of the tab bar
                indicator: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                bottom: BorderSide(color: Colors.teal, width: 4.0),// No color specified, as it will inherit from the theme
              ), // Teal color for indicator (selected tab)
                ),
                // Setting the text color properties
                labelColor: Colors.black, // Text color for selected tab
                unselectedLabelColor: Colors.grey, // Text color for unselected tabs
                // Customizing the text style for unselected tabs
                labelStyle: TextStyle(fontWeight: FontWeight.bold), // Text style for selected tab
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Text style for unselected tabs
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            UserOrderCompleteList(user: widget.user),
            UserOrderCancelList(user: widget.user),
          ],
        ),
      ),
    );
  }
}