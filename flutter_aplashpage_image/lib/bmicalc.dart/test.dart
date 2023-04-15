import 'package:flutter/material.dart';

void main() => runApp(const SPage());



class SPage extends StatefulWidget {
  const SPage({super.key});

  @override
  State<SPage> createState() => _SPageState();
}

class _SPageState extends State<SPage> {
  TextEditingController heightEditingController = TextEditingController();
  TextEditingController weightEditingController = TextEditingController();
  double height = 0, weight = 0, bmi = 0;
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: Scaffold(
       body: Center(
        child: Column(
          children: [
            Flexible(flex: 5,
        child: Image.asset(
          "asssets/images/opi.jpg", scale: 1,
        ),
            ),
            SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            
            const Text(
              "BMI Calculator",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: null,
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                  hintText: "Height in Meter",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: null,
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                  hintText: "Weight in Kg",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _calBMI, child: const Text("Calculate BMI")),
            const SizedBox(height: 10),
            Text(
              "Your BMI: $bmi",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
       ),
      ],
      ),
       ),
       ),
    );
  }

  void _calBMI() {
    height = double.parse(heightEditingController.text);
    weight = double.parse(weightEditingController.text);

    setState(() {
      bmi = weight / (height * height);
    }
    );
  }
}
