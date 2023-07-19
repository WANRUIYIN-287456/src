import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/cart.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/payment_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SellCartScreen extends StatefulWidget {
  final User user;
  final Cart cart;
  const SellCartScreen({super.key, required this.user, required this.cart});

  @override
  State<SellCartScreen> createState() => _SellCartScreenState();
}

class _SellCartScreenState extends State<SellCartScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  int index = 0;
  late double screenHeight, screenWidth, cardwitdh;
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;
  late Product product;
  String paymentstatus = "Processing";
  List<String> paymentstatuslist = [
    "Processing",
    "Ready",
    "Completed",
  ];
  @override
  void initState() {
    super.initState();
    qty = int.parse(widget.cart.productQty.toString());
    // totalprice = double.parse(widget.cart.productPrice.toString());
    singleprice = double.parse(widget.cart.productPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Cart Details")),
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
                          "${Config.server}/LabAssign2/assets/images/${widget.cart.productId}.1.png",
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
              widget.cart.productName.toString(),
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
                      widget.cart.productDesc.toString(),
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
                      widget.cart.productType.toString(),
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
                      widget.cart.productQty.toString(),
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
                      "RM ${double.parse(widget.cart.productPrice.toString()).toStringAsFixed(2)}",
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
                      "${widget.cart.productLocality}, ${widget.cart.productState}",
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
                      df.format(
                          DateTime.parse(widget.cart.productDate.toString())),
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
                      widget.cart.productOption.toString(),
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
          ),
        ),
         const SizedBox(height: 100),
        SizedBox(
          width: screenWidth / 1.2,
          height: 50,
          child: ElevatedButton(
              onPressed: () {
                paydialog();
              },
              child: const Text("Pay for it!")),
        ),
        const SizedBox(height: 40)
      ]),
    );
  }

  void paydialog() {
    if (widget.user.id.toString() == widget.cart.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User cannot add own item")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Check out",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
               await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => PaymentScreen(user: widget.user, paymentAmount: widget.cart.cartPrice.toString(),)));
                        pay();
                 Navigator.of(context).pop();
                 Navigator.of(context).pop();
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
  void pay() {
    String status = "Paid";
    http.post(Uri.parse("${Config.server}/LabAssign2/php/insert_orderpay.php"),
        body: {
          "productid": widget.cart.productId.toString(),
          "productname": widget.cart.productName.toString(),
          "orderqty": widget.cart.cartQty.toString(),
          "orderprice": widget.cart.cartPrice.toString(),
          "barteruserid": widget.user.id,
          "userid": widget.cart.userId,
          "orderstatus": status,
          "paymentstatus": paymentstatus,
          "cartid" : widget.cart.cartId,
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
