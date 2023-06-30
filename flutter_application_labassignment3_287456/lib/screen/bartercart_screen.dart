import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/cart.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/bill_screen.dart';
import 'package:http/http.dart' as http;

class BarterCartScreen extends StatefulWidget {
  final User user;

  const BarterCartScreen({super.key, required this.user});

  @override
  State<BarterCartScreen> createState() => _BarterCartScreenState();
}

class _BarterCartScreenState extends State<BarterCartScreen> {
  List<Cart> cartList = <Cart>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  double totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    loadcart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          cartList.isEmpty
              ? Container(child: const Text("no data"))
              : Expanded(
                  child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth / 3,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config.server}/LabAssign2/assets/images/${cartList[index].productId}.1.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        cartList[index].productName.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (int.parse(cartList[index]
                                                        .cartQty
                                                        .toString()) <=
                                                    1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Quantity less than 1")));
                                                } else {
                                                  int newqty = int.parse(
                                                          cartList[index]
                                                              .cartQty
                                                              .toString()) -
                                                      1;
                                                  double newprice =
                                                      double.parse(
                                                              cartList[index]
                                                                  .productPrice
                                                                  .toString()) *
                                                          newqty;
                                                  updateCart(
                                                      index, newqty, newprice);
                                                }
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.remove)),
                                          Text(cartList[index]
                                              .cartQty
                                              .toString()),
                                          IconButton(
                                            onPressed: () {
                                              if (int.parse(cartList[index]
                                                      .productQty
                                                      .toString()) <
                                                  int.parse(cartList[index]
                                                      .cartQty
                                                      .toString())) {
                                                print("items enough");
                                                int newqty = int.parse(
                                                        cartList[index]
                                                            .cartQty
                                                            .toString()) +
                                                    1;
                                                1;
                                                double newprice = double.parse(
                                                        cartList[index]
                                                            .productPrice
                                                            .toString()) *
                                                    newqty;
                                                updateCart(
                                                    index, newqty, newprice);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Maximum quantity exceeded")));
                                              }
                                            },
                                            icon: const Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                      Text(
                                          "RM ${double.parse(cartList[index].cartPrice.toString()).toStringAsFixed(2)}")
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    deleteCart(index);
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                        ));
                      })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Price:  RM ${totalprice.toStringAsFixed(2)}"),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BillScreen(
                                      user: widget.user,
                                      totalprice: totalprice)));
                        },
                        child: const Text("Check Out"))
                  ],
                )),
          )
        ],
      ),
    );
  }

  void loadcart() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_cart.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      // log(response.body);
      cartList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['cart'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            // totalprice = totalprice +
            //     double.parse(extractdata["carts"]["cart_price"].toString());
          });

          cartList.forEach((element) {
            totalprice =
                totalprice + double.parse(element.cartPrice.toString());
          });
          //print(catchList[0].catchName);
        }
        setState(() {});
      }
    });
  }

  void deleteCart(int index) {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/delete_cart.php"),
        body: {
          "userid": widget.user.id,
          "cartid": cartList[index].cartId
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      }
    });
  }

  void updateCart(int index, int newqty, double newprice) {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/update_cart.php"),
        body: {
          "cartid": cartList[index].cartId,
          "nameqty": newqty.toString(),
          "newprice": newprice.toString()
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          loadcart();
        } else {}
        setState(() {});
      }
    });
  }
}
