import 'dart:convert';
import 'dart:math';
//import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_service_marketplace/a6_1_newservicescreen.dart';
import 'package:local_service_marketplace/a6_2_editservicescreen.dart';
import 'package:local_service_marketplace/a6_3_serviceverify.dart';
import 'package:local_service_marketplace/a6_4_sellerorderlistmainscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';

class ServiceTabScreen extends StatefulWidget {
  final User user;
  const ServiceTabScreen({super.key, required this.user});

  @override
  State<ServiceTabScreen> createState() => ServiceTabScreenState();
}

class ServiceTabScreenState extends State<ServiceTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Service";
  List<Service> serviceList = <Service>[];
  Random random = Random();
  var val = 50;

  @override
  void initState() {
    super.initState();
    loadService();
    print(serviceList.length);
    print("Service");
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
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Your Order"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Identity Verification"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              if (widget.user.id.toString() == "na") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => SellerOrderScreen(
                            user: widget.user,
                          )));
            } else if (value == 1) {
              if (widget.user.id.toString() == "na") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
                return;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          SellerVerificationScreen(user: widget.user)));
            } else if (value == 2) {
              print("Logout menu is selected.");
            }
          }),
        ],
      ),
      body: serviceList.isEmpty
          ? Center(
              child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: Container(
                      height: 70,
                      width: 300,
                      color: Colors.white,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) =>
                                      SellerVerificationScreen(
                                          user: widget.user)));
                        },
                        child: const Text(
                          "\nPlease upload verify your identity and certifications to get PRO/PREFERRED status here or Verify later at the \"More\" button.",
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 21, 21),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                Container(
                  height: 350,
                  alignment: Alignment.center,
                  child: const Text("No Data"),
                )
              ],
            ))
          : Column(children: [
              Container(
                height: 24,
                color: Color.fromARGB(255, 60, 213, 198),
                alignment: Alignment.center,
                child: Text(
                  "${serviceList.length} Service(s) Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        serviceList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Service service = Service.fromJson(
                                    serviceList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => EditServiceScreen(
                                              user: widget.user,
                                              service: service,
                                            )));
                                loadService();
                              },
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 17, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (serviceList[index]
                                              .proStatus
                                              .toString() ==
                                          "true")
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color: Colors.orangeAccent,
                                          ),
                                          child: const Text("  Pro  "),
                                        ),
                                      const SizedBox(width: 8),
                                      if (serviceList[index]
                                              .preferredStatus
                                              .toString() ==
                                          "true")
                                        Container(
                                          //margin: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            color: Colors.orangeAccent,
                                          ),
                                          child: const Text("  Preferred  "),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                CachedNetworkImage(
                                  width: screenWidth * 0.35,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${Config.server}/lsm/assets/images/${serviceList[index].serviceId}.png?v=$val",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  serviceList[index].serviceName.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "RM ${double.parse(serviceList[index].servicePrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "per ${serviceList[index].serviceUnit.toString()}",
                                  style: const TextStyle(fontSize: 14),
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
              loadService();
            });
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  _insertDialog() async {
    if (widget.user.id == "na") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please login/register to your account.")));
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewServiceScreen(
                    user: widget.user,
                  )));
      setState(() {
        loadService();
      });
    }
  }

  void loadService() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${Config.server}/lsm/php/load_product.php"),
        body: {"sellerid": widget.user.id}).then((response) {
      //print(response.body);
      //log(response.body);
      serviceList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['service'].forEach((v) {
            serviceList.add(Service.fromJson(v));
          });
          if (serviceList.isNotEmpty) {
            print(serviceList[0].serviceName);
          }
        }

        setState(() {
          val = random.nextInt(1000);
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
            "Delete ${serviceList[index].serviceName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteService(index);
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

  void deleteService(int index) {
    http.post(Uri.parse("${Config.server}/lsm/php/delete_product.php"), body: {
      "userid": widget.user.id,
      "productid": serviceList[index].serviceId
    }).then((response) {
      print(response.body);
      //serviceList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadService();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      }
    });
  }
}
