// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
// import 'package:http/http.dart' as http;
// import 'package:local_service_marketplace/a3_login.dart';
// import 'package:local_service_marketplace/config.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }
// // add notification for new order seller
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final TextEditingController _nameEditingController = TextEditingController();
//   final TextEditingController _phoneEditingController = TextEditingController();
//   final TextEditingController _emailEditingController = TextEditingController();
//   final TextEditingController _passEditingController = TextEditingController();
//   final TextEditingController _pass2EditingController = TextEditingController();
//   bool _isChecked = false;
//   bool _isTap = false;
//   final _formKey = GlobalKey<FormState>();
//   late double screenHeight, screenWidth, cardwidth;
//   String eula = "";
//   late String _imageString;

//   @override
//   void initState() {
//     super.initState();
//     loadEula();
//     _getImageString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text("User Registration"),
//           backgroundColor: Colors.transparent,
//           foregroundColor: Theme.of(context).colorScheme.secondary,
//           elevation: 0),
//       body: SingleChildScrollView(
//           child: Column(
//         children: [
//           SizedBox(
//             height: screenHeight * 0.15,
//             width: screenWidth,
//             child: Image.asset(
//               "assets/images/register2.png",
//               fit: BoxFit.contain,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//             child: Card(
//               elevation: 8,
//               child: Container(
//                   margin: const EdgeInsets.fromLTRB(16, 12, 16, 2),
//                   child: Column(
//                     children: [
//                       const Text("Registration Form"),
//                       Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               TextFormField(
//                                 controller: _nameEditingController,
//                                 validator: (val) =>
//                                     val!.isEmpty || (val.length < 5)
//                                         ? "name must be longer than 5"
//                                         : null,
//                                 keyboardType: TextInputType.text,
//                                 decoration: const InputDecoration(
//                                     labelText: "Name",
//                                     labelStyle: TextStyle(),
//                                     icon: Icon(Icons.person),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 2.0),
//                                     )),
//                               ),
//                               TextFormField(
//                                 controller: _phoneEditingController,
//                                 validator: (val) => val!.isEmpty ||
//                                         (val.length < 10)
//                                     ? "phone number must contain at least 10 digits"
//                                     : null,
//                                 keyboardType: TextInputType.number,
//                                 decoration: const InputDecoration(
//                                     labelText: "Phone",
//                                     labelStyle: TextStyle(),
//                                     icon: Icon(Icons.phone),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 2.0),
//                                     )),
//                               ),
//                               TextFormField(
//                                 controller: _emailEditingController,
//                                 validator: (val) => val!.isEmpty ||
//                                         !val.contains("@") ||
//                                         !val.contains(".")
//                                     ? "enter a valid email"
//                                     : null,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: const InputDecoration(
//                                     labelText: "Email",
//                                     labelStyle: TextStyle(),
//                                     icon: Icon(Icons.email),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 2.0),
//                                     )),
//                               ),
//                               TextFormField(
//                                 controller: _passEditingController,
//                                 obscureText: true,
//                                 validator: (val) => val!.isEmpty ||
//                                         (val.length < 6)
//                                     ? "password length must be at least 6 characters"
//                                     : null,
//                                 decoration: const InputDecoration(
//                                     labelText: "Password",
//                                     labelStyle: TextStyle(),
//                                     icon: Icon(Icons.lock),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 2.0),
//                                     )),
//                               ),
//                               TextFormField(
//                                 controller: _pass2EditingController,
//                                 obscureText: true,
//                                 validator: (val) => val!.isEmpty ||
//                                         (val.length < 6)
//                                     ? "password length must be at least 6 characters"
//                                     : null,
//                                 decoration: const InputDecoration(
//                                     labelText: "Re-enter password",
//                                     labelStyle: TextStyle(),
//                                     icon: Icon(Icons.lock),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 2.0),
//                                     )),
//                               ),
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: (){
//                                       showEula();
//                                       _isTap = true;
//                                     },
//                                     child: const Text('Agree with terms',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         )),
//                                   ),
//                                    Checkbox(
//                                       value: _isChecked,
//                                       onChanged: (bool? value) {
//                                         if (_isTap == false){
//                                           showEula();
//                                         }
//                                         if (!_isChecked) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(const SnackBar(
//                                                   content: Text(
//                                                       "Terms have been read and accepted.")));
//                                         }
//                                         setState(() {
//                                           _isChecked = value!;
//                                         });
//                                       }),
//                                   const SizedBox(
//                                     width: 16,
//                                   ),
//                                   Expanded(
//                                     child: ElevatedButton(
//                                         onPressed: onRegisterDialog,
//                                         child: const Text("Register")),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )),
//                     ],
//                   )),
//             ),
//           ),
//           const SizedBox(height: 2),
//           GestureDetector(
//             onTap: _goLogin,
//             child: const Text(
//               "Already registered? Login",
//               style: TextStyle(fontSize: 18),
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       )),
//     );
//   }

