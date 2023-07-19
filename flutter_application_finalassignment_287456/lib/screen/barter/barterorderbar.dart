import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/order.dart';
import 'package:flutter_application_finalassignment_287456/model/OrderBarter.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/message_screen.dart';
import 'package:http/http.dart' as http;

class BarterOrderBarScreen extends StatefulWidget {
  final Order order;
  const BarterOrderBarScreen({super.key, required this.order});

  @override
  State<BarterOrderBarScreen> createState() => _BarterOrderBarScreenState();
}

// ignore: duplicate_ignore
class _BarterOrderBarScreenState extends State<BarterOrderBarScreen> {
  //List<OrderBarter> orderbarterlist = <OrderBarter>[];
  late Product product;
  late double screenHeight, screenWidth;
  late int barterproductid , productid; 
  late OrderBarter orderbarter;
String barterstatus = "Waiting for response...";
List<String> barterstatuslist = [
    "Waiting for response...",
    "Accepted",
    "Rejected",

  ];
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");

  @override
  void initState() {
    super.initState();
    loadbarteruser();
    loadOrderBarter();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessageTabScreen()),
                );
              },
              icon: const Icon(Icons.message))
        ],
      ),
      body: Column(children: [
        SizedBox(
          //flex: 3,
          height: screenHeight / 5.5,
          child: Card(
              child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                width: screenWidth * 0.3,
                child: Image.asset(
                  "assets/images/profile.png",
                ),
              ),
              Column(
                children: [
                  user.id == "na"
                      ? const Center(
                          child: Text("Loading..."),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Buyer name: ${user.name}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("Phone: ${user.phone}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                              Text("Order ID: ${widget.order.orderId}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                              Text("Status: ${widget.order.orderStatus}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        )
                ],
              )
            ],
          )),
        ),
         Expanded(
                flex: 7,
                child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            CachedNetworkImage(
                              width: screenWidth / 3,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${Config.server}/LabAssign2/assets/images/${product.productId}.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //    barterproductid = orderbarterlist[index].barterproductId.toString(),
                                  // ),
                                 
                                  Text(
                                    product.productName.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Quantity: ${widget.order.orderQty}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),)
      ]),
    );
  }
  void loadProduct() {

    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_product.php"),
        body: {}).then((response) {
      //print(response.body);
      //log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          product = Product.fromJson(jsondata['data']);
        }
        setState(() {});
      }
    });
  }

  void loadOrderBarter() {
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/load_barterOrderBarter.php"),
        body: {
          "barteruserid": widget.order.barteruserId,
          "orderid": widget.order.orderId,
          "userid": widget.order.userId
        }).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
        orderbarter = OrderBarter.fromJson(jsondata['data']);
        } else {
          // status = "Please register an account first";
          // setState(() {});
        }
        setState(() {});
      }
    });
  }

  void loadbarteruser() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_user.php"),
        body: {
          "userid": widget.order.barteruserId,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }
}
