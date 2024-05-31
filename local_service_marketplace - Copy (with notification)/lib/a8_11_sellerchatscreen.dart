import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/message.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';

class SellerChatScreen extends StatefulWidget {
  final User user;
  final Order order;
  const SellerChatScreen({super.key, required this.user, required this.order});

  @override
  State<SellerChatScreen> createState() => _SellerChatScreenState();
}

class _SellerChatScreenState extends State<SellerChatScreen> {
  List<Chat> chatList = <Chat>[];
  late double screenHeight, screenWidth;
  //late bool isSentByMe = true; // userid=userid true, else, false
  //String text = "";
  final TextEditingController _chatbodyEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadChat();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text("Chats")),
        body: Column(
          children: [
            SizedBox(
              //flex: 3,
              height: screenHeight / 6.3,
              width: screenWidth,
              child: Card(
                  child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: screenWidth * 0.3,
                    child: CachedNetworkImage(
                        imageUrl:
                            "${Config.server}/lsm/assets/images/profile/${widget.order.userId}.png",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) => Image.network(
                              "${Config.server}/lsm/assets/images/profile/0.png",
                              scale: 2,
                            )),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${widget.user.name}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("Phone: ${widget.user.phone}",
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                            // Text("Order Status: ${widget.order.orderStatus}",
                            //     style: const TextStyle(
                            //       fontSize: 14,
                            //     )),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )),
            ),
            Expanded(
                child: Container(
              child: GroupedListView<Chat, DateTime>(
                padding: const EdgeInsets.all(8),
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                elements: chatList,
                groupBy: (chat) => DateTime(
                  DateTime.parse(chat.chatDate.toString()).year,
                  DateTime.parse(chat.chatDate.toString()).month,
                  DateTime.parse(chat.chatDate.toString()).day,
                ),
                groupHeaderBuilder: (Chat chat) => SizedBox(
                    height: 40,
                    child: Center(
                        child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(DateTime.parse(chat.chatDate.toString())),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ))),
                itemBuilder: (context, Chat chat) => Align(
                  alignment: chat.chatSendbyme == "true"
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: min(screenWidth * 0.75,
                          screenWidth * 0.9), // Set the maximum width
                    ),
                    child: Card(
                      elevation: 8,
                      color: chat.chatSendbyme == "true"
                          ? Colors.white
                          : Colors.teal.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(chat.chatBody.toString()),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.teal, width: 2),
                    ),
                    height: 50,
                    width: 280,
                    child: TextField(
                      controller: _chatbodyEditingController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (v) {
                        final chat = Chat(
                          sellerId: widget.order.sellerId,
                          userId: widget.order.userId,
                          chatBody: _chatbodyEditingController.text,
                          chatSendbyme: "false",
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: IconButton(
                      onPressed: () {
                        insertChat();
                        _chatbodyEditingController.clear();
                        loadChat();
                        setState(() {});
                      },
                      color: Colors.white,
                      icon: const Icon(Icons.send)),
                )
              ],
            ),
            SizedBox(height: 6),
          ],
        ));
  }

  void insertChat() {
    http.post(Uri.parse("${Config.server}/lsm/php/insert_chat.php"), body: {
      "userid": widget.order.userId,
      "sellerid": widget.order.sellerId,
      "chatbody": _chatbodyEditingController.text,
      "sendbyme": "false",
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          setState(() {
            loadChat();
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
      }
    });
  }

  void loadChat() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_chat.php"), body: {
      "userid": widget.order.userId,
      "sellerid": widget.order.sellerId
    }).then((response) {
      //print(response.body);
      //log(response.body);
      chatList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          for (var v in extractdata) {
            chatList.add(Chat.fromJson(v));
          }
          if (chatList.isNotEmpty) {
            print(chatList[0].chatBody);
          }
        }

        setState(() {});
      }
    });
  }
}
