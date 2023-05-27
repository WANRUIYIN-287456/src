import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_osproject/checkindata.dart';
import 'package:flutter_application_osproject/config.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CheckinTabScreen extends StatefulWidget {
  final CheckInData checkInData;
  const CheckinTabScreen({super.key, required this.checkInData});

  @override
  State<CheckinTabScreen> createState() => _CheckinTabScreenState();
}

class _CheckinTabScreenState extends State<CheckinTabScreen> {
  final TextEditingController _courseEditingController =
      TextEditingController();
  late double screenHeight, screenWidth, cardwidth;
  late Position _currentPosition;
  String curaddress = "Changlun";
  String curstate = "Kedah";
  String prlat = "6.460329";
  String prlong = "100.5010041";
  List productlist = [];
  String titlecenter = "Loading data...";

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Check-in Page"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: screenHeight * 0.21,
            width: screenWidth,
            child: Image.asset(
              "assets/images/checkin.png",
              fit: BoxFit.contain,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _courseEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "course code must be longer than 5"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: "Course Code",
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.book),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: onCheckin,
                              child: const Text("Check-in")),
                        ),
                      ],
                    )),
              )),
          SizedBox(
              height: 24,
              width: screenWidth * 0.8,
              child: Column(
                children: [
                  Text(widget.checkInData.userid.toString()),
                  Text(widget.checkInData.course.toString()),
                  Text("${widget.checkInData.location}, ${widget.checkInData.state}"),
                  Text(widget.checkInData.checkindate.toString()),
                ],
              )),
        ]),
      ),
    );
  }

  void onCheckin() {
    String course = _courseEditingController.text;
    http.post(Uri.parse("${Config.server}/OSProject/php/checkin.php"), body: {
      "user_course": course,
      //userid,state, locality, long, lat... except for date checkin
    }).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          //print(jsondata['data']);
          if (jsondata['status'] == 'success') {
            late CheckInData checkInData;
           checkInData = CheckInData.fromJson(jsondata['data']);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Check-in Success")));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Check-in Failed")));
            print(1);
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Check-in Failed")));
          print(2);
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    _currentPosition = await Geolocator.getCurrentPosition(); 
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
    _getAddress(_currentPosition);
    return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
      curaddress = placemarks[0].locality.toString();
      curstate = placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    });
  }

void _loadProducts() {
  http.post(Uri.parse("${Config.server}/OSProject/php/load_checkin.php"),
      body: {"user_id": widget.checkInData.userid}).then((response) {
        var data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      var extractdata = data['data'];
      setState(() {
        productlist = extractdata["History"];
        print(productlist);
      });
    } else {
      setState(() {
        titlecenter = "No Data";
      });
    }
  });
}





}


