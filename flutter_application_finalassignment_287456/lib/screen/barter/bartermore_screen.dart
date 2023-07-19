import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/product/productdetails_screen.dart';
import 'package:http/http.dart' as http;

class BarterMoreScreen extends StatefulWidget {
  final String productuserID;
  final User user;
  const BarterMoreScreen(
      {super.key,required this.user, required this.productuserID});

  @override
  State<BarterMoreScreen> createState() => _BarterMoreScreenState();
}

class _BarterMoreScreenState extends State<BarterMoreScreen> {
  List<Product> productList = <Product>[];
  int numberofresult = 0;
  late double screenHeight, screenWidth, cardwitdh;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");

  @override
  void initState() {
    super.initState();
    loadUserItems();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("More from ")),
      body: Column(
        children: [
          SizedBox(
              height: screenHeight / 8,
              width: screenWidth,
              child: Card(
                  child: user.name == "na"
                      ? const Center(child: Text("Loading..."))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Store Owner\n${user.name}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),
          const Divider(),
          productList.isEmpty
              ? Container()
              : Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(productList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Product product =
                                  Product.fromJson(productList[index].toJson());
                              await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            ProductDetailScreen(
                                                user: widget.user,
                                                product: product)));
                            },
                            child: Column(children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config.server}/LabAssign2/assets/images/${productList[index].productId}.1.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                productList[index].productName.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                "RM ${double.parse(productList[index].productPrice.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${productList[index].productQty} available",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ]),
                          ),
                        );
                      })))
        ],
      ),
    );
  }

  void loadUserItems() {
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/load_product.php"),
        body: {
          "userid": widget.productuserID,
        }).then((response) {
      //print(response.body);
      //log(response.body);
      productList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['product'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void loadUser() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_user.php"),
        body: {
          "userid": widget.productuserID,
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