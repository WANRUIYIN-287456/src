import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_nelayan/model/user.dart';

import 'package:my_nelayan/screens/config.dart';
import 'package:my_nelayan/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//     late User user;
  
//   @override
//   void initState() {

//     super.initState();
//      checkAndLogin();
//     // Timer(
//     //             const Duration(seconds: 3),
//     //             () => Navigator.pushReplacement(
//     //                 context,
//     //                 MaterialPageRoute(
//     //                     builder: (context) => MainScreen(user: User()))));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage("assets/images/fisherman2.png"),
//                     fit: BoxFit.contain))),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 "MY NELAYAN",
//                 style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
//               ),
//               CircularProgressIndicator(),
//               Text(
//                 "Version 0.1",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               )
//             ],
//           ),
//         ),
//       ],
//     ));
//   }

//   checkAndLogin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String email = (prefs.getString('email')) ?? '';
//     String password = (prefs.getString('pass')) ?? '';
//     bool isCheck = (prefs.getBool('checkbox')) ?? false;
//     // ignore: unused_local_variable
//     //late User user;
    
//     if (isCheck) {
//       try {
//         http.post(Uri.parse("${Config.server}/MyNelayan/php/login_user.php"),
//             body: {
//               "email": email,
//               "password": password,
//             }).then((response) {
//               print(response.statusCode);
//           if (response.statusCode == 200) {
//             var jsondata = jsonDecode(response.body);
//             print(response.body);
//             user = User.fromJson(jsondata['data']);
//             Timer(
//                 const Duration(seconds: 3),
//                 () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MainScreen(user: User()))));
//           } else {
//             user = User(
//                 id: "na",
//                 name: "na",
//                 email: "na",
//                 phone: "na",
//                 datereg: "na",
//                 password: "na",
//                 otp: "na");
//                 Timer(
//                 const Duration(seconds: 3),
//                 () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MainScreen(user: User()))));
//           }
//         }).timeout(const Duration(seconds: 5), onTimeout: (){

//         });
//       } on TimeoutException catch (_) {
//         print("Timeout");
//       }
//     }else {
//                 Timer(
//                 const Duration(seconds: 3),
//                 () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MainScreen(user: User()))));
//           }
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
    //loadPref();
    // Timer(
    //     const Duration(seconds: 3),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (content) =>  MainScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash.png'),
                    fit: BoxFit.contain))),
         Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
               Text(
                "MYNELAYAN",
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              CircularProgressIndicator(),
              Text(
                "Version 0.1",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        )
      ],
    ));
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(
            Uri.parse("${Config.server}/mynelayan/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            user = User.fromJson(jsondata['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                phone: "na",
                datereg: "na",
                password: "na",
                otp: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          datereg: "na",
          password: "na",
          otp: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
