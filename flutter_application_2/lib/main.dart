import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  double numa = 0, numb = 0, result = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Material App Bar"),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("\nSimple Calculator ",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      )),
                  const Text("\nEnter your two numbers \n"),
                  TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        hintText: "First number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    keyboardType: const TextInputType.numberWithOptions(),
                  ),
                  TextField(
                    controller: textEditingController2,
                    decoration: InputDecoration(
                        hintText: "Second number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    keyboardType: const TextInputType.numberWithOptions(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _calculate("+");
                          },
                          child: const Text("+")),
                      ElevatedButton(
                          onPressed: () {
                            _calculate("-");
                          },
                          child: const Text("-")),
                      ElevatedButton(
                          onPressed: () {
                            _calculate("x");
                          },
                          child: const Text("x")),
                      ElevatedButton(
                          onPressed: () {
                            _calculate("/");
                          },
                          child: const Text("/")),
                    ],
                  ),
                  Text(
                    "\nResult: " + result.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ));
  }

  void _calculate(String op) {
    setState(() {
      numa = double.parse(textEditingController.text);
      numb = double.parse(textEditingController2.text);

      switch (op) {
        case "+":
          result = numa + numb;
          break;
        case "-":
          result = numa - numb;
          break;
        case "x":
          result = numa * numb;
          break;
        case "/":
          result = numa / numb;
          break;
      }
    });
  }
}
