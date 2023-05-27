import 'dart:convert';
//import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_nelayan/model/catch.dart';
import 'package:my_nelayan/model/user.dart';
import 'package:my_nelayan/screens/config.dart';
import 'package:my_nelayan/screens/newcatch_screen.dart';
import 'package:http/http.dart' as http;

class SellerTabScreen extends StatefulWidget {
  final User user;
  const SellerTabScreen({super.key, required this.user});

  @override
  State<SellerTabScreen> createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Seller";
  List<Catch> catchList = <Catch>[];
  late int axiscount = 2;
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    super.dispose();
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
      
      body: catchList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Your Current Products",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: GestureDetector(
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(catchList.length, (index) {
                        return Card(
                          child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                            child: Column(
                          children: [
//cache image, will call and reload data which has been downloaded from server for previous call
//flutter pub add cached_network_image
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl: "${Config.server}/MyNelayan/images/products/${catchList[index].catchId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                  catchList[index].catchName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "RM ${double.parse(catchList[index].catchPrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${catchList[index].catchQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),    
                          ],
                        )));
                      }),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.user.id != "na") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewCatchScreen(
                            user: widget.user,
                          )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account.")));
            }
          },
          child: const Text("+", style: TextStyle(fontSize: 32))),
    );
  }

  _loadProducts() {
    if (widget.user.email == "na") {
      setState(() {
        titlecenter = "Unregistered User";
      });
      return;
    }
    http.post(Uri.parse("${Config.server}/mynelayan/php/load_catches.php"),
        body: {"userid": widget.user.id}).then((response) {
          catchList.clear();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          var extractdata = data['data'];
          if (extractdata['catches'] != null) {
            setState(() {
              catchList = <Catch>[];
              extractdata['catches'].forEach((v) {
                catchList.add(Catch.fromJson(v));
              });
            });
            print(catchList[0].catchName);
          }
        }
      } else {
        setState(() {
          titlecenter = "No Data";
        });
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
            "Delete ${catchList[index].catchName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteCatch(index);
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

  void deleteCatch(int index) {
    http.post(Uri.parse("${Config.server}/mynelayan/php/delete_catch.php"),
        body: {
          "userid": widget.user.id,
          "catchid": catchList[index].catchId
        }).then((response) {
      print(response.body);
      //catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          _loadProducts();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }


}
