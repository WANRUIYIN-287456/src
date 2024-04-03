import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_service_marketplace/model/user.dart';

class BillScreen extends StatefulWidget {
  final User user;
  const BillScreen({super.key, required this.user});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}