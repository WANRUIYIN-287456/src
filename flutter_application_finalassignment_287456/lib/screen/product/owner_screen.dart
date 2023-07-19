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
  final User user;
  final String productUserId;
  const UserProfileScreen(
      {super.key, required this.user, required this.productUserId});

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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: screenWidth * 0.4,
                  child: CachedNetworkImage(
                      imageUrl:
                          "${Config.server}/LabAssign2/assets/images/profile/${widget.productUserId}.png?",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(
                            "${Config.server}/LabAssign2/assets/images/profile/0.png",
                            scale: 2,
                          )),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            user.name.toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Divider(),
                          Text(user.email.toString()),
                          Text(user.phone.toString()),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
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
                            user: widget.user, productuserID: widget.productUserId.toString() )));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(90, 40, 40, 20),
                child: Row(children: const [
                  Icon(Icons.shopping_bag),
                  SizedBox(width: 15),
                  Text("More from this user"),
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(52, 10, 100, 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.message),
                      SizedBox(width: 15),
                      Text("Message"),
                    ]),
              ),
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
    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_user.php"),
        body: {
          "userid": widget.productUserId,
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