//   void onRegisterDialog() {
//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Check your input")));
//       return;
//     }
//     if (!_isChecked) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("Please agree with terms and conditions")));
//       return;
//     }
//     String pass1 = _passEditingController.text;
//     String pass2 = _pass2EditingController.text;

//     if (pass1 != pass2) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("Please check your password and try again")));
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: const Text(
//             "Register new account?",
//             style: TextStyle(),
//           ),
//           content: const Text("Are you sure?", style: TextStyle()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 "Yes",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 registerUser();
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 "No",
//                 style: TextStyle(),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void registerUser() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return const AlertDialog(
//           title: Text("Please Wait"),
//           content: Text("Loading..."),
//         );
//       },
//     );
//     String name = _nameEditingController.text;
//     String email = _emailEditingController.text;
//     String phone = _phoneEditingController.text;
//     String pass1 = _passEditingController.text;
//     String base64Image1 = _imageString;
//     http.post(Uri.parse("${Config.server}/lsm/php/register_user.php"),
//         body: {
//           "name": name,
//           "email": email,
//           "phone": phone,
//           "password": pass1,
//           "image": base64Image1
//         }).then((response) {
//       print(response.body);
//       try {
//         print(response.statusCode);
//         if (response.statusCode == 200) {
//           print(response.body);
//           var jsondata = jsonDecode(response.body);
//           if (jsondata['status'] == 'success') {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Registration Success")));
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => const LoginScreen()));
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Registration Failed")));
//             print(1);
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Registration Failed")));
//           print(2);
//         }
//       } catch (e, _) {
//         debugPrint(e.toString());
//       }
//     });
//   }

//   void _goLogin() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const LoginScreen()));
//   }

//   loadEula() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     eula = await rootBundle.loadString('assets/images/eula.txt');
//   }

//   showEula() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             "EULA",
//             style: TextStyle(),
//           ),
//           content: SizedBox(
//             height: 300,
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                   flex: 1,
//                   child: SingleChildScrollView(
//                       child: RichText(
//                     softWrap: true,
//                     textAlign: TextAlign.justify,
//                     text: TextSpan(
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 12.0,
//                         ),
//                         text: eula),
//                   )),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 "Close",
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//    _getImageString() async {
//     final ByteData imageData = await rootBundle.load('assets/images/profile.png');
//     final Uint8List bytes = imageData.buffer.asUint8List();
//     _imageString = base64Encode(bytes);

//   }

// }

