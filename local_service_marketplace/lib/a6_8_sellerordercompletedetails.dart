import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a5_8_sellerprofilescreen.dart';
import 'package:local_service_marketplace/a8_9_messagescreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';
// import 'package:local_service_marketplace/model/service.dart';

class SellerOrderCompleteDetails extends StatefulWidget {
  final Order order;
  const SellerOrderCompleteDetails({super.key, required this.order});

  @override
  State<SellerOrderCompleteDetails> createState() => _SellerOrderCompleteDetailsState();
}

class _SellerOrderCompleteDetailsState extends State<SellerOrderCompleteDetails> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth;
  late Order order;
  bool isRatingEnabled = true;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");
  // late Service service = Service(
  //   serviceId: "na",
  //   sellerId: "na",
  //   serviceName: "na",
  //   serviceCategory: "na",
  //   serviceType: "na",
  //   serviceDesc: "na",
  //   servicePrice: "na",
  //   serviceUnit: "na",
  //   serviceLong: "na",
  //   serviceLat: "na",
  //   serviceState: "na",
  //   serviceLocality: "na",
  //   serviceDate: "na",
  // );

  @override
  void initState() {
    super.initState();
    loadbarteruser();
    loaduserorders();
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
                        builder: (context) => const MessageScreen()),
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
          ),
          SizedBox(
            // color: Colors.red,
            width: screenWidth * 0.8,
            height: screenHeight * 0.1,
            child: Card(
                child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            SellerProfileScreen(user: user,  sellerId: widget.order.sellerId.toString())));
              },
              child: const Text("See Reviews"),
            )),
          ),
        ]));
  }

  void loaduserorders() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
      "sellerid": widget.order.sellerId,
      "orderid": widget.order.orderId,
    }).then((response) {
      print(response.statusCode);
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          order = Order.fromJson(jsondata['data']);
          setState(() {});
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

  // void loadservice() {
  //   http.post(Uri.parse("${Config.server}/lsm/php/load_product.php"), body: {
  //     "serviceid": widget.order.serviceId,
  //   }).then((response) {
  //     log(response.body);
  //     if (response.statusCode == 200) {
  //       var jsondata = jsonDecode(response.body);
  //       if (jsondata['status'] == 'success') {
  //         service = Service.fromJson(jsondata['data']);
  //       }
  //     }
  //     setState(() {});
  //   });

  // }

  
}