import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_application/Weather.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather curweather = Weather("Not Available", 0.0, 0, "Not Available");
  String selectloc = "Ipoh";
  List<String> locList = [
    "Alor Setar",
    "Kangar",
    "Butterworth",
    "Ipoh",
    "Kuantan",
  ];
  var temp = 0.0, hum = 0, desc = "no records", weather = " ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Simple Weather",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              itemHeight: 60,
              value: selectloc,
              onChanged: (newValue) {
                setState(() {
                  selectloc = newValue.toString();
                });
              },
              items: locList.map((selectloc) {
                return DropdownMenuItem(
                  child: Text(
                    selectloc,
                  ),
                  value: selectloc,
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: _getWeather, child: const Text("Load weather")),
            //Text(desc,
            //style:
            // const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Expanded(
          child: WeatherGrid(curweather: curweather,),
        ),
          ],
        ),
      ),
    );
  }

  void _getWeather() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Loading..."),
        );
      },
    );
    var apiid = "8d5019a527176063ca6d82dfc38726e3";
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$selectloc&appid=$apiid&units=metric');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        temp = parsedJson['main']['temp'];
        hum = parsedJson['main']['humidity'];
        weather = parsedJson['weather'][0]['main'];
        curweather = Weather(selectloc, temp, hum, weather);
        //desc =
        //    "The current weather in $selectloc is $weather. The current temperature is $temp Celcius and humidity is $hum percent. ";
        
        Fluttertoast.showToast(
            msg: "Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      });
      Navigator.pop(context);
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }
}

class WeatherGrid extends StatefulWidget {
  final Weather curweather;
  const WeatherGrid({Key? key, required this.curweather}) : super(key: key);

  @override
  State<WeatherGrid> createState() => _WeatherGridState();
}

class _WeatherGridState extends State<WeatherGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Location"),
              const Icon(
                Icons.location_city,
                size: 64,
              ),
              Text(widget.curweather.loc)
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Weather"),
              const Icon(
                Icons.cloud,
                size: 64,
              ),
              Text(widget.curweather.weather)
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Temp"),
              const Icon(
                Icons.thermostat,
                size: 64,
              ),
              Text(widget.curweather.temp.toString() + " Celcius")
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Humidity"),
              const Icon(
                Icons.hot_tub,
                size: 64,
              ),
              Text(widget.curweather.hum.toString() + "%")
            ],
          ),
          color: Colors.blue[100],
        ),
      ],
    );
  }
}
