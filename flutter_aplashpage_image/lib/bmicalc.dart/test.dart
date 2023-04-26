import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const SPage());

class SPage extends StatefulWidget {
  const SPage({super.key});

  @override
  State<SPage> createState() => _SPageState();
}

class _SPageState extends State<SPage> {
  TextEditingController heightEditingController = TextEditingController();
  TextEditingController weightEditingController = TextEditingController();
  AudioPlayer player = AudioPlayer();

  double height = 0.00, weight = 0.00, bmi = 0.00;
  String bmistr = " ";

  //String audioasset = "asssets/sounds/child-says-ok-113118.wav";
 // String audioasset2 = "asssets/sounds/negative_beeps-6008.wav";

  Future loadOk() async {
    player.play(AssetSource("sounds/child-says-ok-113118.wav"));
  }

  Future loadFail() async {
     player.play(AssetSource("sounds/negative_beeps-6008.wav"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: Image.asset(
                      "assets/images/opi.jpg",
                      scale: 4),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      const Text(
                        "BMI Calculator",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: heightEditingController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                            hintText: "Height in Meter",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: weightEditingController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                            hintText: "Weight in Kg",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: _calBMI,
                          child: const Text("Calculate BMI")),
                      const SizedBox(height: 10),
                      Text(
                        "Your BMI: " + bmi.toStringAsPrecision(3),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, ),
                      ),
                      Text("\n" + bmistr,style: const TextStyle(
                            fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.bold),
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
      if (bmi > 25) {
        loadFail();
         bmistr = "Overweight";
      } else if ((bmi <= 24.9) && (bmi >= 18.5)) {
        loadOk();
        bmistr = "Normal";
      } else if (bmi < 18.5) {
        loadFail();
        bmistr = "Underweight";
      }
    });
  }
}
