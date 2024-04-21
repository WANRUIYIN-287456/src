import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_service_marketplace/a5_7_userorderdetailsscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final Order order;

  const PaymentScreen({Key? key, required this.user, required this.order})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String name, phone, email;
  late double amount = 0.0;
  bool isLoading = true; // Track loading state
  late Order order;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    name = widget.user.name.toString();
    phone = widget.user.phone.toString();
    email = widget.user.email.toString();
    amount = double.parse(widget.order.orderTotalprice ?? '0.0');

    // Call the createBill function here
    createBill();
  }

  Future<void> createBill() async {
    final String apiKey = 'ad6d8fba-0931-4ad5-b987-ceac85e1f101';
    final String collectionId = 'yoi_xsfc';

    try {
      final Uri uri = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
      final Map<String, dynamic> requestBody = {
        'collection_id': collectionId,
        'description': 'Payment for order by $name',
        'email': widget.user.email,
        'amount': amount * 100, // Amount in cents
        'callback_url': 'https://labassign2.nwarz.com/lsm/',
      };

      final http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $apiKey',
        },
        body: jsonEncode(requestBody),
      );
      print('Billplz API Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // You can handle receipt ID here if needed
        print('Receipt ID: ${responseData['id']}');
      } else {
        // Handle error
        print('Failed to create bill: ${response.body}');
      }
    } catch (e) {
      print('Error creating bill: $e');
    }
  }

  void loaduserorders() {
    if (!mounted) return; // Check if the widget is mounted before proceeding

    http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
      "userid": widget.order.userId,
      "orderid": widget.order.orderId,
    }).then((response) {
      if (!mounted) return; // Check again after the async operation
      print(response.statusCode);
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var orderData = jsondata['data']['order'];
          if (orderData != null && orderData.isNotEmpty) {
            var orderItem = orderData[0];
            // Create an Order object from the JSON data
            Order order = Order(
              orderId: orderItem['order_id'],
              serviceId: orderItem['service_id'],
              userId: orderItem['user_id'],
              sellerId: orderItem['seller_id'],
              serviceName: orderItem['service_name'],
              servicePrice: orderItem['service_price'],
              serviceUnit: orderItem['service_unit'],
              orderQuantity: orderItem['order_quantity'],
              orderTotalprice: orderItem['order_totalprice'],
              orderServicedate: orderItem['order_servicedate'],
              orderServicetime: orderItem['order_servicetime'],
              orderServiceaddress: orderItem['order_serviceaddress'],
              orderMessage: orderItem['order_message'],
              orderDate: orderItem['order_date'],
              orderUserstatus: orderItem['order_userstatus'],
              orderSellerstatus: orderItem['order_sellerstatus'],
              orderStatus: orderItem['order_status'],
              paymentStatus: orderItem['payment_status'],
              receiptId: orderItem['receipt_id'],
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserOrderDetailsScreen(order: order),
              ),
            );
          }
        } else {
          setState(() {});
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No Order Available.")));
        }
        setState(() {});
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Order Available.")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //     Navigator.pop(context);
        //    // Navigator.pop(context);
        //   },
        // ),
        actions: [
          TextButton(
              onPressed: () {
                loaduserorders();
                // Navigator.popUntil(context, (route) => route.isFirst);
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context);
              },
              child: const Text(
                "Done",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ))
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl:
                'https://labassign2.nwarz.com/lsm/php/payment.php?sellerid=${widget.order.sellerId}&orderid=${widget.order.orderId}&userid=${widget.user.id}&email=${widget.user.email}&phone=${widget.user.phone}&name=${widget.user.name}&amount=$amount',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageStarted: (String url) {
              setState(() {
                isLoading = true; // Start loading, show indicator
              });
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false; // Finish loading, hide indicator
              });
            },
          ),
          if (isLoading)
            Center(
              child:
                  CircularProgressIndicator(), // Show circular progress indicator while loading
            ),
        ],
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:local_service_marketplace/a5_7_userorderdetailsscreen.dart';
// import 'package:local_service_marketplace/config.dart';
// import 'package:local_service_marketplace/model/order.dart';
// import 'package:local_service_marketplace/model/user.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentScreen extends StatefulWidget {
//   final User user;
//   final Order order;

