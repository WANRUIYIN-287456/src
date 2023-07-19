import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/product.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/barter/bartermore_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/message_screen.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  final Product product;
  final User user;
  const UserProfileScreen(
      {super.key, required this.user, required this.product});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Product> productList = <Product>[];
  int numberofresult = 0;
  late double screenHeight, screenWidth, cardwitdh;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");
  late Product product;
  @override
  void initState() {
    super.initState();

    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(2),
          height: screenHeight * 0.25,
          width: screenWidth,
          child: Card(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  width: screenWidth * 0.92,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        "${Config.server}/LabAssign2/assets/images/profile/${widget.product.userId}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 6),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(widget.user.email.toString()),
                        //Text(widget.user.phone.toString()),
                      ],
                    ),
                  )),
            ]),
          ),
        ),
        Container(
          width: screenWidth,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
            child: Text("User Options",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
//RATING
        Expanded(
            child: ListView(
          children: [
            MaterialButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => BarterMoreScreen(
                            user: widget.user, product: product)));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(120, 20, 80, 0),
                child: Row(children: const [
                  Icon(Icons.shopping_bag),
                  SizedBox(width: 15),
                  Text("More Products from the user"),
                ]),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const MessageTabScreen()));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(width: 15),
                    Text("Message"),
                  ]),
            ),
          ],
        ))
      ]),
    );
  }

  // void loadUserItems() {
  //   http.post(Uri.parse("${Config.server}/LabAssign2/php/load_singleproduct.php"),
  //       body: {
  //         "userid": widget.product.userId,
  //       }).then((response) {
  //     //print(response.body);
  //     //log(response.body);
  //     if (response.statusCode == 200) {
  //       var jsondata = jsonDecode(response.body);
  //       if (jsondata['status'] == "success") {
  //         product = Product.fromJson(jsondata['data']);
  //       }
  //       setState(() {});
  //     }
  //   });
  // }

  void loadUser() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_user.php"), body: {
      "userid": widget.product.userId,
    }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }
}
