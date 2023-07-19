import 'dart:convert';
import 'package:flutter_application_finalassignment_287456/screen/product/owner_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/shared/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final User user;
  const ProductDetailScreen(
      {super.key, required this.user, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  int index = 0;
  late double screenHeight, screenWidth, cardwitdh;
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;

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
      appBar: AppBar(title: const Text("Product Details"), actions: [
        PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text("Visit Seller Page"),
            ),
          ];
        }, onSelected: (value) async {
          if (value == 0) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => UserProfileScreen(
                          user: widget.user,
                          productUserId: widget.product.userId.toString(),
                        )));
          }
        }),
      ]),
      body: Column(children: [
        Flexible(
            flex: 2,
            // height: screenHeight / 2.5,
            // width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Card(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                          width: screenWidth * 0.92,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "${Config.server}/LabAssign2/assets/images/${widget.product.productId}.${index + 1}.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )),
                    );
                  }),
                ),
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
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (userqty <= 1) {
                                userqty = 1;

                                totalprice = singleprice * userqty;
                              } else {
                                userqty = userqty - 1;

                                totalprice = singleprice * userqty;
                              }

                              setState(() {});
                            },
                            icon: const Icon(Icons.remove)),
                        Text(
                          userqty.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              if (userqty >= qty) {
                                userqty = qty;

                                totalprice = singleprice * userqty;
                              } else {
                                userqty = userqty + 1;

                                totalprice = singleprice * userqty;
                              }

                              setState(() {});
                            },
                            icon: const Icon(Icons.add)),
                      ]),
                  Text(
                    "RM ${totalprice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addtocartdialog();
                      },
                      child: const Text("Add to Cart"))
                ],
              )),
        ),
      ]),
    );
  }

  void addtocartdialog() {
    if (widget.user.id.toString() == widget.product.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User cannot add own item")));
      return;
    }
    if (widget.user.id.toString() == "na") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please register/login to use this feature.")));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add to cart?",
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
                Navigator.of(context).pop();
                addtocart();
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
  void addtocart() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/insert_cart.php"),
        body: {
          "product_id": widget.product.productId.toString(),
          "cart_qty": userqty.toString(),
          "cart_price": totalprice.toString(),
          "barteruser_id": widget.user.id,
          "userid": widget.product.userId
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
