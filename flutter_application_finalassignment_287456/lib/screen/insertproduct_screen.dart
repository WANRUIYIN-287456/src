import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;


class NewProductScreen extends StatefulWidget {
  final User user;

  const NewProductScreen({super.key, required this.user});

  @override
  State<NewProductScreen> createState() => NewProductScreenState();
}

class NewProductScreenState extends State<NewProductScreen> {
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
  final TextEditingController _prqtyEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  String selectedType = "Clothes";
  List<String> prlist = [
    "Clothes",
    "Digital Products",    
    "Fashion Accessories",
    "Games & Books",
    "Health & Beauty",
    "Home & Living",
    "Mobile, Laptop & Accessories",
    "Sports & Outdoor",
    "Others",
  ];
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
    return Scaffold(
      appBar: AppBar(title: const Text("Insert New Products"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
      body: Column(children: [
        Flexible(
            flex: 3,
            // height: screenHeight / 2.5,
            // width: screenWidth,
            child: GestureDetector(
              onTap: () {
                _selectImage();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Card(
                  child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image!) as ImageProvider,
                          fit: BoxFit.contain,
                        ),
                      )),
                ),
              ),
            )),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          height: 60,
                          width: 150,
                          child: DropdownButton(
                            isExpanded: true,
                            value: selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: prlist.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Product name must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {},
                              controller: _prnameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Product Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.abc),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        )
                      ],
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Product description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 2,
                        controller: _prdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Product Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Product value must contain number"
                                  : null,
                              onFieldSubmitted: (v) {},
                              controller: _prpriceEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Product Value',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity should be more than 0"
                                  : null,
                              controller: _prqtyEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Product Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.numbers),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State"
                                : null,
                            enabled: false,
                            controller: _prstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
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
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text("Insert products")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
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
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
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
    String prname = _prnameEditingController.text;
    String prdesc = _prdescEditingController.text;
    String prprice = _prpriceEditingController.text;
    String prqty = _prqtyEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("${Config.server}/LabAssign2/php/insert_products.php"),
        body: {
          "userid": widget.user.id.toString(),
          "prname": prname,
          "prdesc": prdesc,
          "prprice": prprice,
          "prqty": prqty,
          "type": selectedType,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "image": base64Image
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
        Navigator.pop(context);
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