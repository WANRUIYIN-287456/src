import 'package:flutter/material.dart';
import 'package:my_nelayan/model/user.dart';
import 'package:my_nelayan/screens/newcatch_screen.dart';

class SellerTabScreen extends StatefulWidget {
  final User user;
  const SellerTabScreen({super.key, required this.user});

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
    return Scaffold(
      body: Center(),
      floatingActionButton: FloatingActionButton(onPressed:(){
        if(widget.user.id != "na"){
          Navigator.push(context, MaterialPageRoute(builder: (content) => NewCatchScreen(user: widget.user,)));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login/register an account.")));
        }
      },
      child: const Text("+", style: TextStyle(fontSize: 32))), 
      
    );
  }
}