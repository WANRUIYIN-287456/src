import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  File? _image;
  late var _updatedImageUrl =
      "${Config.server}/lsm/assets/images/profile/${widget.user.id}.png?v=$val";
  Random random = Random();
  var val = 50;
  bool isDisable = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
    _nameEditingController.text = widget.user.name.toString();
    _phoneEditingController.text = widget.user.phone.toString();
    _emailEditingController.text = widget.user.email.toString();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
    loadProfile();
      if (widget.user.name.toString() != "na") {
        isDisable = false;
      } else if (widget.user.name.toString() == "na") {
        isDisable = true;
      }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Column(children: [
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Card(
              child:  GestureDetector(
                          onTap: isDisable ? null : () {
                            _updateImageDialog();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            width: screenWidth * 0.3,
                            child: CachedNetworkImage(
                              imageUrl: "${Config.server}/lsm/assets/images/profile/${widget.user.id}.png?v=$val",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              Image.network("${Config.server}/lsm/assets/images/profile/0.png", 
                                  scale : 2,
                              ),                                 
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
                    TextFormField(
                      controller: _nameEditingController,
                      enabled: true,
                      validator: (val) => val!.isEmpty || (val.length < 5)
                          ? "name must be longer than 5"
                          : null,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )),
                    ),
                    TextFormField(
                      controller: _phoneEditingController,
                      enabled: true,
                      validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "phone number must contain at least 10 digits"
                          : null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.phone),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )),
                    ),
                    TextFormField(
                      controller: _emailEditingController,
                      enabled: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            onEditDialog();
                          },
                          child: const Text("Update profile")),
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

  void onEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update your profile?",
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
                updateprofile();
                val = random.nextInt(1000);
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

void loadProfile() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_profile.php"), body: {
      if (widget.user.id != "na") "userid": widget.user.id,
    }).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          //print(jsondata['data']);
          if (jsondata['status'] == 'success') {
            var extractdata = jsondata['data'];
            setState(() {
              widget.user.name = extractdata['name'];
              widget.user.email = extractdata['email'];
              widget.user.phone = extractdata['phone'];
              widget.user.datereg = extractdata['datereg'];
              val = random.nextInt(1000);
            });
          } else {
            print(1);
          }
        } else {
          print(2);
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  void updateprofile() {
    String name = _nameEditingController.text;
    String phone = _phoneEditingController.text;
    String email = _emailEditingController.text;

    http.post(Uri.parse("${Config.server}/lsm/php/update_profile.php"), body: {
      "userid": widget.user.id.toString(),
      "username": name,
      "userphone": phone,
      "useremail": email,
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
              val = random.nextInt(1000);
          // Notify AccountTabScreen to reload profile details
          Navigator.of(context).pop(true);
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
                          _updateProfileImage(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _cameraPicker(),
                          _updateProfileImage(),
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
      _updateProfileImage();
      setState(() {});
    }
  }

  void _updateProfileImage() {
    if (_image == null) {
      return;
    }
    File imageFile = File(_image!.path);
    print(imageFile);
    String base64Image = base64Encode(imageFile.readAsBytesSync());

    http.post(Uri.parse("${Config.server}/lsm/php/update_image.php"), body: {
      "userid": widget.user.id.toString(),
      "image": base64Image.toString(),
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Success.")));
        // Update the image URL with a timestamp to bust the cache.
        setState(() {
          _updatedImageUrl =
              "${Config.server}/lsm/assets/images/profile/${widget.user.id}.png?v=$val}";
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
