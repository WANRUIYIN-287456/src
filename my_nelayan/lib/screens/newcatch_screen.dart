import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';

class NewCatchScreen extends StatefulWidget {
  final User user;
  const NewCatchScreen({super.key, required this.user});

  @override
  State<NewCatchScreen> createState() => _NewCatchScreenState();
}

class _NewCatchScreenState extends State<NewCatchScreen> {
  File? _image;
  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _prnameEditingController =
      TextEditingController();
  final TextEditingController _prdescEditingController =
      TextEditingController();
  final TextEditingController _prpriceEditingController =
      TextEditingController();
  final TextEditingController _prqtyEditingController = TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prdelEditingController = TextEditingController();

  bool _isChecked = false;
  late double screenHeight, screenWidth, cardwitdh;
  String selectedType = "Fish";
  List<String> catchlist = [
    "Fish",
    "Crab",
    "Squid",
    "Oysters",
    "Mussels",
    "Octopus",
    "Scallops",
    "Lobsters",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Flexible(
            flex: 4,
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
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Row(children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(width:16),
                         SizedBox(
                          height: 60,
                          child: DropdownButton(
                            //sorting dropdownoption
                            // Not necessary for Option 1
                            value: selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: catchlist.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Product name must be longer than 3"
                                : null,
                            onFieldSubmitted: (v) {},
                            controller: _prnameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Product Name',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.food_bank),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty ||
                                    (val.length < 10)
                                ? "Product description must be longer than 10"
                                : null,
                            onFieldSubmitted: (v) {},
                            maxLines: 4,
                            controller: _prdescEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Product Description',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(
                                  Icons.person,
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
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Product price must contain value"
                                            : null,
                                    onFieldSubmitted: (v) {},
                                    controller: _prpriceEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Product Price',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.money),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Quantity should be more than 0"
                                            : null,
                                    onFieldSubmitted: (v) {},
                                    controller: _prqtyEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Product Quantity',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.ad_units),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current State"
                                        : null,
                                enabled: false,
                                controller: _prstateEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current States',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.flag),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
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
                          ],
                        ),
                        Row(children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty
                                    ? "Must be more than zero"
                                    : null,
                                onFieldSubmitted: (v) {},
                                controller: _prdelEditingController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Delivery charge/km',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.delivery_dining),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                              flex: 5,
                              child: CheckboxListTile(
                                title: const Text("Lawfull Item?"), // <‐‐ label
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              )),
                        ]),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(screenWidth, screenHeight / 13)),
                          child: const Text('Add Product'),
                          onPressed: () => {
                            _newProductDialog(),
                          },
                        ),
                      ])
                    ]))),
              )),
        ],
      ),
    );
  }

  _newProductDialog() {
    if (widget.user.email == "na") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Only registered account can use this feature")));
    }
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => NewCatchScreen(
    //               user: widget.user,
    //             )));
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    } else {
      print('No image selected.');
    }
  }
  
Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
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
}
