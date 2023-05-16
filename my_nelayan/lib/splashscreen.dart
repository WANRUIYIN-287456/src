import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_nelayan/model/user.dart';
import 'package:my_nelayan/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen(user: User()))));
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
                    image: AssetImage("assets/images/fisherman2.png"),
                    fit: BoxFit.contain))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "MY NELAYAN",
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
}
