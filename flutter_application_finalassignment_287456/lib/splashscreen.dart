import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/shared/main_screen.dart';
import 'package:flutter_application_finalassignment_287456/screen/shared/registration_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/splash.png"),
                      fit: BoxFit.contain))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Barterit",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              CircularProgressIndicator(),
              Text(
                "Version 0.1",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
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
      print("checked");
    http.post(Uri.parse("${Config.server}/LabAssign2/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          //print(jsondata['data']);
          if (jsondata['status'] == 'success') {
           var jsondata = jsonDecode(response.body);
            user = User.fromJson(jsondata['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          } else {
             print("1");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const RegistrationScreen())));
          }
        } else {
            print("2");
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
      } on TimeoutException catch (_) {
        print("Time out");
      }catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }else {
            print("2");
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
  }

  // checkAndLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = (prefs.getString('email')) ?? '';
  //   String password = (prefs.getString('pass')) ?? '';
  //   bool ischeck = (prefs.getBool('checkbox')) ?? false;
  //   late User user;
  //   if (ischeck) {
  //     print("checked");
  //     try {
  //       http.post(Uri.parse("${Config.server}/LabAssign2/php/login_user.php"),
  //           body: {"email": email, "password": password}).then((response) {
  //             print(response.body);
  //             print(response.statusCode);
  //         if (response.statusCode == 200) {
  //           var jsondata = jsonDecode(response.body);
  //           user = User.fromJson(jsondata['data']);
  //           Timer(
  //               const Duration(seconds: 3),
  //               () => Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (content) => MainScreen(user: user))));
  //         } else {
  //           print("1");
  //           Timer(
  //               const Duration(seconds: 3),
  //               () => Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (content) => const RegistrationScreen())));
  //         }
  //       }).timeout(const Duration(seconds: 5), onTimeout: () {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text("Connection Timeout.")));
  //       });
  //     } on TimeoutException catch (_) {
  //       print("Time out");
  //     }
  //     catch (e, _) {
  //       debugPrint(e.toString());
  //     }
  //   } else {
  //     print("2");
  //     user = User(
  //         id: "na",
  //         name: "na",
  //         email: "na",
  //         phone: "na",
  //         datereg: "na",
  //         password: "na",
  //         otp: "na");
  //     Timer(
  //         const Duration(seconds: 3),
  //         () => Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (content) => MainScreen(user: user))));
  //   }
  // }
}