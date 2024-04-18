import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // For File
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/model/admin.dart';
import 'package:local_service_marketplace/model/seller.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class AdminVerifyDetails extends StatefulWidget {
  final Admin admin;
  final Seller seller;
  const AdminVerifyDetails(
      {Key? key, required this.admin, required this.seller})
      : super(key: key);

  @override
  State<AdminVerifyDetails> createState() => _AdminVerifyDetailsState();
}

class _AdminVerifyDetailsState extends State<AdminVerifyDetails> {
  String status = "";
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _icEditingController = TextEditingController();
  final TextEditingController _certEditingController = TextEditingController();
  late String icfileName = "Select Identity Card";
  late String certfileName = "Select Certificate";
  late bool isVerify = false;
  late String pro;
  late String preferred;
  late String available;
  late List<Seller> sellerList = <Seller>[];
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      datereg: "na",
      password: "na",
      otp: "na");

  @override
  void initState() {
    super.initState();
    loaduser();
    loadVerify(0);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Identity Verification"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                          user.name.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Divider(),
                        Text(user.email.toString()),
                        Text(user.phone.toString()),
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
                            downloadDocument(icfileName);
                          },
                          icon: const Icon(Icons.download_outlined),
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
                            downloadDocument(certfileName);
                          },
                          icon: const Icon(Icons.download_outlined),
                        )
                      ],
                    ),
                    Text("Token: ${widget.seller.token}"),
                    Text("Available Status: ${widget.seller.availableStatus}"),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text("Pro Status:"),
                        Radio(
                          value: "true",
                          groupValue: pro,
                          onChanged: (String? value) {
                            setState(() {
                              pro = value!;
                            });
                          },
                        ),
                        const Text("Yes"),
                        Radio(
                          value: "false",
                          groupValue: pro,
                          onChanged: (String? value) {
                            setState(() {
                              pro = value!;
                              // Call method to update the value in the database
                              // For example: updateProStatus(value);
                            });
                          },
                        ),
                        const Text("No"),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text("Preferred Status:"),
                        Radio(
                          value: "true",
                          groupValue: preferred,
                          onChanged: (String? value) {
                            setState(() {
                              preferred = value!;
                            });
                          },
                        ),
                        const Text("Yes"),
                        Radio(
                          value: "false",
                          groupValue: preferred,
                          onChanged: (String? value) {
                            setState(() {
                              preferred = value!;
                            });
                          },
                        ),
                        const Text("No"),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        const Text("Available Status:"),
                        Radio(
                          value: "true",
                          groupValue: available,
                          onChanged: (String? value) {
                            setState(() {
                              available = value!;
                            });
                          },
                        ),
                        const Text("Yes"),
                        Radio(
                          value: "false",
                          groupValue: available,
                          onChanged: (String? value) {
                            setState(() {
                              available = value!;
                            });
                          },
                        ),
                        const Text("No"),
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
        ),
      ),
    );
  }

  void addnotification() {
    String nottitle = "Identity verified";
    String notbody =
        "Dear ${user.name}, thank you for choosing lsm. Your identity and certifications have been verified. \nPro Status: $pro \nPreferred Status: $preferred \nPlease contact customer service if there is any enquires. +1300-00-1234";

    http.post(Uri.parse("${Config.server}/lsm/php/insert_notifications.php"), body: {
      "userid": widget.seller.sellerId.toString(),
      "adminid": widget.admin.id.toString(),
      "title": nottitle,
      "body": notbody,
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Notify Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Notify Failed")));
        }
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Notify Failed")));
        Navigator.pop(context);
      }
    });
  }

  void notavailablenotification() {
    String nottitle = "Available status update";
    String notbody =
        "Dear ${user.name}, your available status updated. \nAvailable Status: $available \nPlease contact customer service if there is any enquires. +1300-00-1234";

    http.post(Uri.parse("${Config.server}/lsm/php/insert_notifications.php"), body: {
      "userid": widget.seller.sellerId.toString(),
      "adminid": widget.admin.id.toString(),
      "title": nottitle,
      "body": notbody,
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Notify Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Notify Failed")));
        }
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Notify Failed")));
        Navigator.pop(context);
      }
    });
  }

  void insertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Submit Verification",
            style: TextStyle(),
          ),
          content: const Text("Confirm?", style: TextStyle()),
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
                if (isVerify = false) {
                  addnotification();
                }
                if (available == "false") {
                  notavailablenotification();
                }
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
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${Config.server}/lsm/php/verify_identityadmin.php"),
    );
    request.fields.addAll({
      "sellerid": widget.seller.sellerId.toString(),
      "adminid": widget.admin.id.toString(),
      "verify": "true",
      "pro": pro,
      "prefer": preferred,
      "available": available
    });

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

  void loaduser() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
      "userid": widget.seller.sellerId,
    }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }

  loadVerify(int index) {
    http.post(Uri.parse("${Config.server}/lsm/php/load_verify.php"),
        body: {"sellerid": widget.seller.sellerId}).then((response) {
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
                isVerify = sellerList[index].verifyStatus == "true";
                icfileName = sellerList[index].icName.toString();
                certfileName = sellerList[index].certName.toString();
              }
            });
          }
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  Future<void> downloadDocument(String fileName) async {
    final url =
        '${Config.server}/download.php?filename=${widget.seller.sellerId}_$fileName';
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/$fileName');
    await file.writeAsBytes(bytes);

    // Call a callback function to handle UI update after download
    showDownloadSnackBar();
  }

  void showDownloadSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloaded Successfully'),
      ),
    );
  }
}
