import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a5_3_orderpaymentscreen.dart';
import 'package:local_service_marketplace/a5_7_userorderdetailsscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/seller.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class ServiceOrderScreen extends StatefulWidget {
  final User user;
  final Service service;
  const ServiceOrderScreen(
      {super.key, required this.user, required this.service});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  final df = DateFormat('dd-MM-yyyy');
  final tf = DateFormat('hh:mm a');
  int index = 0;
  late double screenHeight, screenWidth, cardwitdh;
  double qty = 0;
  double totalprice = 0.0;
  late int orderid;
  late Service service;
  final _quantityFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final TextEditingController qtyEditingController = TextEditingController();
  final TextEditingController addressEditingController =
      TextEditingController();
  final TextEditingController messageEditingController =
      TextEditingController();
  late DateTime servicedate;
  late TimeOfDay servicetime;
  late Order order;
  List<Seller> sellerList = <Seller>[];

  @override
  void initState() {
    super.initState();
    loadaddress();
    servicedate = DateTime.now();
    servicetime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Order Service")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                          width: screenWidth * 0.6,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png",
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
                  widget.service.serviceName.toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
            Container(
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
                        "\nPrice per unit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\nRM ${double.parse(widget.service.servicePrice.toString()).toStringAsFixed(2)}",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nUnit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\n" + widget.service.serviceUnit.toString() + "\n",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nQuantity",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Form(
                        key: _quantityFormKey,
                        child: TextFormField(
                          controller: qtyEditingController,
                          onChanged: (val) {
                            setState(() {
                              qty = double.parse(qtyEditingController.text);
                              totalprice = double.parse(
                                      widget.service.servicePrice.toString()) *
                                  qty;
                            });
                          },
                          validator: (val) => val!.isEmpty
                              ? "Quantity must not be empty"
                              : null,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Quantity",
                            labelStyle: TextStyle(),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "\nService Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          children: [
                            Text(
                              df.format(servicedate),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              icon: const Icon(Icons.calendar_today),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "\nService Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          children: [
                            Text(
                              tf.format(DateTime(
                                servicedate.year,
                                servicedate.month,
                                servicedate.day,
                                servicetime.hour,
                                servicetime.minute,
                              )),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectTime(context);
                              },
                              icon: const Icon(Icons.access_time),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nAddress",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Form(
                        key: _addressFormKey,
                        child: TextFormField(
                          controller: addressEditingController,
                          validator: (val) => val!.isEmpty || val.length < 15
                              ? "Please enter valid address"
                              : null,
                          maxLines: 6,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Address",
                            labelStyle: TextStyle(),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                  const TableRow(children: [
                    TableCell(
                      child: Text(
                        "\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\n",
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\nSpecial Request",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Form(
                        child: TextFormField(
                          controller: messageEditingController,
                          maxLines: 4,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Special Request",
                            labelStyle: TextStyle(),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                  TableRow(children: [
                    const TableCell(
                      child: Text(
                        "\n\nTotal Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "\n\nRM ${double.parse(totalprice.toString()).toStringAsFixed(2)}",
                      ),
                    )
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: screenWidth / 1.2,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    Order? result = await orderService();
                    if (result != null) {
                      // Navigate to UserOrderDetailsScreen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserOrderDetailsScreen(order: result),
                        ),
                        (route) => false, // Remove all routes
                      );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         UserOrderDetailsScreen(order: result),
                      //   ),
                      // );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Order failed or canceled.")));
                    }
                  },
                  child: const Text("Order it!")),
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      // initialDate: DateTime.now().add(Duration(days: 3)),
      // firstDate: DateTime.now().add(Duration(days: 3)),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (pickedDate != null && pickedDate != servicedate) {
      setState(() {
        servicedate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        servicetime = pickedTime;
      });
    }
  }

  // Future<Order?> orderService() async {
  //   // Convert servicedate to the format expected by PHP (YYYY-MM-DD)
  //   String formattedDate =
  //       "${servicedate.year}-${servicedate.month}-${servicedate.day}";

  //   // Convert TimeOfDay to DateTime for database insertion
  //   final DateTime selectedDateTime = DateTime(
  //     servicedate.year,
  //     servicedate.month,
  //     servicedate.day,
  //     servicetime.hour,
  //     servicetime.minute,
  //   );

  //   http.Response response = await http
  //       .post(Uri.parse("${Config.server}/lsm/php/insert_order.php"), body: {
  //     "serviceid": widget.service.serviceId.toString(),
  //     "userid": widget.user.id.toString(),
  //     "sellerid": widget.service.sellerId.toString(),
  //     "servicename": widget.service.serviceName.toString(),
  //     "serviceprice": widget.service.servicePrice.toString(),
  //     "serviceunit": widget.service.serviceUnit.toString(),
  //     "servicequantity": qtyEditingController.text,
  //     "orderprice": totalprice.toString(),
  //     "date": formattedDate, // Use formattedDate here
  //     "time": tf.format(selectedDateTime), // Format time for database insertion
  //     "address": addressEditingController.text,
  //     "message": messageEditingController.text,
  //     "userstatus": "New",
  //     "sellerstatus": "New",
  //     "orderstatus": "Upcoming",
  //     "paymentstatus": "Pending",
  //     "receipt": "Pending",
  //   });

  //   if (response.statusCode == 200) {
  //     var jsonData = jsonDecode(response.body);
  //     print(jsonData); // Print the JSON response for debugging

  //     if (jsonData != null && jsonData['status'] == 'success') {
  //       // Extract the order ID from the response
  //       int orderId = jsonData['data']['orderid'];

  //       // Fetch complete order details using load_userorder.php
  //       Order? completeOrder = await fetchCompleteOrder(orderId);

  //       if (completeOrder != null) {
  //         sendNotificationToSeller(orderId, widget.service.sellerId.toString());
  //         return completeOrder;
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             content: Text("Failed to fetch complete order details")));
  //         return null;
  //       }
  //     } else {
  //       print("Order request failed or status is not 'success'");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Order request failed")));
  //       return null;
  //     }
  //   } else {
  //     print(
  //         "Failed to fetch data from server. Status code: ${response.statusCode}");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Failed to fetch data from server")));
  //     return null;
  //   }
  // }

  // Future<Order?> fetchCompleteOrder(int orderId) async {
  //   http.Response response = await http
  //       .post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
  //     "userid": widget.user.id.toString(),
  //     "orderid": orderId.toString(),
  //   });

  //   if (response.statusCode == 200) {
  //     var jsonData = jsonDecode(response.body);
  //     print(jsonData); // Print the JSON response for debugging

  //     if (jsonData != null && jsonData['status'] == 'success') {
  //       var orderData = jsonData['data']['order'];
  //       if (orderData != null && orderData.isNotEmpty) {
  //         var orderItem = orderData[0];
  //         // Create an Order object from the JSON data
  //         Order order = Order(
  //           orderId: orderItem['order_id'],
  //           serviceId: orderItem['service_id'],
  //           userId: orderItem['user_id'],
  //           sellerId: orderItem['seller_id'],
  //           serviceName: orderItem['service_name'],
  //           servicePrice: orderItem['service_price'],
  //           serviceUnit: orderItem['service_unit'],
  //           orderQuantity: orderItem['order_quantity'],
  //           orderTotalprice: orderItem['order_totalprice'],
  //           orderServicedate: orderItem['order_servicedate'],
  //           orderServicetime: orderItem['order_servicetime'],
  //           orderServiceaddress: orderItem['order_serviceaddress'],
  //           orderMessage: orderItem['order_message'],
  //           orderDate: orderItem['order_date'],
  //           orderUserstatus: orderItem['order_userstatus'],
  //           orderSellerstatus: orderItem['order_sellerstatus'],
  //           orderStatus: orderItem['order_status'],
  //           paymentStatus: orderItem['payment_status'],
  //           receiptId: orderItem['receipt_id'],
  //         );

  //         // Return the Order object
  //         return order;
  //       } else {
  //         print("No order data found in JSON response");
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text("Order data not found")));
  //         return null;
  //       }
  //     } else {
  //       print(
  //           "Failed to fetch complete order details. Status: ${jsonData['status']}");
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Failed to fetch complete order details")));
  //       return null;
  //     }
  //   } else {
  //     print(
  //         "Failed to fetch data from server. Status code: ${response.statusCode}");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Failed to fetch data from server")));
  //     return null;
  //   }
  // }

  void _orderdialog() {
    if (widget.user.id.toString() == widget.service.sellerId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User cannot add own item")));
      return;
    }
    if (_addressFormKey.currentState == null ||
        !_addressFormKey.currentState!.validate()) {
      // Check if _formKey.currentState is null before accessing validate()
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your address")));
      return;
    }

    if (_quantityFormKey.currentState == null ||
        !_quantityFormKey.currentState!.validate()) {
      // Check if _formKey.currentState is null before accessing validate()
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your address")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Order now",
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                orderService();
                // Check if order is initialized before navigating
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

  Future<Order?> orderService() async {
    // Convert servicedate to the format expected by PHP (YYYY-MM-DD)
    String formattedDate =
        "${servicedate.year}-${servicedate.month}-${servicedate.day}";

    // Convert TimeOfDay to String for database insertion
    String formattedTime = tf.format(
      DateTime(
        servicedate.year,
        servicedate.month,
        servicedate.day,
        servicetime.hour,
        servicetime.minute,
      ),
    );

    http.Response response = await http.post(
      Uri.parse("${Config.server}/lsm/php/insert_order.php"),
      body: {
        "serviceid": widget.service.serviceId.toString(),
        "userid": widget.user.id.toString(),
        "sellerid": widget.service.sellerId.toString(),
        "servicename": widget.service.serviceName.toString(),
        "serviceprice": widget.service.servicePrice.toString(),
        "serviceunit": widget.service.serviceUnit.toString(),
        "servicequantity": qtyEditingController.text,
        "orderprice": totalprice.toString(),
        "date": formattedDate,
        "time": formattedTime,
        "address": addressEditingController.text,
        "message": messageEditingController.text,
        "userstatus": "New",
        "sellerstatus": "New",
        "orderstatus": "Upcoming",
        "paymentstatus": "Pending",
        "receipt": "Pending",
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData); // Print the JSON response for debugging

      if (jsonData != null && jsonData['status'] == 'success') {
        // Extract the order ID from the response
        int orderId = jsonData['data']['orderid'];

        // Fetch complete order details using load_userorder.php
        Order? completeOrder = await fetchCompleteOrder(orderId);

        if (completeOrder != null) {
          sendNotificationToSeller(orderId, widget.service.sellerId.toString());
          sendemail();
          return completeOrder;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Failed to fetch complete order details")),
          );
          return null;
        }
      } else {
        print("Order request failed or status is not 'success'");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order request failed")),
        );
        return null;
      }
    } else {
      print(
        "Failed to fetch data from server. Status code: ${response.statusCode}",
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch data from server")),
      );
      return null;
    }
  }

  Future<Order?> fetchCompleteOrder(int orderId) async {
    http.Response response = await http.post(
      Uri.parse("${Config.server}/lsm/php/load_userorder.php"),
      body: {
        "userid": widget.user.id.toString(),
        "orderid": orderId.toString(),
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData); // Print the JSON response for debugging

      if (jsonData != null && jsonData['status'] == 'success') {
        var orderData = jsonData['data']['order'];
        if (orderData != null && orderData.isNotEmpty) {
          var orderItem = orderData[0];
          // Create an Order object from the JSON data
          Order order = Order.fromJson(orderItem);
          // Return the Order object
          return order;
        } else {
          print("No order data found in JSON response");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Order data not found")),
          );
          return null;
        }
      } else {
        print(
          "Failed to fetch complete order details. Status: ${jsonData['status']}",
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to fetch complete order details"),
          ),
        );
        return null;
      }
    } else {
      print(
        "Failed to fetch data from server. Status code: ${response.statusCode}",
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch data from server")),
      );
      return null;
    }
  }

  void loadaddress() {
    http.post(
      Uri.parse("${Config.server}/lsm/php/load_address.php"),
      body: {
        "userid": widget.user.id.toString(),
      },
    ).then((response) {
      print(response.statusCode);
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var orderData = jsondata['data']['order'];
          if (orderData != null && orderData.isNotEmpty) {
            var orderItem = orderData[0];
            setState(() {
              addressEditingController.text =
                  orderItem['order_serviceaddress'].toString();
            });
          } else {
            addressEditingController.text = "";
          }
        }
      }
    });
  }

