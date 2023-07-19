import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';

import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';



class EditImageScreen extends StatefulWidget {
  final User user;
  const EditImageScreen({super.key, required this.user});

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Edit Image";
  var pathAsset = "assets/images/profile.png";
  File? _image;
  
  late double screenHeight, screenWidth, cardwitdh;

 
  @override
  void initState() {
    super.initState();
        print("Image");

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Image")),
      body: Column(children: [
         Container(
            padding: const EdgeInsets.all(2),
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Card(
              child:
                  Flexible(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          _selectImage();
                          // setState(() {                         
                          // });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 2, 10),
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
            ),
          ),
      ]),
    );
  }

 void _selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
    insertprofile();
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
    insertprofile();
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
         CropAspectRatioPreset.square,
        //CropAspectRatioPreset.ratio3x2,
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

      setState(() {});
    }
  }


  void insertprofile() {
    String base64Image1 = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse("${Config.server}/LabAssign2/php/insert_profile.php"),
        body: {
          "userid": widget.user.id.toString(),
          "username": widget.user.name.toString(),
          "userphone": widget.user.phone.toString(),
          "useremail": widget.user.email.toString(),
          "userdatereg": widget.user.datereg.toString(),
          "image1": base64Image1,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Edit Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Edit Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Edit Failed")));
        Navigator.pop(context);
      }
    });
  }

}