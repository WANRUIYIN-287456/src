import 'dart:convert';
import 'package:checkin_project/check.dart';
import 'package:checkin_project/config.dart';
import 'package:http/http.dart' as http;
import 'package:checkin_project/checkin_form.dart';
import 'package:checkin_project/user.dart';
import 'package:flutter/material.dart';

class CheckinTabScreen extends StatefulWidget {
  final User user;
  const CheckinTabScreen({super.key, required this.user});

  @override
  State<CheckinTabScreen> createState() => _CheckinTabScreenState();
}

class _CheckinTabScreenState extends State<CheckinTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Checkin";
  List<Check> checkinList = <Check>[];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  @override
  void initState() {
    super.initState();
    print("Checkin");
    _loadCheckin();
    print("success");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: checkinList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Check-in History",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Column(
                  children: List.generate(checkinList.length, (index) {
                    return Center(
                      child: Column(
                        children: [
                          const Text(""),
                          // Text("${checkinList[index].checkinCourse.toString()}(${checkinList[index].checkinGroup.toString()})",
                          //             style: const TextStyle(
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.bold)),
                          Text("    ${checkinList[index].checkinCourse.toString()}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                    
                          Text(
                            checkinList[index].checkinGroup.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "${checkinList[index].checkinLocation.toString()}, ${checkinList[index].checkinState.toString()}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            checkinList[index].checkinDate.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Text(""),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.user.id != "na") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => CheckInFormScreen(
                            user: widget.user,
                          )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account.")));
            }
          },
          child: const Text("+", style: TextStyle(fontSize: 32))),
    );
  }

  void _loadCheckin() {
    http.post(Uri.parse("${Config.server}/OSProject/php/load_checkin.php"),
        body: {"userid": widget.user.id}).then((response) {
      try {
        //checkinList.clear();
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            var extractdata = jsondata['data'];
            checkinList = <Check>[];
            extractdata['history'].forEach((v) {
              checkinList.add(Check.fromJson(v));
            });
            print(checkinList[0].checkinId);
            setState(() {});
          }
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }
}
