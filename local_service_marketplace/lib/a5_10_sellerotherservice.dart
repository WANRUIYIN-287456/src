import 'dart:convert';
import 'dart:math';
//import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a5_1_userservicedetails.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';

class SellerOrtherService extends StatefulWidget {
  final User user;
  final String sellerId;
  const SellerOrtherService({super.key, required this.user, required this.sellerId});

  @override
  State<SellerOrtherService> createState() => _SellerOrtherServiceState();
}

class _SellerOrtherServiceState extends State<SellerOrtherService> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  String maintitle = "More Services";
  List<Service> serviceList = <Service>[];

  @override
  void initState() {
    super.initState();
    loadService();
    print("id"+ widget.sellerId.toString());
    print(serviceList.length);
    print("Service");
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
      ),
      body: serviceList.isEmpty
          ? Center(
              child: Column(
              children: [
                Container(
                  height: 350,
                  alignment: Alignment.center,
                  child: const Text("No Data"),
                )
              ],
            ))
          : Column(children: [
              Container(
                height: 24,
                color: Color.fromARGB(255, 60, 213, 198),
                alignment: Alignment.center,
                child: Text(
                  "${serviceList.length} Service(s) Found",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        serviceList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onTap: () async {
                                Service service = Service.fromJson(
                                    serviceList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => ServiceDetailScreen(user: widget.user, service: service)));
                                loadService();
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth * 0.35,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${Config.server}/lsm/assets/images/${serviceList[index].serviceId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  serviceList[index].serviceName.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "RM ${double.parse(serviceList[index].servicePrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "per ${serviceList[index].serviceUnit.toString()}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]),
                            ),
                          );
                        },
                      )))
            ]),
    );
  }

 

 void loadService() {
  http.post(Uri.parse("${Config.server}/lsm/php/load_product.php"),
      body: {"sellerid": widget.sellerId}).then((response) {
    // Clear the existing serviceList before adding new services
    setState(() {
      serviceList.clear();
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "success") {
        var extractData = jsonData['data'];
        // Update serviceList with new services
        setState(() {
          serviceList = List<Service>.from(extractData.map((model) => Service.fromJson(model)));
        });
      }
    }
  });
}




}