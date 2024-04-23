import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/admin.dart';

class NewNotifyScreen extends StatefulWidget {
  final Admin admin;
  const NewNotifyScreen({super.key, required this.admin});

  @override
  State<NewNotifyScreen> createState() => _NewNotifyScreenState();
}

class _NewNotifyScreenState extends State<NewNotifyScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleEditingController =
      TextEditingController();
  final TextEditingController _notbodyEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Insert New Notifications")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
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
            ElevatedButton(
              onPressed: () {
                insertDialog();
              },
              child: const Text("Insert Notification"),
            ),
          ],
        ),
      ),
    );
  }

   void insertDialog() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      // Check if _formKey.currentState is null before accessing validate()
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
            "Insert Notification",
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
                insertnotify();
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

  void insertnotify() {
    String title = _titleEditingController.text;
    String notbody = _notbodyEditingController.text;
   
    http.post(Uri.parse("${Config.server}/lsm/php/insert_notifications.php"), body: {
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
