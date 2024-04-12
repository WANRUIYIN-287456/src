import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a5_1_userservicedetails.dart';
import 'package:local_service_marketplace/a5_6_userorderlistscreen.dart';
// import 'package:local_service_marketplace/a5_4_userbilllscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'package:http/http.dart' as http;

class HomeTabScreen extends StatefulWidget {
  final User user;
  const HomeTabScreen({super.key, required this.user});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Services";
  List<Service> serviceList = <Service>[];
  late User user;

  final TextEditingController searchEditingController = TextEditingController();
  final TextEditingController valueaEditingController = TextEditingController();
  final TextEditingController valuebEditingController = TextEditingController();
  String state = "All States";
  String selectedCategory = "All Categories";
  String selectedType = "All Types";

  Map<String, List<String>> categoryToTypes = {
    "All Categories": ["All Types"],
    "Home Maintenance and Renovation": [
      "Renovation",
      "Architecture",
      "Interior design",
      "Plumber",
      "Moving Service",
      "Electrical Maintenance/ Wiring service",
      "Electrical Appliances Installation/ Maintenance",
      "Locksmith Service",
      "Cleaning Service",
      "Pest Control Service",
      "Roof Repairing Service",
      "Fumigation Service",
      "Sanitation and Disinfection Service",
      "Others",
    ],
    "Event Organizing and Management": [
      "Event Planning Service",
      "Catering Service",
      "Makeup Service",
      "Photography Service",
      "Printing Service",
      "Chauffeur Service",
      "Others",
    ],
    "Automotive Service": [
      "Mechanic",
      "Welding Service",
      "Accessories Installation/ Maintenance",
      "Others",
    ],
    "Healthcare and Wellness": [
      "Nursing Service/ Nurse Aiders/ Healthcare Workers",
      "Confinement Nurse",
      "Others",
    ],
    "Personal Services": [
      "Personal Shoppers/ Runners",
      "Professional Organizer",
      "Babysitter",
      "Afterschool Care/ Day Care",
      "Others",
    ],
    "Consultation Services": [
      "Legal",
      "Human Resources",
      "Tax & Account",
      "Medical",
      "Psychological",
      "Others",
    ],
    "Education": [
      "Tutor Services",
      "Soft Skill Training",
      "Swimming Class",
      "Sport Activity Class",
      "Physique Course",
      "Dance Class",
      "Fitness Class",
      "Others",
    ],
    "Leisure and Others": [
      "Piano Tuning Services",
      "Pet Grooming Services",
      "Beauty Services",
      "Others",
    ],
  };
  List<String> typeList = ["All Types"];
  List<String> statelist = [
    "All States",
    "Johor",
    "Kedah",
    "Kelantan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Perak",
    "Perlis",
    "Pulau Pinang",
    "Sabah",
    "Sarawak",
    "Selangor",
    "Terengganu",
  ];

  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;

