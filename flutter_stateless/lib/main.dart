import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String test = "Flutter is fun.";
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hello World!"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome to Flutter!",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      backgroundColor: Colors.amberAccent)),
              const Text("Hello World!"),
              Text(test),
              const Text("Flutter is fun!"),
              ElevatedButton(onPressed:(){
                test = _pressMe(test);},
               child: const Text ("Press Me"),
              )
            ],
          ),
        ));
  }

  String _pressMe(String test) {
    test = "Hello World!";
    print("Hello World!");
    return test;
   setState(() {});
  }
}
