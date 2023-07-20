import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/order.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:intl/intl.dart';

class BillPayScreen extends StatefulWidget {
  final Order order;
  const BillPayScreen({super.key, required this.order});

  @override
  State<BillPayScreen> createState() => _BillPayScreenState();
}

class _BillPayScreenState extends State<BillPayScreen> {
  final df = DateFormat('dd-MM-yyyy');
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");

  void initState() {
    super.initState();
    loadbarteruser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bill")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Payment Bill",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 70, 8),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // ignore: prefer_interpolation_to_compose_strings
                    children: [
                      Text(user.name.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                      Text(user.phone.toString()),
                    ], 
                  ),
                ),
              ),
               Padding(
                padding: const EdgeInsets.fromLTRB(45, 20, 20, 10),
                child: Container(
                    alignment: Alignment.topRight,
                    child: Column(
                      // ignore: prefer_interpolation_to_compose_strings
                      children: [
                        Text(
                            "Bill No:                 ${10000 + int.parse(widget.order.orderId.toString())}", style: TextStyle(fontSize: 12)),
                        Text(
                            "Order Date: ${df.format(DateTime.parse(widget.order.orderDate.toString()))}", style: TextStyle(fontSize: 12)),
                      ],
                    )),
              ),
            ],
          ),
         
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 20, 20),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(children: [
                  TableCell(
                    child: Text(
                      "Product Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "Qty",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "   Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text(
                      "\n${widget.order.productName}",
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "\n  ${widget.order.orderQty}",
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "\nRM ${widget.order.paymentAmount}",
                    ),
                  )
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(110, 60, 0, 8),
            child: Text(
              "Total Price:      RM ${widget.order.paymentAmount}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 200, 10),
            child: Column(
              children: [
                const Text(
                  "Seller, ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(user.name.toString(),
                    style: const TextStyle(fontSize: 16)),
                const Text(
                  "--------------------",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