//   ** Legacy method **
//   void sendNotificationToSeller(int orderId, String sellerId) async {
//     // Construct the FCM message payload
//     var message = {
//         'notification': {
//             'title': 'New Order',
//             'body': 'You have a new order. Check it at your upcoming order list.'
//         },
//         'data': {
//             // You can add additional data if needed
//             'orderId': orderId.toString(),
//         },
//         'to': 'seller_$sellerId', // FCM topic for the seller
//     };

//     // Send the FCM message using HTTP POST request
//     var response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'key=AAAAb8bcc_g:APA91bFiMsZrgZ1Oo_zVL83qWA0HhBN8f00oiJ2VJNgoamrjgUaAwrIypjmrDQ0MhLgCcTCLg3itJRptmPh4owUN4bMXdpMAPR_XPRdWSRq716RB8hynp-iLs_ggiNjnz6IBF-LSoF_1', // Replace with your server key
//         },
//         body: jsonEncode(message),
//     );

//     if (response.statusCode == 200) {
//         print('Notification sent to seller successfully');
//     } else {
//         print('Failed to send notification to seller. Status code: ${response.statusCode}');
//     }
// }

  Future<String> loadVerify(int index) async {
    try {
      final response = await http.post(
          Uri.parse("${Config.server}/lsm/php/load_verify.php"),
          body: {"sellerid": widget.service.sellerId.toString()});

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          for (var v in extractdata) {
            sellerList.add(Seller.fromJson(v));

            String fcmtoken = sellerList[index].fcmToken.toString();
            print("insert order : $fcmtoken");
            return fcmtoken;
          }
        }
      }
    } catch (e, _) {
      debugPrint(e.toString());
    }

    String? fcmtokennull = await FirebaseMessaging.instance.getToken();
    print("null : $fcmtokennull");
    return fcmtokennull.toString();
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "local-service-marketplac-42398",
      "private_key_id": "6b8c5175d05543a879130e534dfa31e7df53b14b",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDXNqnCTqtKdb++\ntN45mMh0EBjnNbr4r/vXyH4dD3thxwJCm6gscVNJwTke5czGR8lDKGkfjj1+jcQn\nnWj2soCPhhDnQ+jBlEi8JmQNz3/EYFgR+Ux/J+rDIMY58HkfObYcJb9tzi61WGXY\nVekVyerm7FlWK7CCZiTEFZjzfxl8y4BLQz9t0/B6lhsarEGKewmFFxaE37zLL/KM\nVjM+WHEHfkd3PQemMeInjN++uWWCPASQLGPIWlUsYOPkZruxFykErKGERFMmQjKK\nuMgJIm0cSVNp079FlDtye9LDrLdIzcC2brnzgS2QV36l2RiE/DZFxb2lRKmZiIWy\nOPy9sJv7AgMBAAECggEAPPQA8YT5c53U4Ez2saZpg6G5g+aOXXfuYqeovE9RuRg1\ntirC3097cOS2al9Yd4IGaSxtVaAiH5FEUJn/C/vzeHLWn8F2jzkRvqQ660RtIe/N\nkc2jUlI6ZeiG7AsFKwhb4S35wT5HsVnngnWWjfLBwoSHKuY12EDYweaCCtjhHZw6\ndL9ylUjY31TK2/KgR+ubE2mZ/CoOcCAgVAu1DMveRvzjfiwaV5U1NK3EqkAizcy0\nKK7tsBqiZjATcrTYMMPi4GC6TGXHu2JF1nRP3TwIS5TY/mUHx31ByTJyT1KWBBZb\nJGu9LvZeAm0c7cWnjSAEH83sW/T4AYZmrwsvnu1WrQKBgQDrNgk5BDQLLWWcBxpf\nGVnU7hi7FVFMutNg7eCPwVMNRVBIaU2dVxfcdxdnTjjELxc34dGZP/9c8fe76wUT\nuGipkM5kg/SW7X9BPRzm5takI5FETbN/pbD8hpERtQalKUxiDHLHUeN/zoMIrFB7\nxDDe3ASZ34i8iAcgiHYjungEDQKBgQDqPCfnmuByay9LOqLIkUfIG9JgPRWD3BwZ\nS5jFu9vFdoO4fmhWGeX7J13qeKuJSwp1GLsmkO31LPpLVTmlodUZhO8sI4c5u8O/\nEdGNr1WXOquY0AkFOqBblPnbM/+1CBoj9iNl+I9XpI/HWx/mKfwgjtVkGZIxJxIM\nsDNI3TJ2JwKBgGALc56lmb7KrcgVmm4kwurQwqZ6IPWNAE1/NQheb9Rmbk7zOO87\nphGvS44ygbmSZQ+7lUPXvyWr5HYGlM8lqQ88gxrGSzTqC+GO2+NpdVIW9/WFKPvB\no9Cp/kjVu73rbDZJUQEU7im9IQKEomS3iyElhHd0sLgTb52YO22BcgptAoGBAMk4\nnF9OoXopshtCaA09IRk7LWMXlqAMOudQFhHn7EiaI1Ye4ar13KgBjaCbwWDUYktt\nz3i2EHYLCYol0LwFZnfhx0V3z/c84lAGEqtQ8IpWEIvaS6V+U7vZIzu4U/dE2pAC\nJy62dQ2phQqRsbmcX8fobFDt1rT7B3p289eojm0JAoGAO2uuDWUyMd5ZIMeL9l4t\nL4tGtBjog63E5rRtaKst1AgJh0i9xNvm+pLc6fnShvlb3AQHZ210NUSncXvXqvvG\nhHFla9K2Zi0nWElGHr7gn7mp+TGBrKaQKQe81gNa/kGe7SKlbNXaZSN9IZSQz8iH\nmSO2hIHLEnX34erK/BIAUiE=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-175xm@local-service-marketplac-42398.iam.gserviceaccount.com",
      "client_id": "115583668754870131505",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-175xm%40local-service-marketplac-42398.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

