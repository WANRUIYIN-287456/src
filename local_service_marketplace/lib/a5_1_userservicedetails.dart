import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a3_login.dart';
import 'package:local_service_marketplace/a5_2_userinsertorderscreen.dart';
import 'package:local_service_marketplace/a5_8_sellerprofilescreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service service;
  final User user;
  const ServiceDetailScreen(
      {super.key, required this.user, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  int index = 0;
  late double screenHeight, screenWidth, cardwitdh;
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;
  final TextEditingController qtyEditingController = TextEditingController();
  late bool isLike = false;
  late String likeString = "";
  late Icon love = Icon(Icons.favorite_border_rounded);

  @override
  void initState() {
    super.initState();
    loadLike();
    totalprice = double.parse(widget.service.servicePrice.toString());
    singleprice = double.parse(widget.service.servicePrice.toString());
    if (likeString == "true") {
      isLike = true;
    }
    print(isLike.toString());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Service Details"), actions: [
        Row(
          children: [
            Column(
              children: [
                isLike
                    ? IconButton(
                        onPressed: () {
                          unlikeDialog();
                        },
                        icon: love,
                      )
                    : IconButton(
                        onPressed: () {
                          likeDialog();
                        },
                        icon: love,
                      ),
              ],
            ),
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
                        builder: (content) => SellerProfileScreen(
                              user: widget.user,
                              sellerId: widget.service.sellerId.toString(),
                            )));
              }
            }),
          ],
        )
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                          width: screenWidth * 0.92,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )),
                    
                  ),
                  ]
                ),
              ),
            )),
        Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              widget.service.serviceName.toString(),
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
                      widget.service.serviceDesc.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Service Category",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.service.serviceCategory.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Service Type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.service.serviceType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Price per unit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.service.servicePrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Unit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.service.serviceUnit.toString(),
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
                      "${widget.service.serviceLocality}, ${widget.service.serviceState}",
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
              padding: const EdgeInsets.fromLTRB(8, 80, 8, 0),
              child: Column(
                children: [
                  //Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       const Text(
                  //         "Quantity",
                  //         style: TextStyle(
                  //             fontSize: 16, fontWeight: FontWeight.bold),
                  //       ),
                  //       TextFormField(
                  //         textInputAction: TextInputAction.next,
                  //         validator: (val) => val!.isEmpty
                  //             ? "Quantity ordered must contain number"
                  //             : null,
                  //         onFieldSubmitted: (v) {
                  //           setState(() {
                  //             totalprice = singleprice * userqty;
                  //           });
                  //         },
                  //         controller: qtyEditingController,
                  //         keyboardType: TextInputType.number,
                  //         decoration: const InputDecoration(
                  //           labelText: 'Quantity ordered',
                  //           border: OutlineInputBorder(),
                  //         ),
                  //       ),
                  //     ]),
                  // Text(
                  //   "RM ${totalprice.toStringAsFixed(2)}",
                  //   style: const TextStyle(
                  //       fontSize: 24, fontWeight: FontWeight.bold),
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        submitOrderDialog();
                      },
                      child: const Text("Order Now"))
                ],
              )),
        ),
      ]),
    );
  }

  void submitOrderDialog() {
    if (widget.user.id.toString() == widget.service.sellerId.toString()) {
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => ServiceOrderScreen(user: widget.user, service: widget.service)));
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       shape: const RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //       title: const Text(
    //         "Confirm Order",
    //         style: TextStyle(),
    //       ),
    //       content: const Text("Are you sure?", style: TextStyle()),
    //       actions: <Widget>[
    //         TextButton(
    //           child: const Text(
    //             "Yes",
    //             style: TextStyle(),
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (content) =>
    //                         ServiceOrderScreen(user: widget.user)));
    //             //submitOrder();
    //           },
    //         ),
    //         TextButton(
    //           child: const Text(
    //             "No",
    //             style: TextStyle(),
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void likeDialog() {
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
            "Add to favourites",
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
                submitLike();
                setState(() {
                  love = Icon(Icons.favorite_rounded);
                });
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

  void unlikeDialog() {
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
            "Remove from favourites",
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
                deleteLike();
                setState(() {
                  love = Icon(Icons.favorite_border_rounded);
                });
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

  void submitLike() {
    http.post(Uri.parse("${Config.server}/lsm/php/insert_likes.php"), body: {
      "userid": widget.user.id.toString(),
      "serviceid": widget.service.serviceId.toString(),
      "like": "true",
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Like Success")));
          setState(() {
            love = Icon(Icons.favorite_rounded);
            isLike = true;
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Like Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }

  void deleteLike() {
    http.post(Uri.parse("${Config.server}/lsm/php/delete_likes.php"), body: {
      "userid": widget.user.id.toString(),
      "serviceid": widget.service.serviceId.toString(),
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Unlike Success")));
          setState(() {
            love = Icon(Icons.favorite_border_rounded);
            isLike = false;
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Unlike Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }

void loadLike() {
  http.post(Uri.parse("${Config.server}/lsm/php/load_like.php"), body: {
    "userid": widget.user.id.toString(),
    "serviceid": widget.service.serviceId.toString(),
  }).then((response) {
    print(response.body);
    try {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        //print(jsondata['data']);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          setState(() {
            // Access the value of 'like_status' from extractdata
            likeString = extractdata['like_status'].toString();
            // Convert likeString to boolean
            isLike = likeString == "true";
            love = Icon(Icons.favorite_rounded);
          });
          print("loadLike " + isLike.toString());
        } else {
          print(1);
        }
      } else {
        print(2);
      }
    } catch (e, _) {
      debugPrint(e.toString());
    }
  });
}


}
