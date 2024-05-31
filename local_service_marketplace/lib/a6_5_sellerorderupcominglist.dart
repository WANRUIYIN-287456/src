import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_service_marketplace/a6_6_sellerorderupcomingdetails.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';

class SellerOrderUpcomingList extends StatefulWidget {
  final User user;
  const SellerOrderUpcomingList({super.key, required this.user});

  @override
  State<SellerOrderUpcomingList> createState() =>
      _SellerOrderUpcomingListState();
}

class _SellerOrderUpcomingListState extends State<SellerOrderUpcomingList> {
  late double screenHeight, screenWidth, cardwitdh;

  String status = "Loading...";
  List<Order> orderList = <Order>[];
  late bool isPaid = false;
  Random random = Random();
  var val = 50;
  
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
                              flex: 5,
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    width: screenWidth * 0.3,
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            "${Config.server}/lsm/assets/images/profile/${widget.user.id}.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.network(
                                              "${Config.server}/lsm/assets/images/profile/0.png",
                                              scale: 2,
                                            )),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Hello, ${widget.user.name}!",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.background,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                      child: Text("Your Upcoming Order",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            Order order =
                                Order.fromJson(orderList[index].toJson());
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SellerOrderUpcomingDetails(order: order),
                              ),
                            );
                            loaduserorders();
                          },
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CachedNetworkImage(
                                          width: screenWidth * 0.18,
                                          height: screenHeight * 0.08,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "${Config.server}/lsm/assets/images/${orderList[index].serviceId}.png?v=$val",
                                          placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      children: [
                                        const SizedBox(height: 15),
                                        Text("${orderList[index].serviceName}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text(
                                            "Order Status: ${orderList[index].orderStatus}"),
                                        Text(
                                            "Payment Status: ${orderList[index].paymentStatus}"),
                                        Text(""),
                                      ],
                                    )
                                  ],
                                ),
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

  void loaduserorders() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_userorderlist.php"),
        body: {
          "sellerid": widget.user.id,
          "orderstatus": "Upcoming",
        }).then((response) {
      print(response.statusCode);
      //log(response.body);
      orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          orderList.clear();
          var extractdata = jsondata['data'];
          extractdata['order'].forEach((v) {
            Order order = Order.fromJson(v);
            orderList.add(order);
            setState(() {
              isPaid = order.paymentStatus == "Paid";
              val = random.nextInt(1000);
            });
          });
        } else {
          status = "Please register an account first";
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No Order Available.")));
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Order Available.")));
      }
    });
  }
}
