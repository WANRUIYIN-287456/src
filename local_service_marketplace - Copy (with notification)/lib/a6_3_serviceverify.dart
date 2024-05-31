import 'dart:convert';
import 'dart:io'; // For File
import 'dart:math';
import 'package:file_picker/file_picker.dart'; // For FilePickerResult
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/model/seller.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SellerVerificationScreen extends StatefulWidget {
  final User user;
  const SellerVerificationScreen({super.key, required this.user});

  @override
  State<SellerVerificationScreen> createState() =>
      _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends State<SellerVerificationScreen> {
  String status = "";
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _icEditingController = TextEditingController();
  final TextEditingController _certEditingController = TextEditingController();
  //bool isClosed = false;
  late String icfileName = "Select Identity Card";
  late String certfileName = "Select Certificate";
  late bool isVerify = false;
  late bool isPro = false;
  late bool isPreferred = false;
  late bool isUpload = false;
  late bool isUploadDialogOpen = false;
  late bool isVerifyDialogOpen = false;
  List<Seller> sellerList = <Seller>[];

  @override
  void initState() {
    super.initState();
    loadStatus();
    loadVerify(0);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Identity Verification"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showStatus(); // Call showStatus() method here
                },
              );
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: isUploadDialogOpen
          ? Container(
              child: isVerifyDialogOpen ? verifyDialog() : uploadDialog())
          : SingleChildScrollView(
              child: !isUpload
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(""),
                                    Text(
                                      widget.user.name.toString(),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const Divider(),
                                    Text(widget.user.email.toString()),
                                    Text(widget.user.phone.toString()),
                                    Text(df.format(DateTime.parse(
                                        widget.user.datereg.toString()))),
                                    const Text(""),
                                  ],
                                )
                              ],
                            ),
                          ), //
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Form(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 30),
                                    const Icon(Icons.person),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 170,
                                      child: Text(icfileName),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        if (result != null) {
                                          File file =
                                              File(result.files.single.path!);
                                          icfileName =
                                              file.path.split('/').last;
                                          setState(() {
                                            _icEditingController.text =
                                                file.path;
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.upload_file),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 30),
                                    const Icon(Icons.file_copy),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 160,
                                      child: Text(certfileName),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        if (result != null) {
                                          File file =
                                              File(result.files.single.path!);
                                          certfileName =
                                              file.path.split('/').last;
                                          setState(() {
                                            _certEditingController.text =
                                                file.path;
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.upload_file),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                SizedBox(
                                  width: screenWidth / 1.2,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      insertDialog();
                                    },
                                    child: const Text("Verify Identity"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: List.generate(sellerList.length, (index) {
                        return Column(
                          children: [
                            isVerify
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(""),
                                                  Text(
                                                    widget.user.name.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 24),
                                                  ),
                                                  const Divider(),
                                                  Text(widget.user.email
                                                      .toString()),
                                                  Text(widget.user.phone
                                                      .toString()),
                                                  Text(df.format(DateTime.parse(
                                                      widget.user.datereg
                                                          .toString()))),
                                                  const Text(""),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (isPro)
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5.0),
                                                            ),
                                                            color: Colors
                                                                .orangeAccent,
                                                          ),
                                                          child: const Text(
                                                              "  Pro  "),
                                                        ),
                                                      const SizedBox(width: 20),
                                                      if (isPreferred)
                                                        Container(
                                                          //margin: const EdgeInsets.all(10),
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)),
                                                            color: Colors
                                                                .orangeAccent,
                                                          ),
                                                          child: const Text(
                                                              "  Preferred  "),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ), //
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 5, 20, 5),
                                        child: Form(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 30),
                                                  const Icon(Icons.person),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                      width: 170,
                                                      child: Text(icfileName)),
                                                  const SizedBox(width: 10),
                                                  const IconButton(
                                                    onPressed: null,
                                                    icon:
                                                        Icon(Icons.upload_file),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(width: 30),
                                                  const Icon(Icons.file_copy),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                      width: 150,
                                                      child:
                                                          Text(certfileName)),
                                                  const SizedBox(width: 30),
                                                  const IconButton(
                                                    onPressed: null,
                                                    icon:
                                                        Icon(Icons.upload_file),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 35,
                                              ),
                                              SizedBox(
                                                width: screenWidth / 1.2,
                                                height: 50,
                                                child: const ElevatedButton(
                                                    onPressed: null,
                                                    child: Text(
                                                        "Verify Identity")),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(""),
                                                  Text(
                                                    widget.user.name.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 24),
                                                  ),
                                                  const Divider(),
                                                  Text(widget.user.email
                                                      .toString()),
                                                  Text(widget.user.phone
                                                      .toString()),
                                                  Text(df.format(DateTime.parse(
                                                      widget.user.datereg
                                                          .toString()))),
                                                  const Text(""),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 5, 20, 5),
                                        child: Form(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 30),
                                                  const Icon(Icons.person),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 170,
                                                    child:
                                                        Text(icfileName),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'pdf'
                                                        ],
                                                      );
                                                      if (result != null) {
                                                        File file = File(result
                                                            .files
                                                            .single
                                                            .path!);
                                                        icfileName = file.path
                                                            .split('/')
                                                            .last;
                                                        setState(() {
                                                          _icEditingController
                                                              .text = file.path;
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.upload_file),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(width: 30),
                                                  const Icon(Icons.file_copy),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 160,
                                                    child: Text(certfileName),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  IconButton(
                                                    onPressed: () async {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'pdf'
                                                        ],
                                                      );
                                                      if (result != null) {
                                                        File file = File(result
                                                            .files
                                                            .single
                                                            .path!);
                                                        certfileName = file.path
                                                            .split('/')
                                                            .last;
                                                        setState(() {
                                                          _certEditingController
                                                              .text = file.path;
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.upload_file),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 35,
                                              ),
                                              SizedBox(
                                                width: screenWidth / 1.2,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    insertDialog();
                                                  },
                                                  child: const Text(
                                                      "Verify Identity"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                          ],
                        );
                      }),
                    ),
            ),
    );
  }

  loadStatus() async {
    WidgetsFlutterBinding.ensureInitialized();
    status = await rootBundle.loadString('assets/images/status.txt');
  }

  showStatus() {
    return AlertDialog(
      title: const Text(
        "Service Providers Status Details",
        style: TextStyle(),
      ),
      content: SizedBox(
        height: 300,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  child: RichText(
                softWrap: true,
                textAlign: TextAlign.justify,
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                    text: status),
              )),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "Close",
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  void insertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Verify Your Identity?",
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
                loadVerify(0);
                //updateFileName();
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

  void updateservice() async {
    String ic = _icEditingController.text;
    String cert = _certEditingController.text;
    String upload = "true";
    String pro = "false";
    String prefer = "false";
    String available = "true";
    String verify = "false";
    String admin = "0";
    String? token = await FirebaseMessaging.instance.getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${Config.server}/lsm/php/verify_identity.php"),
    );
    request.fields.addAll({
      "sellerid": widget.user.id.toString(),
      "admin": admin,
      "upload": upload,
      "pro": pro,
      "prefer": prefer,
      "available": available,
      "icN": icfileName,
      "certN": certfileName,
      "verify": verify,
      "token": "0",
      "fcmtoken": token.toString(),
    });

    if (ic.isNotEmpty) {
      request.files.add(http.MultipartFile.fromBytes(
        'ic',
        File(ic).readAsBytesSync(),
        filename: icfileName,
      ));
    }

    if (cert.isNotEmpty) {
      request.files.add(http.MultipartFile.fromBytes(
        'cert',
        File(cert).readAsBytesSync(),
        filename: certfileName,
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);
      if (jsonData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Success")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update Failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update Failed")),
      );
      Navigator.pop(context);
    }
  }

  Widget uploadDialog() {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: const Text(
        "Documents updated successfully",
        style: TextStyle(),
      ),
      content: const Text(
          "Please wait for 3-7 working days for the verification. You will receive notification in the application once the verification has been processed.",
          style: TextStyle()),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "Close",
            style: TextStyle(),
          ),
          onPressed: () {
            setState(() {
              isUploadDialogOpen = false;
            });
          },
        ),
      ],
    );
  }

  Widget verifyDialog() {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: const Text(
        "Identity verified successfully",
        style: TextStyle(),
      ),
      content: const Text("Please check your notification for more details.",
          style: TextStyle()),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "Close",
            style: TextStyle(),
          ),
          onPressed: () {
            setState(() {
              isUploadDialogOpen = false;
            });
          },
        ),
      ],
    );
  }

  loadVerify(int index) {
    http.post(Uri.parse("${Config.server}/lsm/php/load_verify.php"),
        body: {"sellerid": widget.user.id}).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          //print(jsondata['data']);
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata['status'] == "success") {
              var extractdata = jsondata['data'];
              for (var v in extractdata) {
                sellerList.add(Seller.fromJson(v));
              }
              if (sellerList.isNotEmpty) {
                print(sellerList[0].icName);
              }
            }

            setState(() {
              if (mounted) {
                isUpload = sellerList[index].uploadStatus == "true";
                isPro = sellerList[index].proStatus == "true";
                isPreferred = sellerList[index].preferredStatus == "true";
                isVerify = sellerList[index].verifyStatus == "true";
                icfileName = sellerList[index].icName.toString();
                certfileName = sellerList[index].certName.toString();
                isUploadDialogOpen = sellerList[index].uploadStatus == "true";
                isVerifyDialogOpen = sellerList[index].verifyStatus == "true";
              }
            });
          }
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  
}
