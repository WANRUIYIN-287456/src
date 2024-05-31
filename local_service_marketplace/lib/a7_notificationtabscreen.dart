import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/notification.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/rating.dart';
import 'package:local_service_marketplace/model/user.dart';

class NotificationTabScreen extends StatefulWidget {
  final User user;
  const NotificationTabScreen({super.key, required this.user});

  @override
  State<NotificationTabScreen> createState() => _NotificationTabScreenState();
}

class _NotificationTabScreenState extends State<NotificationTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  List<Notifications> userNotList = <Notifications>[];
  List<Notifications> newsList = <Notifications>[];
  late User user = User(
    id: "na",
    name: "na",
    email: "na",
    phone: "na",
    datereg: "na",
    password: "na",
    otp: "na",
  );

  @override
  void initState() {
    super.initState();
    loadUserNotification();
    loadNews();
    print(userNotList.length);
    print("user" + widget.user.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Text(
                  "\nYour notifications\n",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                )),
            userNotList.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: const Text("No Data"),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userNotList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (index + 1).toString() +
                                      " " +
                                      userNotList[index].notTitle.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Text(
                                  userNotList[index].notBody.toString(),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Text(
                  "\nNews Updates\n",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                )),
            newsList.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: const Text("No Data"),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (index + 1).toString() +
                                      " " +
                                      newsList[index].notTitle.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Text(
                                  newsList[index].notBody.toString(),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void loadUserNotification() {
    if (widget.user.id == "na") {
      print("Notification user id: " + widget.user.id.toString());
      userNotList.clear();
      setState(() {});
      return;
    }

    http.post(Uri.parse("${Config.server}/lsm/php/load_notifications.php"),
        body: {"userid": widget.user.id.toString()}).then((response) {
      print(response.body);
      //log(response.body);
      userNotList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          for (var v in extractdata) {
            userNotList.add(Notifications.fromJson(v));
          }
          if (userNotList.isNotEmpty) {
            print(userNotList[0].userId);
          }
        }
        setState(() {});
      }
    });
  }

  void loadNews() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_notifications.php"),
        body: {"userid": "0"}).then((response) {
      print(response.body);
      //log(response.body);
      newsList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          for (var v in extractdata) {
            newsList.add(Notifications.fromJson(v));
          }
          if (newsList.isNotEmpty) {
            print(newsList[0].userId);
          }
        }
        setState(() {});
      }
    });
  }
}