//ACCESS TOKE KEY 6b8c5175d05543a879130e534dfa31e7df53b14b
  Future<void> sendNotificationToSeller(int orderId, String sellerId) async {
    final String serverKey =
        await getAccessToken(); // Replace "YOUR_SERVER_KEY" with your actual server key
    final String fromEndpoint =
        "https://fcm.googleapis.com/v1/projects/local-service-marketplac-42398/messages:send";
    String? currentFCMToken = await loadVerify(0);
    print("send message: " + currentFCMToken);

    // Check if currentFCMToken is not null
    if (currentFCMToken != null) {
      // Construct the FCM message payload
      final Map<String, dynamic> message = {
        'message': {
          'token': currentFCMToken,
          'notification': {
            'title': 'New Order',
            'body':
                'You have a new order. Check it at your upcoming order list.'
          },

          'data': {
            // You can add additional data if needed
            'orderId': orderId.toString(),
            'current_user_fcm_token': currentFCMToken,
          },
          // 'to': 'seller_$sellerId', // FCM topic for the seller
        }
      };

      // Send the FCM message using HTTP POST request
      final http.Response response = await http.post(
        Uri.parse(fromEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $serverKey', // Use the server key for authorization
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Notification sent to seller successfully');
      } else {
        print(
            'Failed to send notification to seller. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      print('Failed to get FCM token for seller.');
    }
  }

  void sendemail() {
    print("email: " + widget.user.email.toString() + "sellerid" + widget.service.sellerId.toString());
    http.post(
        Uri.parse(
            "https://labassign2.nwarz.com/lsm/php/send_notificationorderupdates.php"),
        body: {
          "sellerid": widget.service.sellerId,
        }).then((response) {
      if (response.statusCode == 200) {
        print("Notify seller via email");
      } else {
        print("Failed to send email");
      }
    }).catchError((error) {
      print("Error occured in sending email");
    });
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:local_service_marketplace/a5_3_orderpaymentscreen.dart';
// import 'package:local_service_marketplace/a5_7_userorderdetailsscreen.dart';
// import 'package:local_service_marketplace/config.dart';
// import 'package:local_service_marketplace/model/order.dart';
// import 'package:local_service_marketplace/model/service.dart';
// import 'package:local_service_marketplace/model/user.dart';

// class ServiceOrderScreen extends StatefulWidget {
//   final User user;
//   final Service service;
//   const ServiceOrderScreen(
//       {super.key, required this.user, required this.service});

//   @override
//   State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
// }

// class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
//   final df = DateFormat('dd-MM-yyyy');
//   final tf = DateFormat('hh:mm a');
//   int index = 0;
//   late double screenHeight, screenWidth, cardwitdh;
//   double qty = 0;
//   double totalprice = 0.0;
//   double singleprice = 0.0;
//   late int orderid;
//   late Service service;
//   final _quantityFormKey = GlobalKey<FormState>();
//   final _addressFormKey = GlobalKey<FormState>();
//   final TextEditingController qtyEditingController = TextEditingController();
//   final TextEditingController addressEditingController =
//       TextEditingController();
//   final TextEditingController messageEditingController =
//       TextEditingController();
//   late DateTime servicedate;
//   late TimeOfDay servicetime;
//   late Order order = Order(
//     orderId: "",
//     serviceId: "",
//     userId: "",
//     sellerId: "",
//     serviceName: "",
//     servicePrice: "",
//     serviceUnit: "",
//     orderQuantity: "",
//     orderTotalprice: "",
//     orderServicedate: "",
//     orderServicetime: "",
//     orderServiceaddress: "",
//     orderMessage: "",
//     orderDate: "",
//     orderUserstatus: "",
//     orderSellerstatus: "",
//     orderStatus: "",
//     paymentStatus: "",
//     receiptId: "",
//   );

//   @override
//   void initState() {
//     super.initState();
//     try {
//       singleprice = double.parse(widget.service.servicePrice.toString());
//     } catch (e) {
//       // Handle the case where parsing fails
//       print("Error parsing service price: $e");
//       singleprice = 0.0; // Or any default value you prefer
//     }
//     servicedate = DateTime.now();
//     servicetime = TimeOfDay.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(title: const Text("Order Service")),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Flexible(
//                 flex: 2,
//                 // height: screenHeight / 2.5,
//                 // width: screenWidth,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
//                   child: Card(
//                     child: Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                         child: CachedNetworkImage(
//                           width: screenWidth * 0.6,
//                           fit: BoxFit.cover,
//                           imageUrl:
//                               "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png",
//                           placeholder: (context, url) =>
//                               const LinearProgressIndicator(),
//                           errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                         )),
//                   ),
//                 )),
//             Container(
//                 padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                 child: Text(
//                   widget.service.serviceName.toString(),
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 )),
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//               child: Table(
//                 columnWidths: const {
//                   0: FlexColumnWidth(4),
//                   1: FlexColumnWidth(6),
//                 },
//                 children: [
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nPrice per unit",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\nRM ${double.parse(widget.service.servicePrice.toString()).toStringAsFixed(2)}",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nUnit",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n" + widget.service.serviceUnit.toString() + "\n",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nQuantity",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         key: _quantityFormKey,
//                         child: TextFormField(
//                           controller: qtyEditingController,
//                           onFieldSubmitted: (val) {
//                             setState(() {
//                               qty = double.parse(qtyEditingController.text);
//                               totalprice = double.parse(
//                                       widget.service.servicePrice.toString()) *
//                                   qty;
//                             });
//                           },
//                           validator: (val) => val!.isEmpty
//                               ? "Quantity must not be empty"
//                               : null,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: "Quantity",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   TableRow(
//                     children: [
//                       const TableCell(
//                         child: Text(
//                           "\nService Date",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       TableCell(
//                         child: Row(
//                           children: [
//                             Text(
//                               df.format(servicedate),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _selectDate(context);
//                               },
//                               icon: const Icon(Icons.calendar_today),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       const TableCell(
//                         child: Text(
//                           "\nService Time",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       TableCell(
//                         child: Row(
//                           children: [
//                             Text(
//                               tf.format(DateTime(
//                                 servicedate.year,
//                                 servicedate.month,
//                                 servicedate.day,
//                                 servicetime.hour,
//                                 servicetime.minute,
//                               )),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _selectTime(context);
//                               },
//                               icon: const Icon(Icons.access_time),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nAddress",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         key: _addressFormKey,
//                         child: TextFormField(
//                           controller: addressEditingController,
//                           validator: (val) => val!.isEmpty || val.length < 15
//                               ? "Please enter valid address"
//                               : null,
//                           maxLines: 6,
//                           keyboardType: TextInputType.text,
//                           decoration: const InputDecoration(
//                             labelText: "Address",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   const TableRow(children: [
//                     TableCell(
//                       child: Text(
//                         "\n",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nSpecial Request",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         child: TextFormField(
//                           controller: messageEditingController,
//                           maxLines: 4,
//                           keyboardType: TextInputType.text,
//                           decoration: const InputDecoration(
//                             labelText: "Special Request",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\n\nTotal Price",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n\nRM ${double.parse(totalprice.toString()).toStringAsFixed(2)}",
//                       ),
//                     )
//                   ]),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: screenWidth / 1.2,
//               height: 50,
//               child: ElevatedButton(
//                   onPressed: () {
//                     orderdialog();
//                   },
//                   child: const Text("Order it!")),
//             ),
//             const SizedBox(height: 40)
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     // initialDate: DateTime.now().add(Duration(days: 3)),
//     // firstDate: DateTime.now().add(Duration(days: 3)),
//      initialDate: DateTime.now(),
//     firstDate: DateTime.now(),
//     lastDate: DateTime(DateTime.now().year + 10),
//   );
//   if (pickedDate != null && pickedDate != servicedate) {
//     setState(() {
//       servicedate = pickedDate;
//     });
//   }
// }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: servicetime,
//     );
//     if (pickedTime != null) {
//       setState(() {
//         servicetime = pickedTime;
//       });
//     }
//   }

//   void orderService() {
//     // Convert servicedate to the format expected by PHP (YYYY-MM-DD)
//     String formattedDate =
//         "${servicedate.year}-${servicedate.month}-${servicedate.day}";

//     // Convert TimeOfDay to DateTime for database insertion
//     final DateTime selectedDateTime = DateTime(
//       servicedate.year,
//       servicedate.month,
//       servicedate.day,
//       servicetime.hour,
//       servicetime.minute,
//     );

//     http.post(Uri.parse("${Config.server}/lsm/php/insert_order.php"), body: {
//       "serviceid": widget.service.serviceId.toString(),
//       "userid": widget.user.id.toString(),
//       "sellerid": widget.service.sellerId.toString(),
//       "servicename": widget.service.serviceName.toString(),
//       "serviceprice": widget.service.servicePrice.toString(),
//       "serviceunit": widget.service.serviceUnit.toString(),
//       "servicequantity": qtyEditingController.text,
//       "orderprice": totalprice.toString(),
//       "date": formattedDate, // Use formattedDate here
//       "time": tf.format(selectedDateTime), // Format time for database insertion
//       "address": addressEditingController.text,
//       "message": messageEditingController.text,
//       "userstatus": "New",
//       "sellerstatus": "New",
//       "orderstatus": "Upcoming",
//       "paymentstatus": "Pending",
//       "receipt": "Pending",
//     }).then((response) {
//       print(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == 'success') {
//           // Extract the orderid from the JSON response
//           orderid = jsondata['data']['orderid'];

//           // Call loaduserorders() with the orderid parameter
//           loaduserorders(orderid);

//         } else {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Order Failed")));
//         }
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Failed")));
//       }
//     });
//   }

//   void orderdialog() {
//     if (widget.user.id.toString() == widget.service.sellerId.toString()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User cannot add own item")));
//       return;
//     }
//     if (_addressFormKey.currentState == null ||
//         !_addressFormKey.currentState!.validate()) {
//       // Check if _formKey.currentState is null before accessing validate()
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Check your address")));
//       return;
//     }

//     if (_quantityFormKey.currentState == null ||
//         !_quantityFormKey.currentState!.validate()) {
//       // Check if _formKey.currentState is null before accessing validate()
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Check your address")));
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: const Text(
//             "Order now",
//             style: TextStyle(),
//           ),
//           content: const Text("Are you sure?", style: TextStyle()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 "Yes",
//                 style: TextStyle(),
//               ),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 orderService();
//                 // Check if order is initialized before navigating
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 "No",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

// Future<void> loaduserorders(int orderid) async {
//   http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
//     "userid": widget.user.id.toString(),
//     "orderid": orderid.toString(), // Pass the orderid as a parameter
//   }).then((response) async {
//     print(response.statusCode);
//     log(response.body);
//     //if (mounted) { // Check if the widget is still mounted before updating the state
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == "success") {
//           order = Order.fromJson(jsondata['data']['order'][0]);
//           // Navigate to UserOrderDetailsScreen
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => UserOrderDetailsScreen(order: order),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("No Order Available.")),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No Order Available.")),
//         );
//       }
//     }
//   //}
//   ).catchError((error) {
//     print("Error loading user orders: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Error loading user orders.")),
//     );
//   });
// }

//}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:local_service_marketplace/a5_3_orderpaymentscreen.dart';
// import 'package:local_service_marketplace/a5_7_userorderdetailsscreen.dart';
// import 'package:local_service_marketplace/config.dart';
// import 'package:local_service_marketplace/model/order.dart';
// import 'package:local_service_marketplace/model/service.dart';
// import 'package:local_service_marketplace/model/user.dart';

// class ServiceOrderScreen extends StatefulWidget {
//   final User user;
//   final Service service;
//   const ServiceOrderScreen(
//       {super.key, required this.user, required this.service});

//   @override
//   State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
// }

// class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
//   final df = DateFormat('dd-MM-yyyy');
//   final tf = DateFormat('hh:mm a');
//   int index = 0;
//   late double screenHeight, screenWidth, cardwitdh;
//   double qty = 0;
//   double totalprice = 0.0;
//   double singleprice = 0.0;
//   late int orderid;
//   late Service service;
//   final _quantityFormKey = GlobalKey<FormState>();
//   final _addressFormKey = GlobalKey<FormState>();
//   final TextEditingController qtyEditingController = TextEditingController();
//   final TextEditingController addressEditingController =
//       TextEditingController();
//   final TextEditingController messageEditingController =
//       TextEditingController();
//   late DateTime servicedate;
//   late TimeOfDay servicetime;
//   late Order order;

//   @override
//   void initState() {
//     super.initState();
//     try {
//       singleprice = double.parse(widget.service.servicePrice.toString());
//     } catch (e) {
//       // Handle the case where parsing fails
//       print("Error parsing service price: $e");
//       singleprice = 0.0; // Or any default value you prefer
//     }
//     servicedate = DateTime.now();
//     servicetime = TimeOfDay.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(title: const Text("Order Service")),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Flexible(
//                 flex: 2,
//                 // height: screenHeight / 2.5,
//                 // width: screenWidth,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
//                   child: Card(
//                     child: Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                         child: CachedNetworkImage(
//                           width: screenWidth * 0.6,
//                           fit: BoxFit.cover,
//                           imageUrl:
//                               "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png",
//                           placeholder: (context, url) =>
//                               const LinearProgressIndicator(),
//                           errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                         )),
//                   ),
//                 )),
//             Container(
//                 padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                 child: Text(
//                   widget.service.serviceName.toString(),
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 )),
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//               child: Table(
//                 columnWidths: const {
//                   0: FlexColumnWidth(4),
//                   1: FlexColumnWidth(6),
//                 },
//                 children: [
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nPrice per unit",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\nRM ${double.parse(widget.service.servicePrice.toString()).toStringAsFixed(2)}",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nUnit",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n" + widget.service.serviceUnit.toString() + "\n",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nQuantity",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         key: _quantityFormKey,
//                         child: TextFormField(
//                           controller: qtyEditingController,
//                           onFieldSubmitted: (val) {
//                             setState(() {
//                               qty = double.parse(qtyEditingController.text);
//                               totalprice = double.parse(
//                                       widget.service.servicePrice.toString()) *
//                                   qty;
//                             });
//                           },
//                           validator: (val) => val!.isEmpty
//                               ? "Quantity must not be empty"
//                               : null,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: "Quantity",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   TableRow(
//                     children: [
//                       const TableCell(
//                         child: Text(
//                           "\nService Date",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       TableCell(
//                         child: Row(
//                           children: [
//                             Text(
//                               df.format(servicedate),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _selectDate(context);
//                               },
//                               icon: const Icon(Icons.calendar_today),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       const TableCell(
//                         child: Text(
//                           "\nService Time",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       TableCell(
//                         child: Row(
//                           children: [
//                             Text(
//                               tf.format(DateTime(
//                                 servicedate.year,
//                                 servicedate.month,
//                                 servicedate.day,
//                                 servicetime.hour,
//                                 servicetime.minute,
//                               )),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _selectTime(context);
//                               },
//                               icon: const Icon(Icons.access_time),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nAddress",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         key: _addressFormKey,
//                         child: TextFormField(
//                           controller: addressEditingController,
//                           validator: (val) => val!.isEmpty || val.length < 15
//                               ? "Please enter valid address"
//                               : null,
//                           maxLines: 6,
//                           keyboardType: TextInputType.text,
//                           decoration: const InputDecoration(
//                             labelText: "Address",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   const TableRow(children: [
//                     TableCell(
//                       child: Text(
//                         "\n",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nSpecial Request",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         child: TextFormField(
//                           controller: messageEditingController,
//                           maxLines: 4,
//                           keyboardType: TextInputType.text,
//                           decoration: const InputDecoration(
//                             labelText: "Special Request",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\n\nTotal Price",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n\nRM ${double.parse(totalprice.toString()).toStringAsFixed(2)}",
//                       ),
//                     )
//                   ]),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: screenWidth / 1.2,
//               height: 50,
//               child: ElevatedButton(
//                   onPressed: () {
//                     orderdialog();
//                   },
//                   child: const Text("Order it!")),
//             ),
//             const SizedBox(height: 40)
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     // initialDate: DateTime.now().add(Duration(days: 3)),
//     // firstDate: DateTime.now().add(Duration(days: 3)),
//      initialDate: DateTime.now(),
//     firstDate: DateTime.now(),
//     lastDate: DateTime(DateTime.now().year + 10),
//   );
//   if (pickedDate != null && pickedDate != servicedate) {
//     setState(() {
//       servicedate = pickedDate;
//     });
//   }
// }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: servicetime,
//     );
//     if (pickedTime != null) {
//       setState(() {
//         servicetime = pickedTime;
//       });
//     }
//   }

