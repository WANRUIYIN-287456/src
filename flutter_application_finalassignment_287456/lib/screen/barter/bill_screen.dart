import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/order.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/billbarter_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/billpay_screen.dart';

class BillScreen extends StatefulWidget {
  final User user;
  const BillScreen({super.key, required this.user});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  List<Order> orderList = <Order>[];
  @override
  void initState() {
    super.initState();
    loaduserorders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Bill")),
        body: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Bill List",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            orderList.isEmpty
                ? const Text("no data")
                : Expanded(
                    child: ListView.builder(
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(children: [
                                    GestureDetector(
                                        onTap: () async {
                                          Order myorder = Order.fromJson(
                                              orderList[index].toJson());
                                          if (orderList[index].orderStatus ==
                                              "Paid") {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BillPayScreen(
                                                        order: myorder),
                                              ),
                                            );
                                          } else if (orderList[index]
                                                  .orderStatus ==
                                              "Barter") {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BillBarterScreen(
                                                        order: myorder),
                                              ),
                                            );
                                          }
                                          loaduserorders();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              100, 8, 80, 8),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Order Id:     ${orderList[index].orderId}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "Order Option: ${orderList[index].productOption}"),
                                            ],
                                          ),
                                        )),
                                  ])));
                        }))
          ],
        ));
  }

  void loaduserorders() {
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/load_barterorderbarter.php"),
        body: {"barteruserid": widget.user.id}).then((response) {
      print(response.statusCode);
      log(response.body);
      orderList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          orderList.clear();
          var extractdata = jsondata['data'];
          extractdata['order'].forEach((v) {
            orderList.add(Order.fromJson(v));
          });
        }
        setState(() {});
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Order Available.")));
      }
    });
  }
}
