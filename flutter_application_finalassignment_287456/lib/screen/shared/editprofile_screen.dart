import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.user.name.toString();
    _phoneEditingController.text = widget.user.phone.toString();
    _emailEditingController.text = widget.user.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Column(children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                                controller: _nameEditingController,
                                enabled: true,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 5)
                                        ? "name must be longer than 5"
                                        : null,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: "Name",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.person),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )),
                              ),
                              TextFormField(
                                controller: _phoneEditingController,
                                enabled: true,
                                validator: (val) => val!.isEmpty ||
                                        (val.length < 10)
                                    ? "phone number must contain at least 10 digits"
                                    : null,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: "Phone",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.phone),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )),
                              ),
                              TextFormField(
                                controller: _emailEditingController,
                                enabled: true,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.email),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )),
                              ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            onEditDialog();
                          },
                          child: const Text("Update profile")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

 void onEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update your profile?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateprofile();
                //registerUser();
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

 void updateprofile() {
  String name = _nameEditingController.text;
    String phone = _phoneEditingController.text;
    String email = _emailEditingController.text;


    http.post(Uri.parse("${Config.server}/LabAssign2/php/update_profile.php"),
        body: {
         "userid": widget.user.id.toString(),
          "username": name,
          "userphone": phone,
          "useremail": email,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          //  Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (content) => ProfileTabScreen(
          //                       user: widget.user,
          //                     )));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }
}
