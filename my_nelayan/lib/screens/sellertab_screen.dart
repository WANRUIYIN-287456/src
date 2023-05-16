import 'package:flutter/material.dart';

class SellerTabScreen extends StatefulWidget {
  const SellerTabScreen({super.key});

  @override
  State<SellerTabScreen> createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Seller";

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