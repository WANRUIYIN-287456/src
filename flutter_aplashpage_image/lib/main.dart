import 'dart:async';
import 'package:flutter/material.dart';
import 'bmicalc.dart/test.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     theme: ThemeData(primarySwatch: Colors.amber),
     home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
void initState(){
  super.initState();
  Timer(const Duration(seconds: 3),
   ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SPage())));
  }

@override
Widget build(BuildContext context){
  return Scaffold(
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 5,
        child: Image.asset(
          "asssets/images/opi.jpg", scale: 0.5,
        ),
      ),
        const Text("BMI Calculator", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
      ],
      )
    )
  );
}
}