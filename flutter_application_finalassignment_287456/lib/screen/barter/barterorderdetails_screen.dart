import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/order.dart';
import 'package:flutter_application_finalassignment_287456/model/orderpay.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:http/http.dart' as http;


class BarterOrderDetailsScreen extends StatefulWidget {
  final Order order;
  const BarterOrderDetailsScreen({super.key, required this.order});

  @override
  State<BarterOrderDetailsScreen> createState() =>
      _BarterOrderDetailsScreenState();
}

// ignore: duplicate_ignore
class _BarterOrderDetailsScreenState extends State<BarterOrderDetailsScreen> {
  List<OrderPay> orderpayList = <OrderPay>[];
  late Order order;
  late double screenHeight, screenWidth;
  String paymentstatus = "Processing";
  List<String> paymentstatuslist = [
    "Processing",
    "Ready",
    "Completed",

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
    //loadorderdetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Column(children: [
        SizedBox(
          //flex: 3,
          height: screenHeight / 5.5,
          child: Card(
              child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                width: screenWidth * 0.3,
                child: CachedNetworkImage(
                    imageUrl:
                        "${Config.server}/LabAssign2/assets/images/profile/${widget.order.userId}.png?",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) => Image.network(
                          "${Config.server}/LabAssign2/assets/images/profile/0.png",
                          scale: 2,
                        )),
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
                              Text("Owner name: ${user.name}",
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
        SizedBox(
          // color: Colors.red,
          width: screenWidth,
          height: screenHeight * 0.1,
          child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Set order status as completed"),
                  ElevatedButton(
                      onPressed: () {
                        submitStatus("Completed");
                      },
                      child: const Text("Submit"))
                ]),
          ),
        ),
        orderpayList.isEmpty
            ? const SizedBox(child: Text("No Data Found"))
            : Expanded(
                flex: 7,
                child: ListView.builder(
                    itemCount: orderpayList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            CachedNetworkImage(
                              width: screenWidth / 3,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${Config.server}/LabAssign2/assets/images/${orderpayList[index].productId}.png",
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
                                  Text(
                                    orderpayList[index]
                                        .productName
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Quantity: ${orderpayList[index].paymentAmount}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Text(
                                  //   "Paid: RM ${double.parse(orderpayList[index].orderdetailPaid.toString()).toStringAsFixed(2)}",
                                  //   style: const TextStyle(
                                  //       fontSize: 12,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                ],
                              ),
                            )
                          ]),
                        ),
                      );
                    })),
      ]),
    );
  }

  void loadorderpay() {
    http.post(
        Uri.parse(
            "${Config.server}/LabAssign2/php/load_barterorderbarter.php"),
        body: {
          "barteruserid": widget.order.barteruserId,
          "pay": "pay"
        }).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
           order = jsondata['order'];
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
          "userid": widget.order.userId,
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

  void submitStatus(String st) {
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/set_orderstatus.php"),
        body: {"orderid": widget.order.orderId, "status": st}).then((response) {
      log(response.body);
      print(response.statusCode);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if (jsondata['status'] == "success") {
        } else {}
        widget.order.orderStatus = st;
        //selectStatus = st;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success")));
      }
    });
  }
}