// void orderService() {
//   // Convert servicedate to the format expected by PHP (YYYY-MM-DD)
//   String formattedDate =
//       "${servicedate.year}-${servicedate.month}-${servicedate.day}";

//   // Convert TimeOfDay to DateTime for database insertion
//   final DateTime selectedDateTime = DateTime(
//     servicedate.year,
//     servicedate.month,
//     servicedate.day,
//     servicetime.hour,
//     servicetime.minute,
//   );

//   http.post(Uri.parse("${Config.server}/lsm/php/insert_order.php"), body: {
//     "serviceid": widget.service.serviceId.toString(),
//     "userid": widget.user.id.toString(),
//     "sellerid": widget.service.sellerId.toString(),
//     "servicename": widget.service.serviceName.toString(),
//     "serviceprice": widget.service.servicePrice.toString(),
//     "serviceunit": widget.service.serviceUnit.toString(),
//     "servicequantity": qtyEditingController.text,
//     "orderprice": totalprice.toString(),
//     "date": formattedDate, // Use formattedDate here
//     "time": tf.format(selectedDateTime), // Format time for database insertion
//     "address": addressEditingController.text,
//     "message": messageEditingController.text,
//     "userstatus": "New",
//     "sellerstatus": "New",
//     "orderstatus": "Upcoming",
//     "paymentstatus": "Pending",
//     "receipt": "Pending",
//   }).then((response) {
//     print(response.body);
//     if (response.statusCode == 200) {
//       var jsondata = jsonDecode(response.body);
//       if (jsondata['status'] == 'success') {
//         // Extract the orderid from the JSON response
//         orderid = jsondata['data']['orderid'];

