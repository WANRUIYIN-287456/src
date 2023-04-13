import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _value = "nothing...";
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Enter your text below",
              ),
              TextField(
                controller: textEditingController,
              ),
              ElevatedButton(
                  onPressed: _pressMe, child: const Text("Press Me")),
              Text("You Entered: $_value"),
            ]),
          ),
        ),
      ),
    );
  }

  void _pressMe() {
// ignore: avoid_print
    _value = textEditingController.text;
    print(_value);
    setState(() {});
  }
}
