// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
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
//   late double amount;
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   @override
//   void initState() {
//     super.initState();
//     name = widget.user.name.toString();
//     phone = widget.user.phone.toString();
//     email = widget.user.email.toString();
//     amount = double.parse(widget.order.orderTotalprice.toString());

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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//       ),
//       body: Center(
//         child: WebView(
//           initialUrl:
//               'https://labassign2.nwarz.com/lsm/php/payment.php?sellerid=${widget.order.sellerId}&orderid=${widget.order.orderId}&userid=${widget.user.id}&email=${widget.user.email}&phone=${widget.user.phone}&name=${widget.user.name}&amount=$amount',
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (WebViewController webViewController) {
//             _controller.complete(webViewController);
//           },
//           onProgress: (int progress) {
//             // prg = progress as double;
//             // setState(() {});
//             // print('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             // print('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             //print('Page finished loading: $url');
//             setState(() {
//               //isLoading = false;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
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
              child: CircularProgressIndicator(), // Show circular progress indicator while loading
            ),
        ],
      ),
    );
  }
}
