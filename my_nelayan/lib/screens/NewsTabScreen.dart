import 'package:flutter/material.dart';
import 'package:my_nelayan/model/user.dart';
import 'package:my_nelayan/model/user.dart';

class NewsTabScreen extends StatefulWidget {
  final User user;
  const NewsTabScreen({super.key, required this.user});

  @override
  State<NewsTabScreen> createState() => _NewsTabScreenState();
}

class _NewsTabScreenState extends State<NewsTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "News";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(maintitle),
    );
  }
}