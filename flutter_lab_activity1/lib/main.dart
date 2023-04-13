import 'dart:ffi';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String operation = "Stop";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Remote Car"),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              height: 300,
              width: 350,
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                _calculate("Forward");
                              },
                              child: const Text("Forward")),
                        ),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                _calculate("Left");
                              },
                              child: const Text("Left")),
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                _calculate("Stop");
                              },
                              child: const Text("Stop")),
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                _calculate("Right");
                              },
                              child: const Text("Right")),
                        ),
                      ],
                    ),
                    
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            _calculate("Reverse");
                          },
                          child: const Text("Reverse")),
                    ),
                  ],
                ),
              ),
            ),
            Text("\n" + operation,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _calculate(String op) {
    setState(() {
      switch (op) {
        case "Left":
          operation = "Left";
          break;
        case "Stop":
          operation = "Stop";
          break;
        case "Right":
          operation = "Right";
          break;
        case "Reverse":
          operation = "Reverse";
          break;
        case "Forward":
          operation = "Forward";
          break;
      }
    });
  }
}
