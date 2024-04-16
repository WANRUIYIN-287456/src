import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a3_login.dart';
import 'package:local_service_marketplace/a5_2_userinsertorderscreen.dart';
import 'package:local_service_marketplace/a5_8_sellerprofilescreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final Order order;
  const BillScreen({super.key, required this.user, required this.order});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth, cardwitdh;
  late Order order;
  late User user;

  @override
  void initState() {
    super.initState();
    loaduser();
    loaduserorders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: const Text(
              "\nReceipt",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
             Container(
            margin: EdgeInsets.fromLTRB(8, 0, 160, 0),
            child:  Text(
              "\nReceipt id: ${widget.order.receiptId}\n",
              style: const TextStyle(fontSize: 18),
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                const TableRow(children: [
                  TableCell(
                    child: Text(
                      "Item\n",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "Description\n",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text("Name\n"),
                  ),
                  TableCell(
                    child: Text(
                      widget.user.name.toString() +"\n",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text("Email\n"),
                  ),
                  TableCell(
                    child: Text(
                      widget.user.email.toString()+ "\n",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Phone\n",
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.user.phone.toString()+"\n",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Paid Amount\n",
                     
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.order.orderTotalprice.toString()).toStringAsFixed(2)}\n",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Paid Status",
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.order.paymentStatus.toString(),
                       style: const TextStyle(color: Colors.green),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
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

  void loaduser() {
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
}
