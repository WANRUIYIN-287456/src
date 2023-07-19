import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/order.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/barterorderdetails_screen.dart';
import 'package:http/http.dart' as http;

class BarterOrderScreen extends StatefulWidget {
  final User user;
  const BarterOrderScreen({super.key, required this.user});

  @override
  State<BarterOrderScreen> createState() => _BarterOrderScreenState();
}

class _BarterOrderScreenState extends State<BarterOrderScreen> {
  late double screenHeight, screenWidth, cardwitdh;

  String status = "Loading...";
  List<Order> orderList = <Order>[];
  @override
  void initState() {
    super.initState();
    loaduserorders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Your Order")),
      body: Container(
        child: orderList.isEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 7,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/images/profile.png",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Hello ${widget.user.name}!",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          // Expanded(
                          //   flex: 3,
                          //   child: Row(children: [
                          //     IconButton(
                          //       icon: const Icon(Icons.notifications),
                          //       onPressed: () {},
                          //     ),
                          //     IconButton(
                          //       icon: const Icon(Icons.search),
                          //       onPressed: () {},
                          //     ),
                          //   ]),
                          // )
                        ],
                      ),
                    ),
                  ),
                  const Text("Your Current Order"),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            Order myorder =
                                Order.fromJson(orderList[index].toJson());
                            if (orderList[index].orderStatus == "Paid") {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BarterOrderDetailsScreen(order: myorder),
                                ),
                              );
                            } else if (orderList[index].orderStatus ==
                                "Barter") {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BarterOrderDetailsScreen(order: myorder),
                                ),
                              );
                            }
                            loaduserorders();
                          },
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order ID: ${orderList[index].orderId}"),
                                  Text(
                                      "Status: ${orderList[index].orderStatus}")
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
  // Column(
  //   children: [
  //     Text(
  //       "RM ${double.parse(orderList[index].orderPaid.toString()).toStringAsFixed(2)}",
  //       style: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold),
  //     ),
  //     const Text("")
  //   ],
  // )
  //  Text(orderList[index].orderBill.toString()),
  //                               Text(orderList[index].orderStatus.toString()),
  //                               Text(orderList[index].orderPaid.toString()),

  void loaduserorders() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_barterorder.php"),
        body: {"barteruserid": widget.user.id}).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          orderList.clear();
          var extractdata = jsondata['data'];
          extractdata['orders'].forEach((v) {
            orderList.add(Order.fromJson(v));
          });
        } else {
          status = "Please register an account first";
          setState(() {});
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No Order Available.")));
        }
        setState(() {});
      }
    });
  }
}
