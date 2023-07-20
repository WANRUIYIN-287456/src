import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/order.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:intl/intl.dart';

class BillBarterScreen extends StatefulWidget {
  final Order order;
  const BillBarterScreen({super.key, required this.order});

  @override
  State<BillBarterScreen> createState() => _BillBarterScreenState();
}

class _BillBarterScreenState extends State<BillBarterScreen> {
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
            "Transaction Bill",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 30, 30, 30),
            child: Container(
                alignment: Alignment.topRight,
                child: Column(
                  // ignore: prefer_interpolation_to_compose_strings
                  children: [
                    Text(
                        "Bill No:                 ${10000 + int.parse(widget.order.orderId.toString())}"),
                    Text(
                        "Order Date: ${df.format(DateTime.parse(widget.order.orderDate.toString()))}"),
                  ],
                )),
          ),
          const SizedBox(height : 20),
          const SizedBox(
              child: Text(
            "Successful Barter",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          const SizedBox(height : 40),
          const Padding(
            padding: EdgeInsets.fromLTRB(60, 10, 200, 6),
            child: SizedBox(child: Text("Please contact: ")),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 10, 0, 20),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Owner H/P",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      user.phone.toString(),
                    ),
                  ),
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Owner Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      user.email.toString(),
                    ),
                  ),
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Owner Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.order.productLocality.toString(),
                    ),
                  ),
                ]),
              ],
            ),
          ),
         const SizedBox(height : 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 200, 10),
                child: Column(
                  children: [
                    const Text("Owner, ", style: TextStyle(fontSize: 18),),
                    const SizedBox(height : 10),
                    Text(user.name.toString(), style: const TextStyle(fontSize: 16)),
                    const Text("--------------------", style: TextStyle(fontSize: 18),),
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