  @override
  void initState() {
    super.initState();
    loadpageService(1);
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
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Order"),
              ),
              // const PopupMenuItem<int>(
              //   value: 1,
              //   child: Text("My Bill"),
              // ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              if (widget.user.id.toString() == "na") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          UserOrderScreen(user: widget.user)));
            }
            //  else if (value == 1) {
            //   if (widget.user.id.toString() == "na") {
            //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //         content: Text("Please login/register an account")));
            //     return;
            //   }
            //   await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (content) => BillScreen(
            //                 user: widget.user,
            //               )));
            // } else if (value == 2) {}
          }),
        ],
      ),
      body: serviceList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: TextField(
                      controller: searchEditingController,
                      decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  String search = searchEditingController.text;
                                  searchService(search, 1);
                                },
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      filterDialog();
                    }, //show dialog for category, location or price
                    child: const Icon(Icons
                        .filter_list), //need to replace with the icon filter funnel
                  ),
                )
              ]),
              SingleChildScrollView(
                child: Container(
                  height: 24,
                  color: Color.fromARGB(255, 60, 213, 198),
                  alignment: Alignment.center,
                  child: Text(
                    "${numberofresult.toString()} Service(s) Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
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
                                loadService(1);
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth * 0.35,
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
                      ))),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //build the list for textbutton with scroll
                    if ((curpage - 1) == index) {
                      //set current page number active
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadService(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
            ]),
    );
  }

  void loadpageService(int pg) {
    curpage = pg;
    numofpage;

    http.post(Uri.parse("${Config.server}/lsm/php/load_pageService.php"),
        body: {
          "pageno": pg.toString(),
          if (widget.user.id != "na") "userid": widget.user.id
        }).then((response) {
      print(response.body);
      try {
        serviceList.clear();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            print(numberofresult);
            var extractdata = jsondata['data'];

            extractdata['service'].forEach((v) {
              serviceList.add(Service.fromJson(v));
            });

            print(serviceList[0].serviceName);
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
    http.post(Uri.parse("${Config.server}/lsm/php/load_barterService.php"),
        body: {
          "pageno": pg.toString(),
          if (widget.user.id != "na") "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      try {
        serviceList.clear();
        print(response.statusCode);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            print(numberofresult);
            var extractdata = jsondata['data'];

            extractdata['service'].forEach((v) {
              serviceList.add(Service.fromJson(v));
            });

            print(serviceList[0].serviceName);
          }
          setState(() {});
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  void filterService(String valuea, String valueb, int pg) {
    curpage = pg;
    numofpage;
    http.post(Uri.parse("${Config.server}/lsm/php/load_barterService.php"),
        body: {
          "pageno": pg.toString(),
          "category": selectedCategory,
          "type": selectedType,
          "state": state,
          "valuea": valueaEditingController.text,
          "valueb": valuebEditingController.text,
          if (widget.user.id != "na") "userid": widget.user.id,
        }).then((response) {
      print(response.body);
      serviceList.clear();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata['status']);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
          var extractdata = jsondata['data'];
          extractdata['Service'].forEach((v) {
            serviceList.add(Service.fromJson(v));
          });
          print(serviceList[0].serviceName);
        }
        setState(() {});
      }
    });
  }

  void searchService(String search, int pg) {
    curpage = pg;
    numofpage;
    http.post(Uri.parse("${Config.server}/lsm/php/load_barterService.php"),
        body: {
          "pageno": pg.toString(),
          "search": search,
          if (widget.user.id != "na") "userid": widget.user.id,
        }).then((response) {
      //print(response.body);
      serviceList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
          var extractdata = jsondata['data'];
          extractdata['Service'].forEach((v) {
            serviceList.add(Service.fromJson(v));
          });
          print(serviceList[0].serviceName);
        }
        setState(() {});
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
                        "State",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 39,
                    ),
                    Container(
                      height: 60,
                      width: 150,
                      child: DropdownButton(
                        isExpanded: true,
                        value: state,
                        onChanged: (newValue2) {
                          setState(() {
                            state = newValue2!;
                            print(state);
                          });
                        },
                        items: statelist.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(
                              state,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ]),
                ),
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 30,
                        child: Text(
                          "Category",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                      width: 10,
                    ),
                      Expanded(
                        // Wrap DropdownButton with Expanded
                        child: Container(
                          height: 60,
                          child: DropdownButton(
                            // Remove width property
                            isExpanded: true,
                            value: selectedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue.toString();
                                selectedType =
                                    ""; // Reset selected type when category changes
                              });
                            },
                            items: categoryToTypes.keys.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Row(children: [
                    const SizedBox(
                      height: 30,
                      child: Text(
                        "Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    Container(
                      height: 60,
                      width: 150,
                      child: DropdownButton(
                        isExpanded: true,
                        value: selectedType.isNotEmpty ? selectedType : null,
                        onChanged: selectedCategory.isNotEmpty
                            ? (newValue) {
                                setState(() {
                                  selectedType = newValue.toString();
                                });
                              }
                            : null,
                        items: typeList.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                    )
                  ]),
                ),
                Row(
                  children: [
                    const SizedBox(
                        height: 26,
                        child: Text(
                          "Value",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      width: 22,
                    ),
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: valueaEditingController,
                        decoration: InputDecoration(
                            hintText: "Min",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Text("  -  "),
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: valuebEditingController,
                        decoration: InputDecoration(
                            hintText: "Max",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
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
                String valuea = valueaEditingController.text.toString();
                String valueb = valuebEditingController.text.toString();
                filterService(valuea, valueb, 1);
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
