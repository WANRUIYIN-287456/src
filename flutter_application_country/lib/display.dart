import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application_country/country.dart';
import 'package:ndialog/ndialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country App'),
        ),
        body: const CPage(),
      ),
    );
  }
}

class CPage extends StatefulWidget {
  const CPage({super.key});

  @override
  State<CPage> createState() => _CPageState();
}

class _CPageState extends State<CPage> {
  Country countryobj =
      Country("Malaysia", "Not Available", "Not Available", 0.0, "MY", 0.0, "");
  String selectloc = "Malaysia";
  var name = "Malaysia",
      capital = "Not available",
      currency = "Not available",
      gdp = 0.0,
      ccode = "MY",
      population = 0.0,
      flag = '';

  AudioPlayer player = AudioPlayer();
  Future loadOk() async {
    player.play(AssetSource("audio/success.wav"));
  }

  Future loadFail() async {
    player.play(AssetSource("audio/negative_beeps-6008.wav"));
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text(
                "Country Information",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: "Country Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const Text(""),
              ElevatedButton(
                  onPressed: _getCountry, child: const Text("Load country")),
              Flexible(
                flex: 5,
                child: CountryGrid(
                  countryobj: countryobj,
                ),
              ),
              
              if (flag.isNotEmpty) 
              Image.network(flag, scale: 0.6)
            ]),
          ),
        ),
      ),
    );
  }

  void _getCountry() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Loading..."),
        );
      },
    );
    selectloc = textEditingController.text;
    var apiid = "4NGOdfJ2XxrehJd0CvbIvQ==fzcVVyaVfVkeLMBM";
    var url =
        Uri.parse('https://api.api-ninjas.com/v1/country?name=$selectloc');
    var response = await http.get(url, headers: {"X-Api-Key": apiid});
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      if (parsedJson[0]['name'].toLowerCase() == selectloc.toLowerCase() ||
          parsedJson[0]['iso2'].toLowerCase() == selectloc.toLowerCase()) {
        setState(() {
          capital = parsedJson[0]['capital'];
          currency = parsedJson[0]['currency']['name'];
          gdp = parsedJson[0]['gdp'];
          ccode = parsedJson[0]['iso2'];
          population = parsedJson[0]['population'];
          flag = "https://flagsapi.com/$ccode/shiny/64.png";
          countryobj = Country(
              selectloc, capital, currency, gdp, ccode, population, flag);

          Fluttertoast.showToast(
              msg: "Found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          loadOk();
        });
      Navigator.pop(context);
          
    } else {
      setState(() {
        flag = "";
        countryobj = Country(
              "No Record", "No Record", "No Record", 0.0, " ", 0.0, " ");
        Fluttertoast.showToast(
            msg: "Search not Found. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 12.0);
        loadFail(); //NEGATIVE BEEP SOUNDS
      });
      Navigator.pop(context);
    }
    }
  }
}

class CountryGrid extends StatefulWidget {
  final Country countryobj;
  const CountryGrid({Key? key, required this.countryobj}) : super(key: key);

  @override
  State<CountryGrid> createState() => _CountryGridState();
}

class _CountryGridState extends State<CountryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Capital"),
              const Icon(
                Icons.location_city,
                size: 50,
              ),
              Text(widget.countryobj.capital)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Currency"),
              const Icon(
                Icons.currency_pound,
                size: 50,
              ),
              Text(widget.countryobj.currency)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("GDP"),
              const Icon(
                Icons.bar_chart,
                size: 50,
              ),
              Text(widget.countryobj.gdp.toString())
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("population"),
              const Icon(
                Icons.people,
                size: 50,
              ),
              Text(widget.countryobj.population.toString())
            ],
          ),
        ),
      ],
    );
  }
}
