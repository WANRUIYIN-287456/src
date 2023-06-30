import 'package:checkin_project/config.dart';
import 'package:checkin_project/registration_screen.dart';
import 'package:checkin_project/reset_screen.dart';
import 'package:checkin_project/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final User user;
  const LoginScreen({super.key, required this.user});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _otpEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, csrdwidth;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Login"),
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
                  const Text("Login Form"),
                  Form(
                    key: _formKey,
                    child: Column(children: [
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
                          Checkbox(
                            //checkColor: Colors.white,
                            //activeColor: Colors.red,
                            value: _isChecked,
                            onChanged: (bool? value) {
                              saveremovepref(value!);
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: null,
                              child: const Text('Remember Me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: screenWidth / 3,
                            height: 50,
                            elevation: 10,
                            onPressed: onLogin,
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onError,
                            child: const Text('Login'),
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
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: _goToRegister,
            child: const Text(
              "New account?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              otpDialog();
            },
            child: const Text(
              "Forgot password?",
              style: TextStyle(
                fontSize: 18,
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
    String _email = _emailEditingController.text;
    String _password = _passEditingController.text;
    http.post(Uri.parse("${Config.server}/OSProject/php/login_user.php"),
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
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: user)));
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

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
      });
    }
  }

  void _goToRegister() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrationScreen(user: widget.user)));
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('checkbox', value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  Future<void> sendEmail() async {
    //final smtpServer = gmailSaslXoauth2('checkina2044@gmail.com', 'xqijtfbhclwbkycf');
    final smtpServer =
        gmailSaslXoauth2('wanruiyin1p10@gmail.com', 'AHL8288AFS4012');
    final message = Message()
      ..from = const Address('wanruiyin1p10@gmail.com', 'Check-in ')
      ..recipients.add(widget.user.email)
      ..subject = 'OTP Verification'
      ..text = 'Your OTP for Check-in is ${widget.user.otp}';
    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print(e.toString());
    }
  }

  void otpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Reset Password",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(
                        height: 26,
                        child: Text(
                          "OTP",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      width: 22,
                    ),
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: _otpEditingController,
                        decoration: InputDecoration(
                            hintText: "Otp",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          sendEmail();
                        },
                        child: const Text("Request OTP")),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_otpEditingController.text ==
                          widget.user.otp.toString()) {
                        Navigator.of(context).pop();
                        _goToReset();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Invalid OTP! Please try again.")));
                      }
                    },
                    child: const Text("submit")),
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
                child: const Text("Close"
                    //style: TextStyle(),
                    ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  void _goToReset() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResetScreen(user: widget.user)));
  }
}