//   const PaymentScreen({Key? key, required this.user, required this.order})
//       : super(key: key);

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late String name, phone, email;
//   late double amount = 0.0;
//   bool isLoading = true; // Track loading state
//   late Order order;
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   @override
//   void initState() {
//     super.initState();
//     name = widget.user.name.toString();
//     phone = widget.user.phone.toString();
//     email = widget.user.email.toString();
//     amount = double.parse(widget.order.orderTotalprice ?? '0.0');

//     // Call the createBill function here
//     createBill();
//   }

//   Future<void> createBill() async {
//     final String apiKey = 'ad6d8fba-0931-4ad5-b987-ceac85e1f101';
//     final String collectionId = 'yoi_xsfc';

//     try {
//       final Uri uri = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
//       final Map<String, dynamic> requestBody = {
//         'collection_id': collectionId,
//         'description': 'Payment for order by $name',
//         'email': widget.user.email,
//         'amount': amount * 100, // Amount in cents
//         'callback_url': 'https://labassign2.nwarz.com/lsm/',
//       };

//       final http.Response response = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Basic $apiKey',
//         },
//         body: jsonEncode(requestBody),
//       );
//       print('Billplz API Response: ${response.statusCode} ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         // You can handle receipt ID here if needed
//         print('Receipt ID: ${responseData['id']}');
//       } else {
//         // Handle error
//         print('Failed to create bill: ${response.body}');
//       }
//     } catch (e) {
//       print('Error creating bill: $e');
//     }
//   }

//   void loaduserorders() {
//     if (!mounted) return; // Check if the widget is mounted before proceeding

//     http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
//       "userid": widget.order.userId,
//       "orderid": widget.order.orderId,
//     }).then((response) {
//       if (!mounted) return; // Check again after the async operation
//       print(response.statusCode);
//       log(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == "success") {
//           order = Order.fromJson(jsondata['data']);
//           setState(() {});
//         } else {
//           setState(() {});
//           Navigator.of(context).pop();
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("No Order Available.")));
//         }
//         setState(() {});
//       } else {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("No Order Available.")));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => UserOrderDetailsScreen(
//                   order: widget.order,
//                   onUpdatePaymentStatus: () {
//                     // Reload order details here
//                     loaduserorders();
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebView(
//             initialUrl:
//                 'https://labassign2.nwarz.com/lsm/php/payment.php?sellerid=${widget.order.sellerId}&orderid=${widget.order.orderId}&userid=${widget.user.id}&email=${widget.user.email}&phone=${widget.user.phone}&name=${widget.user.name}&amount=$amount',
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller.complete(webViewController);
//             },
//             onPageStarted: (String url) {
//               setState(() {
//                 isLoading = true; // Start loading, show indicator
//               });
//             },
//             onPageFinished: (String url) {
//               setState(() {
//                 isLoading = false; // Finish loading, hide indicator
//               });
//             },
//             javascriptChannels: <JavascriptChannel>[
//               JavascriptChannel(
//                 name: 'paymentCompleted',
//                 onMessageReceived: (JavascriptMessage message) {
//                   // Payment completed, navigate back to UserOrderDetailsScreen
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UserOrderDetailsScreen(
//                         order: widget.order,
//                         onUpdatePaymentStatus: () {
//                           // Reload order details here
//                           loaduserorders();
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               JavascriptChannel(
//                 name: 'paymentFailed',
//                 onMessageReceived: (JavascriptMessage message) {
//                   // Payment failed, handle accordingly (if needed)
//                 },
//               ),
//             ].toSet(),
//           ),
//           if (isLoading)
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }
