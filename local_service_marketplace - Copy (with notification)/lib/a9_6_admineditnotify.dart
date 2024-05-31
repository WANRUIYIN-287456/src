import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/admin.dart';
import 'package:local_service_marketplace/model/notification.dart';

class EditNotifyScreen extends StatefulWidget {
  final Admin admin;
  final Notifications notifications;
  const EditNotifyScreen({super.key, required this.notifications, required this.admin});

  @override
  State<EditNotifyScreen> createState() => _EditNotifyScreenState();
}

class _EditNotifyScreenState extends State<EditNotifyScreen> {
  late double screenHeight, screenWidth, cardwitdh;
 final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleEditingController =
      TextEditingController();
  final TextEditingController _notbodyEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleEditingController.text = widget.notifications.notTitle.toString();
    _notbodyEditingController.text = widget.notifications.notBody.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Notifications")),
      body: Column(children: [
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

  
            
            TextFormField(
              textInputAction: TextInputAction.next,
              validator: (val) =>
                  val!.isEmpty ? "Notification title should not be empty" : null,
              onFieldSubmitted: (v) {},
              controller: _titleEditingController,
              maxLength: 100,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Notification Title',
                icon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              textInputAction: TextInputAction.next,
             validator: (val) =>
                  val!.isEmpty ? "Notification body should not be empty" : null,
              onFieldSubmitted: (v) {},
              maxLength: 500,
              controller: _notbodyEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Notification body',
                icon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text("Edit Notifications")),
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
            "Edit Notification",
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
                editnotifications();
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

void editnotifications() {
    String title = _titleEditingController.text;
    String notbody = _notbodyEditingController.text;
   
    http.post(Uri.parse("${Config.server}/lsm/php/edit_notifications.php"), body: {
      "notid": widget.notifications.notId,
      "userid": "0",
      "adminid": widget.admin.id.toString(),
      "title": title,
      "body": notbody,
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
}