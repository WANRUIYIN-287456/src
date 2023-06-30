import 'package:checkin_project/config.dart';
import 'package:checkin_project/login_screen.dart';
import 'package:checkin_project/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetScreen extends StatefulWidget {
  final User user;
  const ResetScreen({super.key, required this.user});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, csrdwidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Reset"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: screenHeight * 0.30,
            width: screenWidth,
            child: Image.asset(
              "assets/images/register2.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(children: [
                  const Text("Reset Password Form"),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _emailEditingController,
                        enabled: false,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "enter a valid email"
                            : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.email),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                      ),
                      TextFormField(
                        controller: _passEditingController,
                        enabled: true,
                        obscureText: true,
                        validator: (val) => val!.isEmpty || (val.length < 6)
                            ? "password length must be at least 6 characters"
                            : null,
                        decoration: const InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.lock),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                      ),
                      const SizedBox(height: 16),
                    ]),
                  )
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void onReset() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String _email = _emailEditingController.text;
    String _password = _passEditingController.text;
    http.post(Uri.parse("${Config.server}/OSProject/php/reset_user.php"),
        body: {
          "email": _email,
          "password": _password,
        }).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          //print(jsondata['data']);
          if (jsondata['status'] == 'success') {
            late User user;
            user = User.fromJson(jsondata['data']);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Reset Success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => LoginScreen(user: user)));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Reset Failed")));
            print(1);
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Reset Failed")));
          print(2);
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }


}