//         // Navigate to UserOrderDetailsScreen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => UserOrderDetailsScreen(
//               order: Order(
//                 orderId: orderid.toString(),
//                 serviceId: widget.service.serviceId.toString(),
//                 userId: widget.user.id.toString(),
//                 sellerId: widget.service.sellerId.toString(),
//                 serviceName: widget.service.serviceName.toString(),
//                 servicePrice: widget.service.servicePrice.toString(),
//                 serviceUnit: widget.service.serviceUnit.toString(),
//                 orderQuantity: qtyEditingController.text,
//                 orderTotalprice: totalprice.toString(),
//                 orderServicedate: formattedDate,
//                 orderServicetime: tf.format(selectedDateTime),
//                 orderServiceaddress: addressEditingController.text,
//                 orderMessage: messageEditingController.text,
//                 orderDate: DateTime.now().toString(), // You can set this to the current date if needed
//                 orderUserstatus: "New",
//                 orderSellerstatus: "New",
//                 orderStatus: "Upcoming",
//                 paymentStatus: "Pending",
//                 receiptId: "Pending",
//               ),
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Order Failed")));
//       }
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Failed")));
//     }
//   }).catchError((error) {
//     print("Error processing order: $error");
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text("Error processing order")));
//   });
// }

//   void orderdialog() {
//     if (widget.user.id.toString() == widget.service.sellerId.toString()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User cannot add own item")));
//       return;
//     }
//     if (_addressFormKey.currentState == null ||
//         !_addressFormKey.currentState!.validate()) {
//       // Check if _formKey.currentState is null before accessing validate()
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Check your address")));
//       return;
//     }

