import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_service_marketplace/a3_login.dart';
import 'package:local_service_marketplace/a9_1_adminmainscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'dart:convert';

import 'package:local_service_marketplace/model/admin.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
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
        title: const Text("Admin Login"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize:
                MainAxisSize.min, // Align children at the center horizontally
            children: [

              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.blue),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (content) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "User Login",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
                            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 70, 0),
                child: SizedBox(
                  height: screenHeight * 0.30,
                  width: screenWidth * 0.62,
                  child: Image.asset(
                    "assets/images/adminlogin.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(children: [
                  const Text("Admin Login Form"),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _nameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.abc),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                      ),
                      TextFormField(
                        controller: _passEditingController,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                              MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: screenWidth / 3,
                            height: 50,
                            elevation: 10,
                            onPressed: onLogin,
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onError,
                            child: const Text('Admin Login'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String _name = _nameEditingController.text;
    String _password = _passEditingController.text;
    http.post(Uri.parse("${Config.server}/lsm/php/login_admin.php"), body: {
      "name": _name,
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
            late Admin admin;
            admin = Admin.fromJson(jsondata['data']);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => AdminMainScreen(admin: admin)));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Failed")));
            print(1);
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Failed")));
          print(2);
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

}