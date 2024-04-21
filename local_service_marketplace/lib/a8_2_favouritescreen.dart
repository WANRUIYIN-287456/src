import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a5_1_userservicedetails.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'package:http/http.dart' as http;

class FavouriteScreen extends StatefulWidget {
  final User user;
  const FavouriteScreen({super.key, required this.user});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "My Favourites";
  List<Service> serviceList = <Service>[];
  late User user;
  int numberofresult = 0;

  @override
  void initState() {
    super.initState();
    loadFavourites();
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
        title: Text(maintitle)),
      body: serviceList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Color.fromARGB(255, 60, 213, 198),
                alignment: Alignment.center,
                child: Text(
                  "${serviceList.length} Service(s) Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
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
                                        builder: (content) =>
                                            ServiceDetailScreen(
                                                user: widget.user,
                                                service: service)));
                                loadFavourites();
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth * 0.28,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${Config.server}/lsm/assets/images/${serviceList[index].serviceId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  serviceList[index].serviceName.toString(),
                                  style: const TextStyle(fontSize: 20),
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
                      ))),
            ]),
    );
  }

    void loadFavourites() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${Config.server}/lsm/php/load_favourite.php"),
        body: {"userid": widget.user.id}).then((response) {
      //print(response.body);
      //log(response.body);
      serviceList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          for (var v in extractdata) {
            serviceList.add(Service.fromJson(v));
          }
          if (serviceList.isNotEmpty) {
            print(serviceList[0].serviceName);
          }
        }

        setState(() {
        });
      }
    });
  }
}
