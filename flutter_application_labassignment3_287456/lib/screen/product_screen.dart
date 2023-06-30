import 'dart:convert';
//import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/editproduct_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/insertproduct_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProductTabScreen extends StatefulWidget {
  final User user;
  const ProductTabScreen({super.key, required this.user});

  @override
  State<ProductTabScreen> createState() => _ProductTabScreenState();
}

class _ProductTabScreenState extends State<ProductTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Product";
  List<Product> productList = <Product>[];

  @override
  void initState() {
    super.initState();
    loadProduct();
    print("Product");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
       appBar: AppBar(title: Text(maintitle)),
      body: productList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Colors.lightBlue,
                alignment: Alignment.center,
                child: Text(
                  "${productList.length} Product(s) Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        productList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Product newproduct = Product.fromJson(productList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => EditProductScreen(
                                              user: widget.user, product: newproduct,
                                            )));
                                            loadProduct();
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
                        },
                      )))
            ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewProductScreen(
                            user: widget.user,
                          )));
              loadProduct();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  void loadProduct() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_product.php"),
        body: {"userid": widget.user.id}).then((response) {
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
          print(productList[0].productName);
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${productList[index].productName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteProduct(index);
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

  void deleteProduct(int index) {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/delete_product.php"),
        body: {
          "userid": widget.user.id,
          "productid": productList[index].productId
        }).then((response) {
      print(response.body);
      //productList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadProduct();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}
