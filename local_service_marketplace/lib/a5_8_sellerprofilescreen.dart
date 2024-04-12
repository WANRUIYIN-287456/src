import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_service_marketplace/model/user.dart';

class SellerProfileScreen extends StatefulWidget {
  final User user;
  final String sellerId;
  const SellerProfileScreen({super.key, required this.user, required this.sellerId});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}