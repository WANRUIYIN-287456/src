import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_labassignment2_287456/config.dart';
import 'package:flutter_application_labassignment2_287456/login_screen.dart';
import 'package:http/http.dart' as http;


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text("User Registration"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: screenHeight * 0.21,
            width: screenWidth,
            child: Image.asset(
              "assets/images/register2.png",
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text("Registration Form"),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameEditingController,
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
                                obscureText: true,
                                validator: (val) => val!.isEmpty ||
                                        (val.length < 6)
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
                              TextFormField(
                                controller: _pass2EditingController,
                                obscureText: true,
                                validator: (val) => val!.isEmpty ||
                                        (val.length < 6)
                                    ? "password length must be at least 6 characters"
                                    : null,
                                decoration: const InputDecoration(
                                    labelText: "Re-enter password",
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.lock),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? value) {
                                        if(!_isChecked) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Terms have been read and accepted."))
                                          );}
                                        setState(() {
                                          _isChecked = value!;
                                        });
                                      }),
                                  GestureDetector(
                                    onTap: null,
                                    child: const Text('Agree with terms',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: onRegisterDialog,
                                        child: const Text("Register")),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(onTap: _goLogin,
          child: const Text("Already registered? Login",
          style: TextStyle(fontSize: 18),
          ),
          ),
          const SizedBox(height: 16),
        ],
      )),
    );
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please agree with terms and conditions")));
      return;
    }
    String pass1 = _passEditingController.text;
    String pass2 = _pass2EditingController.text;

    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please check your password and try again")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Register new account?",
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
                registerUser();
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

  void registerUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Loading..."),
        );
      },
    );

    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String pass1 = _passEditingController.text;

    http.post(Uri.parse("${Config.server}/LabAssign2/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": pass1,
        }).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
           print(response.body);
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration Success")));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration Failed")));
            print(1);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
          print(2);
     
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }
  void _goLogin() {
  Navigator.push(
           context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
  }