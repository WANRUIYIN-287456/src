import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a8_11_sellerchatscreen.dart';
import 'package:local_service_marketplace/a8_9_userchatscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';

class SellerOrderUpcomingDetails extends StatefulWidget {
  final Order order;
  const SellerOrderUpcomingDetails({super.key, required this.order});

  @override
  State<SellerOrderUpcomingDetails> createState() =>
      _SellerOrderUpcomingDetailsState();
}

// ignore: duplicate_ignore
class _SellerOrderUpcomingDetailsState
    extends State<SellerOrderUpcomingDetails> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late String combineddate = "0000-00-00 00:00:00.000000";
  late double screenHeight, screenWidth;
  late Order order;
  String submitstatus = "New";
  String sellerstatus = "New";
  String orderstatus = "Upcoming";
  bool isArrivedEnabled = false;
  bool isConfirmedEnabled = false;
  String paymentstatus = "Pending";
  late String reason;
  late DateTime servicedate;
  late DateTime orderdate;
  late int token = 0;
    Random random = Random();
  var val = 50;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");
  late User user2 = User(
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
    loadseller();
    loaduserorders();
    paymentstatus = widget.order.paymentStatus.toString();
    submitstatus = widget.order.orderUserstatus.toString();
    sellerstatus = widget.order.orderSellerstatus.toString();
    servicedate = DateTime.parse(widget.order.orderServicedate.toString());
    orderdate = DateTime.parse(widget.order.orderDate.toString());

    if (paymentstatus == "Paid" &&
        submitstatus == "New" &&
        sellerstatus == "New") {
      isConfirmedEnabled = true;
    }
    if (sellerstatus == "Confirmed" && submitstatus == "New") {
      isArrivedEnabled = true;
    }
    // Check if sellerstatus is 'New' and servicedate is today or later
    if (sellerstatus == "New" && DateTime.now().isAfter(servicedate)) {
      sellerstatus = "Cancelled";
      orderstatus = "Cancelled";
      reason =
          "Service Provider did not confirm the order before service date.";
      cancelService(reason);
      token = token - 1;
      print(token);
    }
    //Check if sellerstatus is 'New' and today is 7 days or more than orderdate
    else if (sellerstatus == "New" &&
        DateTime.now().difference(orderdate).inDays >= 7) {
      sellerstatus = "Cancelled";
      orderstatus = "Cancelled";
      reason = "Service Provider did not confirm the order within 7 days.";
      cancelService(reason);
      token = token - 1;
      print(token);
    }
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
                        builder: (context) =>
                            SellerChatScreen(user: user, order: widget.order)),
                  );
                },
                icon: const Icon(Icons.message))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              //flex: 3,
              height: screenHeight / 5.5,
              child: Card(
                  child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: screenWidth * 0.3,
                    child: CachedNetworkImage(
                        imageUrl:
                            "${Config.server}/lsm/assets/images/profile/${widget.order.userId}.png",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) => Image.network(
                              "${Config.server}/lsm/assets/images/profile/0.png",
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
                                  Text("Name: ${user.name}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text("Phone: ${user.phone}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      )),
                                  Text(
                                      "Order Status: ${widget.order.orderStatus}",
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
                child: Table(columnWidths: const {
                  0: FlexColumnWidth(0.3),
                  1: FlexColumnWidth(4.5),
                  2: FlexColumnWidth(0.3),
                  3: FlexColumnWidth(4.5),
                  4: FlexColumnWidth(0.3),
                }, children: [
                  TableRow(children: [
                    const TableCell(child: Text("")),
                    TableCell(
                        child: ElevatedButton(
                      onPressed: isConfirmedEnabled == false ||
                              sellerstatus == "Confirmed"
                          ? null
                          : () {
                              setState(() {
                                sellerstatus = "Confirmed";
                                submitStatus();
                                isArrivedEnabled = true;
                                isConfirmedEnabled = false;
                              });
                            },
                      child: const Text("Order Confirmed"),
                    )),
                    const TableCell(child: Text("")),
                    TableCell(
                        child: ElevatedButton(
                            onPressed: isArrivedEnabled == false ||
                                    sellerstatus == "Arrived"
                                ? null
                                : () {
                                    setState(() {
                                      sellerstatus = "Arrived";
                                      submitStatus();
                                      isConfirmedEnabled = false;
                                      isArrivedEnabled = false;
                                    });
                                  },
                            child: const Text("Service Arrived"))),
                    const TableCell(child: Text("")),
                  ]),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        width: screenWidth * 0.35,
                        fit: BoxFit.contain,
                        imageUrl:
                            "${Config.server}/lsm/assets/images/${widget.order.serviceId}.png?v=$val",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(height: 8),
                      Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            "${widget.order.serviceName}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(6),
                },
                children: [
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "Quantity Ordered",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        widget.order.orderQuantity.toString(),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nOrder Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\n${df.format(DateTime.parse(widget.order.orderDate.toString()))}",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nService Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\n${df.format(DateTime.parse(combineddate))}",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nOrder Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\nRM ${widget.order.orderTotalprice}",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nOrder Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                        child: Text("\n" + widget.order.orderStatus.toString())),
                  ]),
                ],
              ),
            )
          ]),
        ));
  }

  void loaduserorders() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
      "sellerid": widget.order.sellerId,
      "orderid": widget.order.orderId,
    }).then((response) {
      print(response.statusCode);
      //log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          order = Order.fromJson(jsondata['data']);
          setState(() {
            val = random.nextInt(1000);
             combineddate = "${widget.order.orderServicedate} ${widget.order.orderServicetime}";
          });
        } else {
          setState(() {});
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No Order Available.")));
        }
        setState(() {});
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Order Available.")));
      }
    });
  }

  void loadbarteruser() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
      "userid": widget.order.userId,
    }).then((response) {
      //log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }

  void loadseller() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
      "userid": widget.order.sellerId,
    }).then((response) {
      //log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user2 = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }

  void submitStatus() {
    http.post(Uri.parse("${Config.server}/lsm/php/set_ordersellerstatus.php"),
        body: {
          "orderid": widget.order.orderId,
          "sellerstatus": sellerstatus,
        }).then((response) {
      //log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
        } else {}
        //selectStatus = st;
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Success")));
      }
    });
  }

  void cancelService(String reason) {
    http.post(Uri.parse("${Config.server}/lsm/php/cancel_order.php"), body: {
      "orderid": widget.order.orderId,
      "userid": widget.order.userId,
      "sellerid": widget.order.sellerId,
      "reason": reason,
      "orderstatus": "Cancelled",
      "tokenStr": token.toString(),
    }).then((response) {
      //log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
        } else {}
        //selectStatus = st;
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cancel Success")));
      }
    });
  }
}
