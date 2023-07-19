// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_chat_bubble/bubble_type.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';



// class OwnerScreen extends StatefulWidget {
//   const OwnerScreen({super.key});

//   @override
//   State<OwnerScreen> createState() => _OwnerScreenState();
// }
// class _OwnerScreenState extends State<OwnerScreen> {
//   double _rating = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Owner Screen"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Open messaging functionality here
//               // You can use a modal bottom sheet to show the messaging bar
//               showModalBottomSheet(
//                 context: context,
//                 builder: (context) => _buildMessagingBar(),
//               );
//             },
//             icon: Icon(Icons.message),
//           ),
//           IconButton(
//             onPressed: () {
//               // Open rating functionality here
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: Text("Rate this seller"),
//                   content: RatingBar.builder(
//                     initialRating: _rating,
//                     minRating: 1,
//                     direction: Axis.horizontal,
//                     allowHalfRating: true,
//                     itemCount: 5,
//                     itemSize: 30.0,
//                     itemBuilder: (context, _) => Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                     onRatingUpdate: (rating) {
//                       setState(() {
//                         _rating = rating;
//                       });
//                     },
//                   ),
//                   actions: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text("Submit"),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             icon: Icon(Icons.star),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               backgroundImage: NetworkImage(
//                   'https://example.com/profile_picture.jpg'), // Replace with your profile picture URL
//               radius: 40,
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Owner Name",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text("owner@email.com"),
//                   Text("123-456-7890"),
//                   SizedBox(height: 16),
//                   RatingBar.builder(
//                     initialRating: _rating,
//                     minRating: 1,
//                     direction: Axis.horizontal,
//                     allowHalfRating: true,
//                     itemCount: 5,
//                     itemSize: 25.0,
//                     itemBuilder: (context, _) => Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                     onRatingUpdate: (rating) {
//                       setState(() {
//                         _rating = rating;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessagingBar() {
//     // Implement the messaging bar UI here
//     // For demonstration purposes, I'm using a simple messaging bar with a text field and send button
//     return Container(
//       color: Colors.grey[200],
//       padding: EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Type your message...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           IconButton(
//             onPressed: () {
//               // Implement the send message functionality here
//             },
//             icon: Icon(Icons.send),
//           ),
//         ],
//       ),
//     );
//   }
// }

//flutter pub add flutter_chat_bubble
//dependencies:
//  flutter_chat_bubble: ^2.0.2

// flutter pub add flutter_rating_bar
// dependencies:
//   flutter_rating_bar: ^4.0.1