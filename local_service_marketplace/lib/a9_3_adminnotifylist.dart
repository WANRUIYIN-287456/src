import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a9_5_adminaddnotify.dart';
import 'package:local_service_marketplace/a9_6_admineditnotify.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/notification.dart';
import 'package:local_service_marketplace/model/admin.dart';

class AdminNotifyList extends StatefulWidget {
  final Admin admin;
  const AdminNotifyList({super.key, required this.admin});

  @override
  State<AdminNotifyList> createState() => _AdminNotifyListState();
}

class _AdminNotifyListState extends State<AdminNotifyList> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Notifications";
  List<Notifications> newsList = <Notifications>[];

  @override
  void initState() {
    super.initState();
    loadNews();
    print(newsList.length);
    print("Notifications");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: newsList.isEmpty
          ? Center(
              child: Container(
              height: 350,
              alignment: Alignment.center,
              child: const Text("No Data"),
            ))
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        newsList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Notifications notifications =
                                    Notifications.fromJson(
                                        newsList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => EditNotifyScreen(
                                            admin: widget.admin, notifications: notifications)));
                                loadNews();
                              },
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${index + 1} ${newsList[index]
                                                  .notTitle}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          newsList[index].notBody.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          );
                        },
                      )))
            ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _insertDialog();
            setState(() {
              loadNews();
            });
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  _insertDialog() async {

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewNotifyScreen(
                    admin: widget.admin,
                  )));
      setState(() {
        loadNews();
      });
    
  }

  void loadNews() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_notifications.php"),
        body: {"userid": "0"}).then((response) {
      //print(response.body);
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
            print(newsList[0].notTitle);
          }
        }

        setState(() {
        
        });
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${newsList[index].notBody}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteNotification(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteNotification(int index) {
    http.post(Uri.parse("${Config.server}/lsm/php/delete_notifications.php"), body: {
      "notid": newsList[index].notId.toString()
    }).then((response) {
      print(response.body);
      //newsList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadNews();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      }
    });
  }
}
