import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/user.dart';

class NewServiceScreen extends StatefulWidget {
  final User user;

  const NewServiceScreen({super.key, required this.user});

  @override
  State<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  File? _image;
  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _prnameEditingController =
      TextEditingController();
  final TextEditingController _prdescEditingController =
      TextEditingController();
  final TextEditingController _prpriceEditingController =
      TextEditingController();
  // final TextEditingController _prhourEditingController =
  //     TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  String selectedCategory = "Home Maintenance and Renovation";

  Map<String, List<String>> categoryToTypes = {
    "Home Maintenance and Renovation": [
      "Renovation",
      "Architecture",
      "Interior design",
      "Plumber",
      "Moving Service",
      "Electrical Maintenance/ Wiring service",
      "Electrical Appliances Installation/ Maintenance",
      "Locksmith Service",
      "Cleaning Service",
      "Pest Control Service",
      "Roof Repairing Service",
      "Fumigation Service",
      "Sanitation and Disinfection Service",
      "Others",
    ],
    "Event Organizing and Management": [
      "Event Planning Service",
      "Catering Service",
      "Makeup Service",
      "Photography Service",
      "Printing Service",
      "Chauffeur Service",
      "Others",
    ],
    "Automotive Service": [
      "Mechanic",
      "Welding Service",
      "Accessories Installation/ Maintenance",
      "Others",
    ],
    "Healthcare and Wellness": [
      "Nursing Service/ Nurse Aiders/ Healthcare Workers",
      "Confinement Nurse",
      "Others",
    ],
    "Personal Services": [
      "Personal Shoppers/ Runners",
      "Professional Organizer",
      "Babysitter",
      "Afterschool Care/ Day Care",
      "Others",
    ],
    "Consultation Services": [
      "Legal",
      "Human Resources",
      "Tax & Account",
      "Medical",
      "Psychological",
      "Others",
    ],
    "Education": [
      "Tutor Services",
      "Soft Skill Training",
      "Swimming Class",
      "Sport Activity Class",
      "Physique Course",
      "Dance Class",
      "Fitness Class",
      "Others",
    ],
    "Leisure and Others": [
      "Piano Tuning Services",
      "Pet Grooming Services",
      "Beauty Services",
      "Others",
    ],
  };

  String selectedType = "";
  List<String> typeList = [];

  String unit = "hour";
  List<String> unitList = ["hour", "square foot", "item", "person", "visit", ];

  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";
  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    typeList = categoryToTypes[selectedCategory] ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text("Insert New Products")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                _selectImage();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 0, 4),
                child: Card(
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.78,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image!) as ImageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text("Category"),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          value: selectedCategory,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategory = newValue.toString();
                              selectedType =
                                  ""; // Reset selected type when category changes
                            });
                          },
                          items: categoryToTypes.keys.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Type"),
                      const SizedBox(
                        width: 45,
                      ),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          value: selectedType.isNotEmpty ? selectedType : null,
                          onChanged: selectedCategory.isNotEmpty
                              ? (newValue) {
                                  setState(() {
                                    selectedType = newValue.toString();
                                  });
                                }
                              : null,
                          items: typeList.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (val) => val!.isEmpty
                        ? "Service name should not be empty"
                        : null,
                    onFieldSubmitted: (v) {},
                    controller: _prnameEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                      icon: Icon(Icons.abc),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (val) => val!.isEmpty
                        ? "Service description must be longer than 10"
                        : null,
                    onFieldSubmitted: (v) {},
                    maxLines: 2,
                    controller: _prdescEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Service Description',
                      icon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty
                              ? "Service price per unit must contain number"
                              : null,
                          onFieldSubmitted: (v) {},
                          controller: _prpriceEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price per unit',
                            icon: Icon(Icons.money),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Expanded(
                      //   child: TextFormField(
                      //     textInputAction: TextInputAction.next,
                      //     validator: (val) => val!.isEmpty
                      //         ? "Working hours should be more than 0"
                      //         : null,
                      //     controller: _prhourEditingController,
                      //     keyboardType: TextInputType.text,
                      //     decoration: const InputDecoration(
                      //       labelText: 'Working Hours',
                      //       icon: Icon(Icons.history),
                      //       border: OutlineInputBorder(),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                          child: DropdownButton(
                            isExpanded: true,
                            value: unit,
                            onChanged: (newValue) {
                              setState(() {
                                unit = newValue!;
                                print(unit);
                              });
                            },
                            items: unitList.map((unit) {
                              return DropdownMenuItem(
                                value: unit,
                                child: Text(
                                  unit,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Current State"
                              : null,
                          enabled: false,
                          controller: _prstateEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Current State',
                            icon: Icon(Icons.flag),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          enabled: false,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Current Locality"
                              : null,
                          controller: _prlocalEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Current Locality',
                            icon: Icon(Icons.map),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      insertDialog();
                    },
                    child: const Text("Insert Service"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 6)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 4, screenHeight / 6)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        //CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);

      setState(() {});
    }
  }

  void insertDialog() {
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      // Check if _formKey.currentState is null before accessing validate()
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your product?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertproduct();
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertproduct() {
    String ic = "";
    String cert = "";
    String pro = "No";
    String prefer = "No";
    String available = "No";
    String admin = "0";
    String verify = "No";
    String prname = _prnameEditingController.text;
    String prdesc = _prdescEditingController.text;
    String prprice = _prpriceEditingController.text;
    //String prhour = _prhourEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    List<String>? types = categoryToTypes[selectedCategory];
    String selectedType = types != null && types.isNotEmpty ? types[0] : "";
    if (types == null || types.isEmpty) {
      print("Error: No types found for the selected category.");
      return;
    }

    http.post(Uri.parse("${Config.server}/lsm/php/insert_products.php"), body: {
      "sellerid": widget.user.id.toString(),
      "admin": admin,
      "ic": ic,
      "cert": cert,
      "pro": pro,
      "prefer": prefer,
      "available": available,
      "verify": verify,
      "userid": widget.user.id.toString(),
      "category": selectedCategory,
      "type": selectedType,
      "prname": prname,
      "prdesc": prdesc,
      "prprice": prprice,
      "prhour": unit,
      "latitude": prlat,
      "longitude": prlong,
      "state": state,
      "locality": locality,
      "image": base64Image,
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));

        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
              Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}