//     if (_quantityFormKey.currentState == null ||
//         !_quantityFormKey.currentState!.validate()) {
//       // Check if _formKey.currentState is null before accessing validate()
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Check your address")));
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: const Text(
//             "Order now",
//             style: TextStyle(),
//           ),
//           content: const Text("Are you sure?", style: TextStyle()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 "Yes",
//                 style: TextStyle(),
//               ),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 orderService();
//                 // Check if order is initialized before navigating
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 "No",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

// }

// import 'dart:convert';
// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:local_service_marketplace/a5_3_orderpaymentscreen.dart';
// import 'package:local_service_marketplace/a5_7_userorderdetailsscreen.dart';
// import 'package:local_service_marketplace/config.dart';
// import 'package:local_service_marketplace/model/order.dart';
// import 'package:local_service_marketplace/model/service.dart';
// import 'package:local_service_marketplace/model/user.dart';

// class ServiceOrderScreen extends StatefulWidget {
//   final User user;
//   final Service service;
//   const ServiceOrderScreen({Key? key, required this.user, required this.service}) : super(key: key);

//   @override
//   State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
// }

// class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
//   final df = DateFormat('dd-MM-yyyy');
//   final tf = DateFormat('hh:mm a');
//   int index = 0;
//   late double screenHeight, screenWidth, cardwitdh;
//   double qty = 0;
//   double totalprice = 0.0;
//   double singleprice = 0.0;
//   late int orderid;
//   late Service service;
//   final _quantityFormKey = GlobalKey<FormState>();
//   final _addressFormKey = GlobalKey<FormState>();
//   final TextEditingController qtyEditingController = TextEditingController();
//   final TextEditingController addressEditingController =
//       TextEditingController();
//   final TextEditingController messageEditingController =
//       TextEditingController();
//   late DateTime servicedate;
//   late TimeOfDay servicetime;
//   List<Order> orderList = <Order>[];

//   @override
//   void initState() {
//     super.initState();
//     try {
//       singleprice = double.parse(widget.service.servicePrice.toString());
//     } catch (e) {
//       // Handle the case where parsing fails
//       print("Error parsing service price: $e");
//       singleprice = 0.0; // Or any default value you prefer
//     }
//     servicedate = DateTime.now();
//     servicetime = TimeOfDay.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(title: const Text("Order Service")),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Flexible(
//                 flex: 2,
//                 // height: screenHeight / 2.5,
//                 // width: screenWidth,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
//                   child: Card(
//                     child: Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                         child: CachedNetworkImage(
//                           width: screenWidth * 0.6,
//                           fit: BoxFit.cover,
//                           imageUrl:
//                               "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png",
//                           placeholder: (context, url) =>
//                               const LinearProgressIndicator(),
//                           errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                         )),
//                   ),
//                 )),
//             Container(
//                 padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                 child: Text(
//                   widget.service.serviceName.toString(),
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 )),
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//               child: Table(
//                 columnWidths: const {
//                   0: FlexColumnWidth(4),
//                   1: FlexColumnWidth(6),
//                 },
//                 children: [
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nPrice per unit",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\nRM ${double.parse(widget.service.servicePrice.toString()).toStringAsFixed(2)}",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nUnit",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n" + widget.service.serviceUnit.toString() + "\n",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nQuantity",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         key: _quantityFormKey,
//                         child: TextFormField(
//                           controller: qtyEditingController,
//                           onFieldSubmitted: (val) {
//                             setState(() {
//                               qty = double.parse(qtyEditingController.text);
//                               totalprice = double.parse(
//                                       widget.service.servicePrice.toString()) *
//                                   qty;
//                             });
//                           },
//                           validator: (val) => val!.isEmpty
//                               ? "Quantity must not be empty"
//                               : null,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: "Quantity",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   TableRow(
//                     children: [
//                       const TableCell(
//                         child: Text(
//                           "\nService Date",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       TableCell(
//                         child: Row(
//                           children: [
//                             Text(
//                               df.format(servicedate),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _selectDate(context);
//                               },
//                               icon: const Icon(Icons.calendar_today),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       const TableCell(
//                         child: Text(
//                           "\nService Time",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       TableCell(
//                         child: Row(
//                           children: [
//                             Text(
//                               tf.format(DateTime(
//                                 servicedate.year,
//                                 servicedate.month,
//                                 servicedate.day,
//                                 servicetime.hour,
//                                 servicetime.minute,
//                               )),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _selectTime(context);
//                               },
//                               icon: const Icon(Icons.access_time),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nAddress",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         key: _addressFormKey,
//                         child: TextFormField(
//                           controller: addressEditingController,
//                           validator: (val) => val!.isEmpty || val.length < 15
//                               ? "Please enter valid address"
//                               : null,
//                           maxLines: 6,
//                           keyboardType: TextInputType.text,
//                           decoration: const InputDecoration(
//                             labelText: "Address",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   const TableRow(children: [
//                     TableCell(
//                       child: Text(
//                         "\n",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n",
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\nSpecial Request",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Form(
//                         child: TextFormField(
//                           controller: messageEditingController,
//                           maxLines: 4,
//                           keyboardType: TextInputType.text,
//                           decoration: const InputDecoration(
//                             labelText: "Special Request",
//                             labelStyle: TextStyle(),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(width: 2.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]),
//                   TableRow(children: [
//                     const TableCell(
//                       child: Text(
//                         "\n\nTotal Price",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     TableCell(
//                       child: Text(
//                         "\n\nRM ${double.parse(totalprice.toString()).toStringAsFixed(2)}",
//                       ),
//                     )
//                   ]),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: screenWidth / 1.2,
//               height: 50,
//               child: ElevatedButton(
//                   onPressed: () {
//                     orderdialog();
//                   },
//                   child: const Text("Order it!")),
//             ),
//             const SizedBox(height: 40)
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       // initialDate: DateTime.now().add(Duration(days: 3)),
//       // firstDate: DateTime.now().add(Duration(days: 3)),
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(DateTime.now().year + 10),
//     );
//     if (pickedDate != null && pickedDate != servicedate) {
//       setState(() {
//         servicedate = pickedDate;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: servicetime,
//     );
//     if (pickedTime != null) {
//       setState(() {
//         servicetime = pickedTime;
//       });
//     }
//   }

