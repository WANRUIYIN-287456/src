import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/bartercart_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/barterorder_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/product/productdetails_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';

class BarterTabScreen extends StatefulWidget {
  final User user;
  const BarterTabScreen({super.key, required this.user});

  @override
  State<BarterTabScreen> createState() => _BarterTabScreenState();
}

class _BarterTabScreenState extends State<BarterTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Barter";
  List<Product> productList = <Product>[];
  late User user;
  final TextEditingController searchEditingController = TextEditingController();
  final TextEditingController valueaEditingController = TextEditingController();
  final TextEditingController valuebEditingController = TextEditingController();
  String selectedType = "All Types";
  String state = "All States";
  List<String> prlist = [
    "All Types",
    "Clothes",
    "Digital Products",
    "Fashion Accessories",
    "Games & Books",
    "Health & Beauty",
    "Home & Living",
    "Mobile, Laptop & Accessories",
    "Sports & Outdoor",
    "Others",
  ];
  List<String> statelist = [
    "All States",
    "Johor",
    "Kedah",
    "Kelantan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Perak",
    "Perlis",
    "Pulau Pinang",
    "Sabah",
    "Sarawak",
    "Selangor",
    "Terengganu",
  ];
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  int cartqty = 0;

  @override
  void initState() {
    super.initState();
    loadpageProduct(1);
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
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          TextButton.icon(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white60,
            ), // Your icon here
            label: Text(cartqty.toString(),
                style:
                    const TextStyle(color: Colors.white60)), // Your text here
            onPressed: () async {
              if (cartqty > 0) {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => BarterCartScreen(
                              user: widget.user,
                            )));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No item in cart")));
              }
            },
          ),
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Order"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("New"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              if (widget.user.id.toString() == "na") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => BarterOrderScreen(
                            user: widget.user,
                          )));
            } else if (value == 1) {
            } else if (value == 2) {}
          }),
        ],
      ),
      body: productList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: TextField(
                      controller: searchEditingController,
                      decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  String search = searchEditingController.text;
                                  searchProduct(search, 1);
                                },
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      filterDialog();
                    }, //show dialog for category, location or price
                    child: const Icon(Icons
                        .filter_list), //need to replace with the icon filter funnel
                  ),
                )
              ]),
              Container(
                height: 24,
                color: Colors.lightBlue,
                alignment: Alignment.center,
                child: Text(
                  "${numberofresult.toString()} Product(s) Found",
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
                              onTap: () async {
                                Product product = Product.fromJson(
                                    productList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            ProductDetailScreen(
                                                user: widget.user,
                                                product: product)));
                                loadProduct(1);
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
                      ))),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //build the list for textbutton with scroll
                    if ((curpage - 1) == index) {
                      //set current page number active
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadProduct(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
            ]),
    );
  }

  void loadpageProduct(int pg) {
    curpage = pg;
    numofpage;

    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_pageproduct.php"),
        body: {
          "pageno": pg.toString(),
          if (widget.user.id != "na") "userid": widget.user.id
        }).then((response) {
      print(response.body);
      try {
        productList.clear();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            print(numberofresult);
            var extractdata = jsondata['data'];

            extractdata['product'].forEach((v) {
              productList.add(Product.fromJson(v));
            });
            try {
              cartqty = int.parse(jsondata['cartqty'].toString());
            } catch (e) {
              print('Error parsing cartqty: $e');
            }
            print(cartqty);
            print(productList[0].productName);
          }
          setState(() {});
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  void loadProduct(int pg) {
    curpage = pg;
    numofpage;
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/load_barterproduct.php"),
        body: {
          "pageno": pg.toString(),
          if (widget.user.id != "na") "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      try {
        productList.clear();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            print(numberofresult);
            var extractdata = jsondata['data'];

            extractdata['product'].forEach((v) {
              productList.add(Product.fromJson(v));
            });
            try {
              cartqty = int.parse(jsondata['cartqty']);
            } catch (e) {
              print('Error parsing cartqty: $e');
            }
            print(cartqty);
            print(productList[0].productName);
          }
          setState(() {});
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  void filterProduct(String valuea, String valueb, int pg) {
    curpage = pg;
    numofpage;
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/load_barterproduct.php"),
        body: {
          "pageno": pg.toString(),
          "type": selectedType,
          "state": state,
          "valuea": valueaEditingController.text,
          "valueb": valuebEditingController.text,
          if (widget.user.id != "na") "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      productList.clear();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata['status']);
        if (jsondata['status'] == "success") {
          //  numofpage = int.parse(jsondata['numofpage']); //get number of pages
          //   numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
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

  void searchProduct(String search, int pg) {
    curpage = pg;
    numofpage;
    http.post(
        Uri.parse("${Config.server}/LabAssign2/php/load_barterproduct.php"),
        body: {
          "pageno": pg.toString(),
          "search": search,
          if (widget.user.id != "na") "userid": widget.user.id,
        }).then((response) {
      //print(response.body);
      productList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          //  numofpage = int.parse(jsondata['numofpage']); //get number of pages
          //   numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
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

  void filterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Filter",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 3,
                  child: Row(children: [
                    const SizedBox(
                      height: 30,
                      child: Text(
                        "Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 26,
                    ),
                    Container(
                      height: 60,
                      width: 150,
                      child: DropdownButton(
                        isExpanded: true,
                        value: selectedType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedType = newValue!;
                            print(selectedType);
                          });
                        },
                        items: prlist.map((selectedType) {
                          return DropdownMenuItem(
                            value: selectedType,
                            child: Text(
                              selectedType,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ]),
                ),
                Flexible(
                  flex: 3,
                  child: Row(children: [
                    const SizedBox(
                      height: 30,
                      child: Text(
                        "State",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 26,
                    ),
                    Container(
                      height: 60,
                      width: 150,
                      child: DropdownButton(
                        isExpanded: true,
                        value: state,
                        onChanged: (newValue2) {
                          setState(() {
                            state = newValue2!;
                            print(state);
                          });
                        },
                        items: statelist.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(
                              state,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ]),
                ),
                Row(
                  children: [
                    const SizedBox(
                        height: 26,
                        child: Text(
                          "Value",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      width: 22,
                    ),
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: valueaEditingController,
                        decoration: InputDecoration(
                            hintText: "Min",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Text("  -  "),
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: valuebEditingController,
                        decoration: InputDecoration(
                            hintText: "Max",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Filter",
                style: TextStyle(),
              ),
              onPressed: () {
                String valuea = valueaEditingController.text.toString();
                String valueb = valuebEditingController.text.toString();
                filterProduct(valuea, valueb, 1);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