import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:http/http.dart' as http;
import 'package:local_service_marketplace/a3_login.dart';
import 'package:local_service_marketplace/config.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final TextEditingController _otpEditingController = TextEditingController();
  final TextEditingController _otp2EditingController = TextEditingController();
  final TextEditingController _newpassEditingController =
      TextEditingController();
  final TextEditingController _forgotPasswordEmailController =
      TextEditingController(); // Added for forgot password
  bool _isChecked = false;
  bool _isTap = false;
  bool _isResendEnabled = false;
  bool isRegistered = false;
  bool isExist = true;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwidth;
  String eula = "";
  late String _imageString;
  String _otp = '';

  @override
  void initState() {
    super.initState();
    loadEula();
    _getImageString();
  }

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
            SizedBox(
              height: screenHeight * 0.13,
              width: screenWidth,
              child: Image.asset(
                "assets/images/register2.png",
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Card(
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Column(
                    children: [
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
                              onFieldSubmitted: (value) {
                                isRegistered = false;
                                verifyEmailExist(value);
                              },
                            ),
                            Container(
                              child: isRegistered
                                  ? Text(
                                      "Email already registered. Please login",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12))
                                  : null,
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
                            // TextFormField(
                            //   controller: _otpEditingController,
                            //   keyboardType: TextInputType.number,
                            //   validator: (val) =>
                            //       val!.isEmpty ? "Please enter OTP" : null,
                            //   decoration: const InputDecoration(
                            //       labelText: "OTP",
                            //       labelStyle: TextStyle(),
                            //       icon: Icon(Icons.security),
                            //       focusedBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(width: 2.0),
                            //       )),
                            // ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showEula();
                                    _isTap = true;
                                  },
                                  child: const Text('Agree with terms',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      if (_isTap == false) {
                                        showEula();
                                      }
                                      if (!_isChecked) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Terms have been read and accepted.")));
                                      }
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    }),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        sendOTP();
                                        onRegisterDialog();
                                      },
                                      child: const Text("Register")),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _goLogin,
              child: const Text(
                "Already registered? Login",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              // Added for Forgot Password
              onTap: () {
                _forgotPassword();
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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
            "Otp verification",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: 100, // Set a minimum height for content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _otpEditingController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    icon: Icon(Icons.security),
                    hintText: 'Enter otp',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (v) {
                    String enteredOTP = _otpEditingController.text;
                    if (enteredOTP != _otp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid OTP")));
                      _otpEditingController.clear();
                      return;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("OTP Correct.")));
                    }
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: _isResendEnabled ? onResendOTP : null,
                  child: const Text("Resend OTP"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Ok",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
            ),
          ],
        );
      },
    );
  }

  void onResendOTP() {
    sendOTP();
  }

  void sendOTP() {
    _otp = generateOTP();
    print("email: " + _emailEditingController.text + "otp: " + _otp);
    http.post(Uri.parse("https://labassign2.nwarz.com/lsm/php/send_otp.php"),
        body: {
          "email": _emailEditingController.text,
          "otp": _otp,
          "name": _nameEditingController.text
        }).then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent to your email")));
        setState(() {
          _isResendEnabled = false;
        });
        Timer(Duration(seconds: 60), () {
          setState(() {
            _isResendEnabled = true;
          });
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to send OTP")));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occurred while sending OTP")));
    });
  }

  void sendOTP2() {
    _otp = generateOTP();
    print("email: " + _forgotPasswordEmailController.text + "otp: " + _otp);
    http.post(Uri.parse("https://labassign2.nwarz.com/lsm/php/send_otp.php"),
        body: {
          "email": _forgotPasswordEmailController.text,
          "otp": _otp,
          "name": "User"
        }).then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent to your email")));
        setState(() {
          _isResendEnabled = false;
        });
        Timer(Duration(seconds: 60), () {
          setState(() {
            _isResendEnabled = true;
          });
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to send OTP")));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occurred while sending OTP")));
    });
  }

  String generateOTP() {
    return (10000 + Random().nextInt(90000)).toString();
  }

  void registerUser() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String pass1 = _passEditingController.text;
    String base64Image1 = _imageString;
    http.post(Uri.parse("${Config.server}/lsm/php/register_user.php"), body: {
      "name": name,
      "email": email,
      "phone": phone,
      "password": pass1,
      "image": base64Image1
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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void loadEula() async {
    WidgetsFlutterBinding.ensureInitialized();
    eula = await rootBundle.loadString('assets/images/eula.txt');
  }

  void showEula() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void verifyEmailExist(String email) {
    http.post(
        Uri.parse("https://labassign2.nwarz.com/lsm/php/verify_emailexist.php"),
        body: {"email": email}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            isRegistered = true;
            _emailEditingController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Email already registered")));
        }
      }
    }).catchError((error) {
      print("Error occurred while verifying email existence: $error");
    });
  }

  void verifyEmailExist2(String email) {
    http.post(
        Uri.parse("https://labassign2.nwarz.com/lsm/php/verify_emailexist.php"),
        body: {"email": email}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          sendOTP2();
          print("email: " + email + "otp: " + _otp);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Email exist")));
        } else {
          setState(() {
            isExist = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Email is not registered yet.")));
        }
      }
    }).catchError((error) {
      print("Error occurred while verifying email existence: $error");
    });
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Forgot Password",
            style: TextStyle(),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Press 'Enter' after filling the text field.",
                    style: TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 12
                    ),
                  ),
                  TextFormField(
                    controller: _forgotPasswordEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.email),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        )),
                    onFieldSubmitted: (value) {
                      isExist = true;
                      verifyEmailExist2(_forgotPasswordEmailController.text);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _otp2EditingController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            icon: Icon(Icons.security),
                            hintText: 'Enter otp',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          onSubmitted: (v) {
                            String enteredOTP = _otp2EditingController.text;
                            if (enteredOTP != _otp) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid OTP")));
                              _otp2EditingController.clear();
                              return;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Correct OTP")));
                            }
                          },
                        ),
                      ),
                      Container(
                        child: isExist
                            ? null
                            : Text(
                                "Account not registered yet. Please register a new account.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 10)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: _isResendEnabled ? sendOTP2 : null,
                          child: const Text("Resend")),
                    ],
                  ),
                  TextField(
                    controller: _newpassEditingController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Enter new password',
                      icon: Icon(Icons.lock),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (v) {},
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Submit",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.pop(context);
                sendForgotPasswordRequest();
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
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

  void sendForgotPasswordRequest() {
    String email = _forgotPasswordEmailController.text;
    String newpass = _newpassEditingController.text;
    print("email: " + email + " newpass: " + newpass);
    http.post(
        Uri.parse("https://labassign2.nwarz.com/lsm/php/forgot_password.php"),
        body: {
          "email": email,
          "newpass": newpass,
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password reset successful")));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password reset failed")));
        }
      }
    }).catchError((error) {
      print("Error occurred while sending forgot password request: $error");
    });
  }

  _getImageString() async {
    final ByteData imageData =
        await rootBundle.load('assets/images/profile.png');
    final Uint8List bytes = imageData.buffer.asUint8List();
    _imageString = base64Encode(bytes);
  }
}
