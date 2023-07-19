import 'package:flutter/material.dart';
class MessageTabScreen extends StatefulWidget {
  const MessageTabScreen({super.key});

  @override
  State<MessageTabScreen> createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<MessageTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:  const Text("Message"),
    ),
    body: const Center(child: Text("No message yet")),
    );
  }
}