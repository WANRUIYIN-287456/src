import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String paymentAmount;
  const PaymentScreen(
      {super.key, required this.user, required this.paymentAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late double screenHeight, cardwitdh;
  final df = DateFormat('dd-MM-yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Gateway")),
      body: Center(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 20, 0),
                        child: Image.asset(
                          "assets/images/payment.png",
                          scale: 1.8,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.user.name.toString(),
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const Divider(),
                                Text(widget.user.phone.toString()),
                                Text(df.format(DateTime.now())),
                                Text("RM ${widget.paymentAmount}"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 40),
            const Text("Pay with: "),
            Image.asset(
              "assets/images/logo.png",
              scale: 1.8,
            ),
            const SizedBox(height: 40),
            Flexible(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Successful Payment")),
                )),
          ],
        ),
      ),
    );
  }
}
