import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_finalassignment_287456/screen/shared/editprofile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;
  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late var _updatedImageUrl = "${Config.server}/LabAssign2/assets/images/profile/0.png";
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  File? _image;
  var pathAsset = "assets/images/profile.png";
  bool isDisable = false;
  double userid = 0;
  // late String _updatedImageUrl;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    print("Profile");
    // if (widget.user.id == "na") {
    //   userid = 0;
    // } else {
    //   userid = double.parse(widget.user.id.toString());
    // }
    loadProfile();
    _updatedImageUrl = "${Config.server}/LabAssign2/assets/images/profile/${widget.user.id}.png";
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => const LoginScreen()));
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login, color: Colors.white54),
                  SizedBox(width: 10),
                  Text("Login", style: TextStyle(color: Colors.white54)),
                ]),
          ),
        ],
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.user.name.toString() == "na"
                      ? Container(
                          margin: const EdgeInsets.all(4),
                          width: screenWidth * 0.4,
                          child: Image.asset(
                            "assets/images/profile.png",
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _updateImageDialog();
                            loadProfile();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            width: screenWidth * 0.4,
                            child: CachedNetworkImage(
                                imageUrl:
                                    _updatedImageUrl,
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.network(
                                      "${Config.server}/LabAssign2/assets/images/profile/0.png",
                                      scale: 2,
                                    )),
                          ),
                        ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.user.name.toString() == "na"
                            ? Column(
                                children: const [
                                  Text(
                                    "Not Available",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Divider(),
                                  Text("Not Available"),
                                  Text("Not Available"),
                                  Text("Not Available"),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    widget.user.name.toString(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const Divider(),
                                  Text(widget.user.email.toString()),
                                  Text(widget.user.phone.toString()),
                                  Text(df.format(DateTime.parse(
                                      widget.user.datereg.toString()))),
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.background,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Text("PROFILE SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              MaterialButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              EditProfileScreen(user: widget.user)));
                  loadProfile();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(110, 20, 80, 0),
                  child: Row(children: const [
                    Icon(Icons.edit),
                    SizedBox(width: 15),
                    Text("Edit Profile"),
                  ]),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _changePassDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(110, 20, 50, 0),
                  child: Row(children: const [
                    Icon(Icons.password),
                    SizedBox(width: 15),
                    Text("Edit Password"),
                  ]),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const LoginScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(110, 20, 50, 0),
                  child: Row(children: const [
                    Icon(Icons.logout),
                    SizedBox(width: 15),
                    Text("Logout"),
                  ]),
                ),
              ),
            ],
          ))
        ]),
      ),
    );
  }

  void loadProfile() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/load_profile.php"),
        body: {
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

  _updateImageDialog() {
    if (widget.user.id == "na") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login to your account.")));
      return;
    }
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

  http.post(Uri.parse("${Config.server}/LabAssign2/php/update_image.php"),
      body: {
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
            "${Config.server}/LabAssign2/assets/images/profile/${widget.user.id}.png?time=${DateTime.now().millisecondsSinceEpoch}";
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Update Failed")));
      Navigator.of(context).pop();
    }
  });
}


  void _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Password?",
            style: TextStyle(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _oldpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _newpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
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

  void changePass() {
    http.post(Uri.parse("${Config.server}/LabAssign2/php/update_password.php"),
        body: {
          "userid": widget.user.id,
          "oldpass": _oldpasswordController.text,
          "newpass": _newpasswordController.text,
        }).then((response) {
      print(response.body);
      print(response.statusCode);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Success.")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        ;
      }
    });
  }
}
