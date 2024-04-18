import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/service.dart';
import 'package:local_service_marketplace/model/user.dart';

class EditServiceScreen extends StatefulWidget {
  final User user;
  final Service service;
  const EditServiceScreen(
      {super.key, required this.user, required this.service});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  File? _image;
  Random random = Random();
  var val = 50;
  late var _updatedImageUrl = "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png?v=$val";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _prnameEditingController =
      TextEditingController();
  final TextEditingController _prdescEditingController =
      TextEditingController();
  final TextEditingController _prpriceEditingController = TextEditingController();
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
  List<String> unitList = ["hour", "square foot", "item", "person", "visit" ];

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    val = random.nextInt(1000);
    _prnameEditingController.text = widget.service.serviceName.toString();
    _prdescEditingController.text = widget.service.serviceDesc.toString();
    _prpriceEditingController.text =
        double.parse(widget.service.servicePrice.toString()).toStringAsFixed(2);
    unit = widget.service.serviceUnit.toString();
    _prlocalEditingController.text = widget.service.serviceLocality.toString();
    _prstateEditingController.text = widget.service.serviceState.toString();
    selectedCategory = widget.service.serviceCategory.toString();
    selectedType = widget.service.serviceType.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
     typeList = categoryToTypes[selectedCategory] ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text("Edit services")),
      body: Column(children: [
        Flexible(
          flex:3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Card(
               child:  GestureDetector(
                          onTap: () {
                            _updateImageDialog();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            width: screenWidth * 0.4,
                            child: CachedNetworkImage(
                              imageUrl: _updatedImageUrl,
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
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
                child: Column(
                  children: [
                    SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
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
                          onChanged: null,
                          // (newValue) {
                            
                          // },
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
                              // ? (newValue) {
                              //   }
                              ? null
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
                    validator: (val) =>
                        val!.isEmpty ? "Service name should not be empty" : null,
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
                 
                ],
              ),
            ),
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
                          child: const Text("Update services")),
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

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
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
            "Update your service?",
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
                updateservice();
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

  void updateservice() {
    String prname = _prnameEditingController.text;
    String prdesc = _prdescEditingController.text;
    String prprice = _prpriceEditingController.text;
    String prqty = unit;

    http.post(Uri.parse("${Config.server}/lsm/php/update_services.php"),
        body: {
          "serviceid": widget.service.serviceId.toString(),
          "prname": prname,
          "prdesc": prdesc,
          "prprice": prprice,
          "prqty": prqty,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
            setState(() {
          _updatedImageUrl =
              "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png?v=$val}";
        });
        val = random.nextInt(1000);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }

    _updateImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                          _updateServiceImage(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _cameraPicker(),
                          _updateServiceImage(),
                        },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        //CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateServiceImage();
      setState(() {});
    }
  }

  void _updateServiceImage() {
    if (_image == null) {
      return;
    }
    File imageFile = File(_image!.path);
    print(imageFile);
    String base64Image = base64Encode(imageFile.readAsBytesSync());

    http.post(Uri.parse("${Config.server}/lsm/php/update_serviceimage.php"), body: {
      "serviceid": widget.service.serviceId.toString(),
      "image": base64Image.toString(),
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Success.")));
        // Update the image URL with a timestamp to bust the cache.
        setState(() {
          _updatedImageUrl =
              "${Config.server}/lsm/assets/images/${widget.service.serviceId}.png?v=$val}";
        });
        val = random.nextInt(1000);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context, _updatedImageUrl);
      }
    });
  }
}