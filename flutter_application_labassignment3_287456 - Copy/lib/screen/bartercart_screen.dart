import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_labassignment3_287456/config.dart';
import 'package:flutter_application_labassignment3_287456/model/cart.dart';
import 'package:flutter_application_labassignment3_287456/model/user.dart';
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
              ? Container()
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
                                              onPressed: () {},
                                              icon: const Icon(Icons.remove)),
                                          Text(cartList[index]
                                              .productQty
                                              .toString()),
                                          IconButton(
                                            onPressed: () {},
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
                                  onPressed: () {}, icon: Icon(Icons.delete))
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
                    ElevatedButton(onPressed: () {}, child: const Text("Check Out"))
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
}