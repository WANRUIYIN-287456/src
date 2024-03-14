import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a3_login.dart';
import 'package:local_service_marketplace/a8_1_editprofilescreen.dart';
import 'package:local_service_marketplace/a8_2_favouritescreen.dart';
import 'package:local_service_marketplace/a8_3_historyscreen.dart';
import 'package:local_service_marketplace/a8_4_settingscreen.dart';
import 'package:local_service_marketplace/a8_5_messagescreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/user.dart';

class AccountTabScreen extends StatefulWidget {
  final User user;
  const AccountTabScreen({super.key, required this.user});

  @override
  State<AccountTabScreen> createState() => _AccountTabScreenState();
}

class _AccountTabScreenState extends State<AccountTabScreen> {
  late var _updatedImageUrl = "";
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late List<Widget> tabchildren;
  String maintitle = "Account";
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  bool isDisable = false;
  double userid = 0;
  // late String _updatedImageUrl;
  Random random = Random();
  var val = 50;

  @override
  void initState() {
    super.initState();
    print(maintitle);
    loadProfile();
    print(widget.user.id);
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    loadProfile();
    if (widget.user.name.toString() != "na") {
      isDisable = false;
    } else if (widget.user.name.toString() == "na") {
      isDisable = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          Row(
            children: [    
             SizedBox(width: 58,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const SettingScreen()));
                },
                child: Row(
                    children: const [
                      Icon(Icons.settings, color: Colors.white54),
                      SizedBox(width: 2),
                    ]),
              ),),
              SizedBox(width: 58,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const MessageScreen()));
                },
                child: Row(
                    children: const [
                      Icon(Icons.message, color: Colors.white54),
                      SizedBox(width: 2),
                    ]),
              ),),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: isDisable
                        ? null
                        : () {
                            _editProfile();
                            loadProfile();
                          },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: screenWidth * 0.3,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${Config.server}/lsm/assets/images/profile/${widget.user.id}.png?v=$val",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) => Image.network(
                          "${Config.server}/lsm/assets/images/profile/0.png",
                          scale: 2,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.user.name.toString() == "na"
                            ? Column(
                                children: const [
                                  Text(""),
                                  Text(
                                    "Not Available",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Divider(),
                                  Text("Not Available"),
                                  Text("Not Available"),
                                  Text("Not Available"),
                                  Text(""),
                                ],
                              )
                            : Column(
                                children: [
                                  const Text(""),
                                  Text(
                                    widget.user.name.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const Divider(),
                                  Text(widget.user.email.toString()),
                                  Text(widget.user.phone.toString()),
                                  Text(df.format(DateTime.parse(
                                      widget.user.datereg.toString()))),
                                  const Text(""),
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.background,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text("PROFILE SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Column(
            children: [
              isDisable
                  ? Column(
                      children: [
                        const Text(
                          "Please login to explore more.",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => const LoginScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(95, 20, 50, 0),
                            child: Row(children: const [
                              Icon(Icons.login),
                              SizedBox(width: 15),
                              Text("Login"),
                            ]),
                          ),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) =>
                                        const FavouriteScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(95, 20, 50, 0),
                            child: Row(children: const [
                              Icon(Icons.favorite),
                              SizedBox(width: 15),
                              Text("My Favourites"),
                            ]),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) =>
                                        const HistoryScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(95, 20, 50, 0),
                            child: Row(children: const [
                              Icon(Icons.history),
                              SizedBox(width: 15),
                              Text("Booking History"),
                            ]),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _changePassDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(95, 20, 50, 0),
                            child: Row(children: const [
                              Icon(Icons.password),
                              SizedBox(width: 15),
                              Text("Edit Password"),
                            ]),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => const LoginScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(95, 20, 50, 0),
                            child: Row(children: const [
                              Icon(Icons.logout),
                              SizedBox(width: 15),
                              Text("Logout"),
                            ]),
                          ),
                        ),
                      ],
                    )),
            ],
          ))
        ]),
      ),
    );
  }

  void loadProfile() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_profile.php"), body: {
      if (widget.user.id != "na") "userid": widget.user.id,
    }).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          //print(jsondata['data']);
          if (jsondata['status'] == 'success') {
            var extractdata = jsondata['data'];
            setState(() {
              widget.user.name = extractdata['name'];
              widget.user.email = extractdata['email'];
              widget.user.phone = extractdata['phone'];
              widget.user.datereg = extractdata['datereg'];
              val = random.nextInt(1000);
            });
          } else {
            print(1);
          }
        } else {
          print(2);
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  Future<void> _editProfile() async {
    if (widget.user.id == "na") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login to your account.")));
      return;
    }

    // Navigate to EditProfileScreen and wait for result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => EditProfileScreen(user: widget.user)));

    // Check if profile details were updated in EditProfileScreen
    if (result != null && result) {
      // Reload profile details if updated
      loadProfile();
      setState(() {
        _updatedImageUrl =
            "${Config.server}/lsm/assets/images/profile/${widget.user.id}.png?v=$val";
      });
    }
  }

  void _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Password?",
            style: TextStyle(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _oldpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _newpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
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

  void changePass() {
    http.post(Uri.parse("${Config.server}/lsm/php/update_password.php"), body: {
      "userid": widget.user.id,
      "oldpass": _oldpasswordController.text,
      "newpass": _newpasswordController.text,
    }).then((response) {
      print(response.body);
      print(response.statusCode);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Success.")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        ;
      }
    });
  }
}
