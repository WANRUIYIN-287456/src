import 'dart:convert';
import 'package:checkin_project/config.dart';
import 'package:checkin_project/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CheckInFormScreen extends StatefulWidget {
  final User user;

  const CheckInFormScreen({super.key, required this.user});

  @override
  State<CheckInFormScreen> createState() => _CheckInFormScreenState();
}

class _CheckInFormScreenState extends State<CheckInFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _checkstateEditingController =
      TextEditingController();
  final TextEditingController _checklocalEditingController =
      TextEditingController();
  late Position _currentPosition;
  String curaddress = "";
  String curstate = "";
  String checklat = "";
  String checklong = "";
  String course = "Please choose your course";
  String group = "Please choose your group";
  List<String> checklist = [
    "Please choose your course",
    "BPME1013 INTRODUCTION TO ENTREPRENEURSHIP",
    "BWFF1013 FUNDAMENTALS OF FINANCE",
    "MPU1013 PENGHAYATAN ETIKA DAN PERADABAN",
    "MPU1043 PHILOSOPHY AND CONTEMPORARY ISSUES",
    "SADN1033 MALAYSIAN NATIONHOOD STUDIES",
    "SGDN1043 SCIENCE OF THINKING AND ETHICS",
    "STIA1113 PROGRAMMING 1",
    "STIA1123 PROGRAMMING 2",
    "STIA2024 DATA STRUCTURES AND ALGORITHM ANALYSIS",
    "STID3014 DATABASE SYSTEM AND INFORMATION RETRIEVAL",
    "STID3024 SYSTEM ANALYSIS AND DESIGN",
    "STID3074 IT PROJECT MANAGEMENT",
    "STID3113 RESEARCH METHOD IN IT",
    "STIJ2024 BASIC NETWORKING",
    "STIK1014 COMPUTER SYSTEM ORGANIZATION",
    "STIK2044 OPERATING SYSTEM",
    "STIN1013 INTRODUCTION TO ARTIFICIAL INTELLIGENCE",
    "STIV2013 HUMAN COMPUTER INTERACTION",
    "STQM1203 MATHEMATICS FOR INFORMATION TECHNOLOGY",
    "STQM2103 DISCRETE STRUCTURE",
    "STQS1023 STATISTICS FOR INFORMATION TECHNOLOGY"
  ];
  List<String> grouplist = [
    "Please choose your group",
    "Group A",
    "Group B",
    "Group C"
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Check-in"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
      body: Column(children: [
        const SizedBox(height: 20),
        SizedBox(
          height: screenHeight * 0.21,
          width: screenWidth,
          child: Image.asset(
            "assets/images/checkin2.png",
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Icon(Icons.book),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 60,
                          width: 250,
                          child: DropdownButton(
                            isExpanded: true,
                            value: course,
                            onChanged: (newValue) {
                              setState(() {
                                course = newValue!;
                                print(course);
                              });
                            },
                            items: checklist.map((course) {
                              return DropdownMenuItem(
                                value: course,
                                child: Text(
                                  course,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.abc),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          height: 60,
                          width: 250,
                          child: DropdownButton(
                            value: group,
                            onChanged: (newValue2) {
                              setState(() {
                                group = newValue2!;
                                print(group);
                              });
                            },
                            items: grouplist.map((group) {
                              return DropdownMenuItem(
                                value: group,
                                child: Text(
                                  group,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              controller: _checkstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current State',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current Locality"
                                      : null,
                              controller: _checklocalEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current Locality',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.map),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            checkDialog();
                          },
                          child: const Text("Check in")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void checkDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    } else {
      insertcheck();
    }
  }

  void insertcheck() {
    String state = _checkstateEditingController.text;
    String locality = _checklocalEditingController.text;

    http.post(Uri.parse("${Config.server}/OSProject/php/checkin.php"), body: {
      "userid": widget.user.id.toString(),
      "course": course,
      "group": group,
      "locality": locality,
      "state": state,
      "latitude": checklat,
      "longitude": checklong,
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Check-in Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Check-in Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Check-in Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();
    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _checklocalEditingController.text = "Changlun";
      _checkstateEditingController.text = "Kedah";
      checklat = "6.443455345";
      checklong = "100.05488449";
    } else {
      _checklocalEditingController.text = placemarks[0].locality.toString();
      _checkstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      checklat = _currentPosition.latitude.toString();
      checklong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}
