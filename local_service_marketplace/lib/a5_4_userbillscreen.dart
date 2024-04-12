import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final Order order;
  const BillScreen({super.key, required this.user, required this.order});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Receipt"),
        ),
        body: Center(
          child: WebView(
            initialUrl:
                '${Config.server}/lsm/php/payment_bill.php?orderid=${widget.order.orderId}&sellerid=${widget.order.sellerId}&userid=${widget.user.id}&email=${widget.user.email}&phone=${widget.user.phone}&name=${widget.user.name}&amount=${widget.order.orderTotalprice}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              // prg = progress as double;
              // setState(() {});
              // print('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              // print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              //print('Page finished loading: $url');
              setState(() {
                //isLoading = false;
              });
            },
          ),
        ));
  }
}