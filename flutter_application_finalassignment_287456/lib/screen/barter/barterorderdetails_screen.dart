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
        orderpayList.isEmpty
            ? Container()
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
                                  // Text(
                                  //   "Quantity: ${orderpayList[index].orderdetailQty}",
                                  //   style: const TextStyle(
                                  //       fontSize: 12,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
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
        SizedBox(
          // color: Colors.red,
          width: screenWidth,
          height: screenHeight * 0.1,
          child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Set order status as completed"),
                  // DropdownButton(
                  //   itemHeight: 60,
                  //   value: selectStatus,
                  //   onChanged: (newValue) {
                  //     setState(() {
                  //       selectStatus = newValue.toString();
                  //     });
                  //   },
                  //   items: statusList.map((selectStatus) {
                  //     return DropdownMenuItem(
                  //       value: selectStatus,
                  //       child: Text(
                  //         selectStatus,
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        submitStatus("Completed");
                      },
                      child: const Text("Submit"))
                ]),
          ),
        )
      ]),
    );
  }

  void loadorderpay() {
    http.post(
        Uri.parse(
            "${Config.server}/LabAssign2/php/load_barterorderpay.php"),
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
          var extractdata = jsondata['data'];
          extractdata['orderpay'].forEach((v) {
            orderpayList.add(OrderPay.fromJson(v));
          });
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

  void submitStatus(String st) {
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/set_orderstatus.php"),
        body: {"orderid": widget.order.orderId, "status": st}).then((response) {
      log(response.body);
      //orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
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

  // void loadMapDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text("Select your pickup location"),
  //             content: GoogleMap(
  //               mapType: MapType.normal,
  //               initialCameraPosition: _pickupPosition,
  //               markers: markers.toSet(),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text("Cancel"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   if (pickupLatLng == null) {
  //                     Fluttertoast.showToast(
  //                         msg: "Please select pickup location from map",
  //                         toastLength: Toast.LENGTH_SHORT,
  //                         gravity: ToastGravity.CENTER,
  //                         timeInSecForIosWeb: 1,
  //                         fontSize: 16.0);
  //                     return;
  //                   } else {
  //                     Navigator.pop(context);
  //                     picuploc = "Selected";
  //                   }
  //                 },
  //                 child: const Text("Select"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   ).then((val) {
  //     setState(() {});
  //   });
  // }
}