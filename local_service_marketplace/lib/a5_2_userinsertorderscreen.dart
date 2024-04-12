import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a5_3_orderpaymentscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';

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
  double singleprice = 0.0;
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
  late Order order = Order(
    orderId: "",
    serviceId: "",
    userId: "",
    sellerId: "",
    serviceName: "",
    servicePrice: "",
    serviceUnit: "",
    orderQuantity: "",
    orderTotalprice: "",
    orderServicedate: "",
    orderServicetime: "",
    orderServiceaddress: "",
    orderMessage: "",
    orderDate: "",
    orderUserstatus: "",
    orderSellerstatus: "",
    orderStatus: "",
    paymentStatus: "",
    receiptId: "",
  );

  @override
  void initState() {
    super.initState();
   try {
  singleprice = double.parse(widget.service.servicePrice.toString());
} catch (e) {
  // Handle the case where parsing fails
  print("Error parsing service price: $e");
  singleprice = 0.0; // Or any default value you prefer
}
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
                          onFieldSubmitted: (val) {
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
                  onPressed: () {
                    orderdialog();
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
      initialDate: DateTime.now()
          .add(Duration(days: 3)), // Start from three days later than today
      firstDate: DateTime.now().add(Duration(
          days: 3)), // Restrict selection to three days later than today
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
      initialTime: servicetime,
    );
    if (pickedTime != null) {
      setState(() {
        servicetime = pickedTime;
      });
    }
  }

  void orderService() {
    // Convert servicedate to the format expected by PHP (YYYY-MM-DD)
    String formattedDate =
        "${servicedate.year}-${servicedate.month}-${servicedate.day}";

    // Convert TimeOfDay to DateTime for database insertion
    final DateTime selectedDateTime = DateTime(
      servicedate.year,
      servicedate.month,
      servicedate.day,
      servicetime.hour,
      servicetime.minute,
    );

    http.post(Uri.parse("${Config.server}/lsm/php/insert_order.php"), body: {
      "serviceid": widget.service.serviceId.toString(),
      "userid": widget.user.id.toString(),
      "sellerid": widget.service.sellerId.toString(),
      "servicename": widget.service.serviceName.toString(),
      "serviceprice": widget.service.servicePrice.toString(),
      "serviceunit": widget.service.serviceUnit.toString(),
      "servicequantity": qtyEditingController.text,
      "orderprice": totalprice.toString(),
      "date": formattedDate, // Use formattedDate here
      "time": tf.format(selectedDateTime), // Format time for database insertion
      "address": addressEditingController.text,
      "message": messageEditingController.text,
      "userstatus": "New",
      "sellerstatus": "New",
      "orderstatus": "Upcoming",
      "paymentstatus": "Pending",
      "receipt": "Pending",
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          // Extract the orderid from the JSON response
          int orderid = jsondata['data']['orderid'];

          // Initialize the order object
          order = Order(); // Assuming Order class has a default constructor

          // Call loaduserorders() with the orderid parameter
          loaduserorders(orderid);

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Order Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Order Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
      }
    });
  }

  void orderdialog() {
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
                orderService();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Check if order is initialized before navigating
                if (order != null) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              PaymentScreen(user: widget.user, order: order)));
                }
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

  Future<void> loaduserorders(int orderid) async {
    http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
      "userid": widget.user.id,
      "orderid": orderid.toString(), // Pass the orderid as a parameter
    }).then((response) {
      print(response.statusCode);
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          order = Order.fromJson(jsondata['data']);
          setState(() {});
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
}
