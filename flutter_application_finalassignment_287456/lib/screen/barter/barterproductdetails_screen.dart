import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BarterProductDetailsScreen extends StatefulWidget {
  final User user;
  final Product product;
  final String cartId;
  final String cartQty;
  final String cartPrice;
  final String productID;
  final String productuserID;
  const BarterProductDetailsScreen({super.key, required this.user, required this.product, required this.productID, required this.cartQty, required this.cartPrice, required this.cartId, required this.productuserID});

  @override
  State<BarterProductDetailsScreen> createState() => _BarterProductDetailsScreenState();
}

class _BarterProductDetailsScreenState extends State<BarterProductDetailsScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  int index = 0;
  late double screenHeight, screenWidth, cardwitdh;
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;
  late Product product;
  
  String barterstatus = "Waiting for response...";
List<String> barterstatuslist = [
    "Waiting for response...",
    "Accepted",
    "Rejected",

  ];
  @override
  void initState() {
    super.initState();
    qty = int.parse(widget.product.productQty.toString());
    totalprice = double.parse(widget.product.productPrice.toString());
    singleprice = double.parse(widget.product.productPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Barter Details")),
      body: Column(children: [
        Flexible(
            flex: 2,
            // height: screenHeight / 2.5,
            // width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: CachedNetworkImage(
                      width: screenWidth * 0.92,
                      fit: BoxFit.cover,
                      imageUrl:
                          "${Config.server}/LabAssign2/assets/images/${widget.product.productId}.1.png",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ),
            )),
        Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              widget.product.productName.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.product.productDesc.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Product Type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.product.productType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Quantity Available",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.product.productQty.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Product Value",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.product.productPrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.product.productLocality}, ${widget.product.productState}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      df.format(DateTime.parse(
                          widget.product.productDate.toString())),
                    ),
                  )
                ]),
                 TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Option",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.product.productOption.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "\nBarter Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: DropdownButton(
                            isExpanded: true,
                            value: barterstatus,
                             onChanged: null,
                            //  (newValue) {
                            //   setState(() {
                            //     barterstatus = newValue!;
                            //     print(barterstatus);
                            //   });
                            // },
                            items: barterstatuslist.map((barterstatus) {
                              return DropdownMenuItem(
                                value: barterstatus,
                                child: Text(
                                  barterstatus,
                                ),
                              );
                            }).toList(),
                          ),
                  )
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 140),
        SizedBox(
                    width: screenWidth / 1.2,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          barterdialog();
                        },
                        child: const Text("Barter it!")),
                  ),
                  const SizedBox(height: 40),
      ]),
    );
  }

  void barterdialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Barter",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                // Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (content) => BarterProductScreen(user: widget.user, productId: widget.product.productId.toString())));
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          barter();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//`cart_id`, `product_id`, `cart_qty`, `cart_price`, `user_id`, `buyer_id`, `cart_date`
  void barter() {
    String status = "Barter";
    
    http.post(Uri.parse("${Config.server}/LabAssign2/php/insert_orderbarter.php"),
        body: {
          "productid": widget.productID,
          "barterproductid": widget.product.productId.toString(),
          "barterproductname": widget.product.productName.toString(),
          "orderqty": widget.cartQty.toString(),
          "orderprice": widget.cartPrice.toString(),
          "barteruserid": widget.user.id,
          "userid": widget.productuserID,
          "orderstatus": status,
          "barterstatus": barterstatus,
          "cartid": widget.cartId,
          "owner" : "Submit",
          "buyer" : "Submit"
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }
}
