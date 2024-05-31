import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a9_0_adminlogin.dart';
import 'package:local_service_marketplace/a9_4_adminverifydetails.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/admin.dart';
import 'package:local_service_marketplace/model/seller.dart';
import 'package:http/http.dart' as http;

class AdminVerifyList extends StatefulWidget {
  final Admin admin;
  const AdminVerifyList({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminVerifyList> createState() => _AdminVerifyListState();
}

class _AdminVerifyListState extends State<AdminVerifyList> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  String maintitle = "Service Provider List";
  List<Seller> sellerList = <Seller>[];
  late Admin admin;
  int index = 0;

  final TextEditingController searchEditingController = TextEditingController();
  String upload = "All";
  String verify = "All";
  String available = "All";

  List<String> uploadlist = [
    "All",
    "true",
    "false",
  ];
  List<String> verifylist = [
    "All",
    "true",
    "false",
  ];
  List<String> availablelist = [
    "All",
    "true",
    "false",
  ];

  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;

  @override
  void initState() {
    super.initState();
    loadpageService(1);
    print("Service Provider");
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
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const AdminLoginScreen()));
              },
              icon: const Icon(Icons.logout_sharp))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
                  child: TextField(
                    controller: searchEditingController,
                    decoration: InputDecoration(
                      hintText: "Search",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          String search = searchEditingController.text;
                          searchService(search, 1);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  filterDialog();
                },
                child: const Icon(Icons.filter_list),
              ),
            ],
          ),
          Expanded(
            child: sellerList.isEmpty
                ? Center(child: Text("No Data"))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 24,
                        color: Color.fromARGB(255, 60, 213, 198),
                        alignment: Alignment.center,
                        child: Text(
                          "${numberofresult.toString()} Service Provider(s) Found",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: axiscount,
                          children: List.generate(
                            sellerList.length,
                            (index) {
                              return Card(
                                child: InkWell(
                                  onTap: () async {
                                    Seller seller = sellerList[index];
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (content) =>
                                            AdminVerifyDetails(
                                                admin: widget.admin,
                                                seller: seller),
                                      ),
                                    );
                                    loadService(1);
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 17, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (sellerList[index].proStatus ==
                                                "true") ...[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Colors.orangeAccent,
                                                ),
                                                child: const Text("  Pro  "),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                            if (sellerList[index]
                                                    .preferredStatus ==
                                                "true") ...[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Colors.orangeAccent,
                                                ),
                                                child:
                                                    const Text("  Preferred  "),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      CachedNetworkImage(
                                        width: screenWidth * 0.2,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${Config.server}/lsm/assets/images/profile/${sellerList[index].sellerId}.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      Text(
                                        sellerList[index].sellerName.toString(),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "Uploaded: " +
                                            sellerList[index]
                                                .uploadStatus
                                                .toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        "Verified: " +
                                            sellerList[index]
                                                .verifyStatus
                                                .toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        "Available: " +
                                            sellerList[index]
                                                .availableStatus
                                                .toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: numofpage,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final color = (curpage - 1) == index
                                ? Colors.red
                                : Colors.black;
                            return TextButton(
                              onPressed: () {
                                curpage = index + 1;
                                loadService(index + 1);
                              },
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void loadpageService(int pg) {
    curpage = pg;
    numofpage;

    http.post(Uri.parse("${Config.server}/lsm/php/load_pageverify.php"), body: {
      "pageno": pg.toString(),
    }).then((response) {
      print(response.body);
      try {
        sellerList.clear();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            print(numberofresult);
            var extractdata = jsondata['data'];

            extractdata['seller'].forEach((v) {
              sellerList.add(Seller.fromJson(v));
            });

            print(sellerList[0].sellerName);
          }
          setState(() {});
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  void loadService(int pg) {
  curpage = pg;
  numofpage;
  http.post(Uri.parse("${Config.server}/lsm/php/load_barterverify.php"),
      body: {
        "pageno": pg.toString(), // Convert pg to string explicitly
      }).then((response) {
    print(response.body);
    try {
      sellerList.clear();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
          var extractdata = jsondata['data'];

          extractdata['seller'].forEach((v) {
            sellerList.add(Seller.fromJson(v));
          });

          print(sellerList[0].sellerName);
        }
        setState(() {});
      }
    } catch (e, _) {
      debugPrint(e.toString());
    }
  });
}

void searchService(String search, int pg) {
  http.post(Uri.parse("${Config.server}/lsm/php/load_barterverify.php"), body: {
    "pageno": pg.toString(),
    "search": search,
  }).then((response) {
    if (mounted) {
      sellerList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
          var extractdata = jsondata['data'];
          extractdata['seller'].forEach((v) {
            sellerList.add(Seller.fromJson(v));
          });
        }
        setState(() {});
      }
    }
  });
}

void filterService(int pg) {
  http.post(Uri.parse("${Config.server}/lsm/php/load_barterverify.php"), body: {
    "pageno": pg.toString(),
    "upload": upload.toString(),
    "verify": verify.toString(),
    "available": available.toString(),
  }).then((response) {
    if (mounted) {
      sellerList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
          var extractdata = jsondata['data'];
          extractdata['seller'].forEach((v) {
            sellerList.add(Seller.fromJson(v));
          });
        }
        setState(() {});
      }
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
                        "Uploaded",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 39,
                    ),
                    Expanded(
                      child: Container(
                        height: 60,
                        width: 150,
                        child: DropdownButton(
                          isExpanded: true,
                          value: upload,
                          onChanged: (newValue) {
                            setState(() {
                              upload = newValue!;
                              print(upload);
                            });
                          },
                          items: uploadlist.map((upload) {
                            return DropdownMenuItem(
                              value: upload,
                              child: Text(
                                upload,
                              ),
                            );
                          }).toList(),
                        ),
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
                        "Verified",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 55,
                    ),
                    Expanded(
                      child: Container(
                        height: 60,
                        width: 150,
                        child: DropdownButton(
                          isExpanded: true,
                          value: verify,
                          onChanged: (newValue) {
                            setState(() {
                              verify = newValue!;
                              print(verify);
                            });
                          },
                          items: verifylist.map((verify) {
                            return DropdownMenuItem(
                              value: verify,
                              child: Text(
                                verify,
                              ),
                            );
                          }).toList(),
                        ),
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
                        "Available",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 39,
                    ),
                    Expanded(
                      child: Container(
                        height: 60,
                        width: 150,
                        child: DropdownButton(
                          isExpanded: true,
                          value: available,
                          onChanged: (newValue) {
                            setState(() {
                              available = newValue!;
                              print(available);
                            });
                          },
                          items: availablelist.map((available) {
                            return DropdownMenuItem(
                              value: available,
                              child: Text(
                                available,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ]),
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
                filterService(1);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
