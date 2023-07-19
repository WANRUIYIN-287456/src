import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/order.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/message_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BarterOrderPayScreen extends StatefulWidget {
  final Order order;
  const BarterOrderPayScreen({super.key, required this.order});

  @override
  State<BarterOrderPayScreen> createState() => _BarterOrderPayScreenState();
}

// ignore: duplicate_ignore
class _BarterOrderPayScreenState extends State<BarterOrderPayScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth;
  late Order order;
  String submitstatus = "Submit";
  bool isButtonEnabled = false;
  String paymentstatus = "Processing";
  List<String> paymentstatuslist = [
    "Processing",
    "Ready",
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
    loaduserorders();
    paymentstatus = widget.order.paymentOrderStatus.toString();
     if( paymentstatus == "Ready"){
      isButtonEnabled = true;
    }
    submitstatus = widget.order.buyerStatus.toString();
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
                  margin: const EdgeInsets.all(10),
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
                        onPressed: isButtonEnabled == false ||
                              submitstatus == "Completed"
                          ? null
                          : () {
                              setState(() {
                                submitstatus = "Completed";
                                submitStatus();
                                isButtonEnabled = false;
                              });
                            },
                        child: Text(submitstatus))
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
                      width: screenWidth * 0.40,
                      fit: BoxFit.contain,
                      imageUrl:
                          "${Config.server}/LabAssign2/assets/images/${widget.order.productId}.1.png",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          "${widget.order.productName}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
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
                      widget.order.orderQty.toString(),
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
                      "\nOrder Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "\nRM ${widget.order.paymentAmount}",
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
                    child: DropdownButton(
                      isExpanded: true,
                      value: paymentstatus,
                      onChanged: null,
                      //  (newValue) {
                      //   setState(() {
                      //     paymentstatus = newValue!;
                      //     print(paymentstatus);
                      //   });
                      // },
                      items: paymentstatuslist.map((paymentstatus) {
                        return DropdownMenuItem(
                          value: paymentstatus,
                          child: Text(
                            paymentstatus,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ]),
              ],
            ),
          )
        ]));
  }

  void loaduserorders() {
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/load_barterorderbarter.php"),
        body: {
          "barteruserid": widget.order.barteruserId,
          "pay": "pay"
        }).then((response) {
      print(response.statusCode);
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          order = Order.fromJson(jsondata['data']);
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

  void submitStatus() {
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/set_orderstatus.php"),
        body: {
          "orderid": widget.order.orderId,
          "submitstatus": submitstatus
        }).then((response) {
      log(response.body);
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
}