//   void orderService() {
//     // Convert servicedate to the format expected by PHP (YYYY-MM-DD)
//     String formattedDate =
//         "${servicedate.year}-${servicedate.month}-${servicedate.day}";

//     // Convert TimeOfDay to DateTime for database insertion
//     final DateTime selectedDateTime = DateTime(
//       servicedate.year,
//       servicedate.month,
//       servicedate.day,
//       servicetime.hour,
//       servicetime.minute,
//     );

//     http.post(Uri.parse("${Config.server}/lsm/php/insert_order.php"), body: {
//       "serviceid": widget.service.serviceId.toString(),
//       "userid": widget.user.id.toString(),
//       "sellerid": widget.service.sellerId.toString(),
//       "servicename": widget.service.serviceName.toString(),
//       "serviceprice": widget.service.servicePrice.toString(),
//       "serviceunit": widget.service.serviceUnit.toString(),
//       "servicequantity": qtyEditingController.text,
//       "orderprice": totalprice.toString(),
//       "date": formattedDate, // Use formattedDate here
//       "time": tf.format(selectedDateTime), // Format time for database insertion
//       "address": addressEditingController.text,
//       "message": messageEditingController.text,
//       "userstatus": "New",
//       "sellerstatus": "New",
//       "orderstatus": "Upcoming",
//       "paymentstatus": "Pending",
//       "receipt": "Pending",
//     }).then((response) async {
//       print(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == 'success') {
//           // Extract the orderid from the JSON response
//           orderid = jsondata['data']['orderid'];
//           loaduserorders(orderid);

