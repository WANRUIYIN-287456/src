import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a5_3_orderpaymentscreen.dart';
import 'package:local_service_marketplace/a5_6_userorderlistscreen.dart';
import 'package:local_service_marketplace/a8_9_userchatscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';

class UserOrderDetailsScreen extends StatefulWidget {
  final Order order;
  const UserOrderDetailsScreen({super.key, required this.order});

  @override
  State<UserOrderDetailsScreen> createState() => _UserOrderDetailsScreenState();
}

class _UserOrderDetailsScreenState extends State<UserOrderDetailsScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth;
  late Order order;
  String submitstatus = "New";
  String sellerstatus = "New";
  String orderstatus = "Upcoming";
  bool isCompletedEnabled = false;
  bool isCancelledEnabled = false;
  String paymentstatus = "Pending";
  late DateTime servicedate;
  String? reason;
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
    loaduser();
    loadownuser();
    loaduserorders();
    paymentstatus = widget.order.paymentStatus.toString();
    submitstatus = widget.order.orderUserstatus.toString();
    sellerstatus = widget.order.orderSellerstatus.toString();
    if (widget.order.orderServicedate != null) {
      // Parse the date string only if it's not null
      servicedate = DateTime.parse(widget.order.orderServicedate.toString());
    }
    if (widget.order.orderSellerstatus.toString() == "Arrived") {
      isCompletedEnabled = true;
    }
    if (sellerstatus == "New" || sellerstatus == "Confirmed") {
      //&& servicedate.difference(DateTime.now()).inDays >= 2)
      isCancelledEnabled = true;
    }
    if (sellerstatus == "Arrived" &&
        DateTime.now().difference(servicedate).inDays >= 5) {
      submitstatus = "Completed";
      orderstatus = "Completed";
      submitStatus();
      isCompletedEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Order Details"),
                leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
               Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserOrderScreen(
                                  user: user2,
                                ),
                              ),
                            );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.location_on_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserChatScreen(user: user, order: widget.order)),
                  );
                },
                icon: const Icon(Icons.message))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              //flex: 3,
              height: screenHeight / 6.3,
              width: screenWidth,
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
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // If button is enabled, return the background color for enabled state
                            return Colors
                                .white; // You can change this to the desired color
                          },
                        ),
                        // Define border color
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                            return const BorderSide(
                              color: Colors
                                  .grey, // You can change this to the desired color
                            );
                          },
                        ),
                      ),
                      onPressed: isCancelledEnabled == false ||
                              submitstatus == "Cancelled"
                          ? null
                          : () {
                              setState(() {
                                submitstatus = "Cancelled";
                                cancelDialog();
                                isCancelledEnabled = false;
                              });
                            },
                      child: const Text(
                        "Cancel Order",
                        style: TextStyle(
                          color: Colors
                              .grey, // You can change this to the desired color
                        ),
                      ),
                    )),
                    const TableCell(child: Text("")),
                    TableCell(
                        child: ElevatedButton(
                            onPressed: isCompletedEnabled == false ||
                                    submitstatus == "Completed"
                                ? null
                                : () {
                                    setState(() {
                                      submitstatus = "Completed";
                                      orderstatus = "Completed";
                                      submitStatus();
                                      isCompletedEnabled = false;
                                    });
                                  },
                            child: const Text("Order Completed"))),
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
                        width: screenWidth * 0.38,
                        fit: BoxFit.contain,
                        imageUrl:
                            "${Config.server}/lsm/assets/images/${widget.order.serviceId}.png",
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
              padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 20),
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
                        "\nService Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\n${widget.order.orderSellerstatus}",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nPayment Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: paymentstatus == "Paid"
                          ?  Text("\n"+widget.order.paymentStatus.toString())
                          :Row(children: [
                       Text(widget.order.paymentStatus.toString() + "   "),
                        Expanded(
                         child: ElevatedButton(
                           onPressed: () {
                             Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(
                                 builder: (content) => PaymentScreen(
                                   user: user2,
                                   order: widget.order,
                                 ),
                               ),
                             );
                             loaduserorders();
                             setState(() {
                               paymentstatus = widget.order.paymentStatus.toString();
                             });
                           },
                           child: const Text("Pay now"),
                         ),
                       ),
                          ],),
                    ),
                  ]),
                ],
              ),
            )
          ]),
        ));
  }

  void loaduserorders() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
      "userid": widget.order.userId,
      "orderid": widget.order.orderId,
    }).then((response) {
      print(response.statusCode);
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          order = Order.fromJson(jsondata['data']);
          setState(() {
            paymentstatus = widget.order.paymentStatus.toString();
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

  void loaduser() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
      "userid": widget.order.sellerId,
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

  void loadownuser() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
      "userid": widget.order.userId,
    }).then((response) {
      log(response.body);
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
    http.post(Uri.parse("${Config.server}/lsm/php/set_orderuserstatus.php"),
        body: {
          "orderid": widget.order.orderId,
          "submitstatus": submitstatus,
          "orderstatus": orderstatus
        }).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          loaduserorders();
        } else {}
        //selectStatus = st;
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Success")));
      }
    });
  }

  void cancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Reason for order cancellation",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ListTile(
                      title: const Text('Booking Error'),
                      leading: Radio(
                        value: 'Booking Error',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Service Not Delivered'),
                      leading: Radio(
                        value: 'Service Not Delivered',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                          'Service Delivered Does Not Meet Requirements'),
                      leading: Radio(
                        value: 'Service Delivered Does Not Meet Requirements',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Service Item Out of Stock'),
                      leading: Radio(
                        value: 'Service Item Out of Stock',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Service Quality Not Satisfied'),
                      leading: Radio(
                        value: 'Service Quality Not Satisfied',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(labelText: 'Others'),
                        onChanged: (value) {
                          setState(() {
                            reason = value;
                          });
                        },
                      ),
                      leading: Radio(
                        value: 'Other',
                        groupValue: reason,
                        onChanged: (value) {
                          setState(() {
                            reason = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancel Order",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.pop(context);
                cancelService(
                    reason); // Passing the reason to the cancelService function                
              },
            ),
          ],
        );
      },
    );
  }

  void cancelService(String? reason) {
    http.post(Uri.parse("${Config.server}/lsm/php/cancel_userorder.php"),
        body: {
          "orderid": widget.order.orderId,
          "userid": widget.order.userId,
          "sellerid": widget.order.sellerId,
          "reason": reason,
          "orderstatus": "Cancelled"
        }).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          loaduserorders();
            Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserOrderScreen(user: user2)
                        ),
                        (route) => false, // Remove all routes
                      );
          ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cancel Success")));
            
        } else {}
// ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Cancel Failed")));
        
      }
    });
  }
}
