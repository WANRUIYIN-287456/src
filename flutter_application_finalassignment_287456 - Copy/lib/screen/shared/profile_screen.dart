import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_finalassignment_287456/config.dart';
import 'package:flutter_application_finalassignment_287456/model/user.dart';
import 'package:flutter_application_finalassignment_287456/screen/shared/editprofile.dart';
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
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  var val = 50;
  File? _image;

  @override
  void initState() {
    super.initState();
    print("Profile");
    loadProfile();
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
      appBar: AppBar(title: Text(maintitle)),
      body: Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(2),
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Card(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: EdgeInsets.all(4),
                  width: screenWidth * 0.4,
                  child: Image.asset(
                    "assets/images/profile.png",
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     _updateImageDialog();
                //   },
                //   child: Container(
                //     margin: const EdgeInsets.all(4),
                //     width: screenWidth * 0.4,
                //     child: CachedNetworkImage(
                //         imageUrl:
                //             "${Config.server}/Labassign2/assets/images/profile/${widget.user.id}.png",
                //         placeholder: (context, url) =>
                //             const LinearProgressIndicator(),
                //         errorWidget: (context, url, error) => const Icon(
                //               Icons.image_not_supported,
                //               size: 128,
                //             )),
                //   ),
                // ),
                Flexible(
                  child: Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 2, 6),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              widget.user.name.toString(),
                              style: const TextStyle(fontSize: 24),
                            ),
                            Text(widget.user.email.toString()),
                            Text(widget.user.phone.toString()),
                            Text(df.format(DateTime.parse(
                                widget.user.datereg.toString()))),
                          ],
                        ),
                      )),
                ),
              ]),
            ),
          ),
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
                          builder: (content) => EditProfileScreen(
                                user: widget.user,
                              )));
                  loadProfile();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(120, 20, 80, 0),
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 80, 0),
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout),
                      SizedBox(width: 15),
                      Text("Logout"),
                    ]),
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
    if (widget.user.id == "0") {
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
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
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
        CropAspectRatioPreset.square,
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
      _updateProfileImage(_image);
    }
  }

  void _updateProfileImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());

    http.post(Uri.parse("${Config.server}/Labassign2/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "image": base64Image,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Success.")));
        Navigator.of(context).pop();
        //val = random.nextInt(1000);
        setState(() {});
        // DefaultCacheManager manager = DefaultCacheManager();
        // manager.emptyCache(); //clears all data in cache.
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _newpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ],
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
    http.post(Uri.parse("${Config.server}/LabAssign2/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "oldpass": _oldpasswordController.text,
          "newpass": _newpasswordController.text,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Success.")));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.of(context).pop();
      }
    });
  }
}