//           Order order = Order.fromJson(orderList[0].toJson());
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => UserOrderDetailsScreen(order: order),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Order Failed")));
//         }
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Failed")));
//       }
//     }).catchError((error) {
//       print("Error processing order: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Error processing order")));
//     });
//   }

//   void orderdialog() {
//     if (widget.user.id.toString() == widget.service.sellerId.toString()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User cannot add own item")));
//       return;
//     }
//     if (_addressFormKey.currentState == null ||
//         !_addressFormKey.currentState!.validate()) {
//       // Check if _formKey.currentState is null before accessing validate()
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Check your address")));
//       return;
//     }

//     if (_quantityFormKey.currentState == null ||
//         !_quantityFormKey.currentState!.validate()) {
//       // Check if _formKey.currentState is null before accessing validate()
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Check your address")));
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: const Text(
//             "Order now",
//             style: TextStyle(),
//           ),
//           content: const Text("Are you sure?", style: TextStyle()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 "Yes",
//                 style: TextStyle(),
//               ),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 orderService();
//                 // Check if order is initialized before navigating
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 "No",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void loaduserorders(int orderid) {
//     http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
//       "userid": widget.user.id.toString(),
//       "orderid": orderid.toString(),
//     }).then((response) {
//       print(response.statusCode);
//       log(response.body);
//       orderList.clear();
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == "success") {
//           orderList.clear();
//           var extractdata = jsondata['data'];
//           extractdata['order'].forEach((v) {
//             Order order = Order.fromJson(v);
//             orderList.add(order);
//           });
//         }
//       }
//     });
//   }
// }
