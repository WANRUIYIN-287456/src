import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_service_marketplace/model/user.dart';

class ServiceOrderScreen extends StatefulWidget {
  final User user;
  const ServiceOrderScreen({super.key, required this.user});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}