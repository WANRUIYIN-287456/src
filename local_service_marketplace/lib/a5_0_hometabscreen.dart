import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_service_marketplace/a5_1_userservicedetails.dart';
import 'package:local_service_marketplace/a5_6_userorderlistscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'package:local_service_marketplace/model/seller.dart';

class HomeTabScreen extends StatefulWidget {
  final User user;
  const HomeTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
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
    // Add other categories and their types here
  };
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

  @override
  void initState() {
    super.initState();
   loadpageService(1);
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
          //use cart icon button?
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("My Order"),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                if (widget.user.id.toString() == "na") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account"),
                  ));
                  return;
                }
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (content) => UserOrderScreen(user: widget.user),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
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
              child: serviceList.isEmpty
                  ? Center(child: Text("No Data"))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 24,
                          color: Color.fromARGB(255, 60, 213, 198),
                          alignment: Alignment.center,
                          child: Text(
                            "${numberofresult.toString()} Service(s) Found",
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
                              serviceList.length,
                              (index) {
                                return Card(
                                  child: InkWell(
                                    onTap: () async {
                                      Service service = serviceList[index];
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (content) =>
                                              ServiceDetailScreen(
                                            user: widget.user,
                                            service: service,
                                          ),
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
                                              if (serviceList[index].proStatus ==
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
                                              if (serviceList[index]
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
                                          serviceList[index]
                                              .serviceName
                                              .toString(),
                                          style: const TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "RM ${double.parse(serviceList[index].servicePrice.toString()).toStringAsFixed(2)}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "per ${serviceList[index].serviceUnit}",
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
      ),
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
          extractdata['service'].forEach((v) {
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
          extractdata['service'].forEach((v) {
            serviceList.add(Service.fromJson(v));
          });
          print(serviceList[0].serviceName);
        }
        setState(() {});
      }
    });
  }

void filterDialog() {
  selectedCategory = "All Categories"; // Reset selected category
  selectedType = "All Types"; // Reset selected type
  
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
                                  categoryToTypes[selectedCategory]![0]; // Set selected type to the first type of the selected category
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
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedType = newValue!;
                        });
                      },
                      items: categoryToTypes[selectedCategory]!.map((type) {
                        return DropdownMenuItem<String>(
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
              valueaEditingController.clear();
              valuebEditingController.clear();
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
