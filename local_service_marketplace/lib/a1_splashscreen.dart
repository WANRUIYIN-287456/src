import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a2_register.dart';
import 'package:local_service_marketplace/a4_mainscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/user.dart';
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
                "Welcome to LSM",
                style: TextStyle(fontSize: 30, color: Colors.blueGrey),
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
    http.post(Uri.parse("${Config.server}/lsm/php/login_user.php"),
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
          //    print("1");
          //   Timer(
          //       const Duration(seconds: 3),
          //       () => Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //               builder: (content) => const RegistrationScreen())));
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
}