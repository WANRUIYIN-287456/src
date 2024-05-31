import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("(Main) Token: $fcmToken");

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  

    // Set up message handler when the app is in the foreground
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set up message handler for when the app is in the foreground or background
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message received: ${message.notification?.body}");
      // Handle the message here
    });

    // Set up message handler for when the app is terminated and opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked when app is terminated: ${message.notification?.body}");
      // Handle the message here
      
    });

  }
}

//push local notifications
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseApi {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications(BuildContext context) async {
//     // Request permission for receiving FCM messages
//     await _firebaseMessaging.requestPermission();

//     // Get the FCM token
//     final String? fcmToken = await _firebaseMessaging.getToken();
//     print("(Main) Token: $fcmToken");

//     // Set up background message handler
//     FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

//     // Set up message handler for when the app is in the foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Foreground Message received: ${message.notification?.body}");
//       // Handle the message here
//       _displayNotification(message.notification?.title, message.notification?.body, context);
//     });

//     // Set up message handler for when the app is terminated and opened from a notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Message clicked when app is terminated: ${message.notification?.body}");
//       // Handle the message here
//       Navigator.pushNamed(context, '/'); // Replace '/' with the route to your mainscreen.dart
//     });
//   }

//   Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     print('Title: ${message.notification?.title}');
//     print('Body: ${message.notification?.body}');
//     print('Payload: ${message.data}');
//     // Handle the message here
//   }

//   void _displayNotification(String? title, String? body, BuildContext context) {
//     // Display notification in the system tray
//     if (Platform.isAndroid) {
//       // For Android
//       final notification = AndroidNotificationDetails(
//         'channel_id',
//         'channel_name',
//         'channel_description',
//         priority: Priority.high,
//         importance: Importance.max,
//       );
//       final platformChannelSpecifics = NotificationDetails(android: notification);
//       FlutterLocalNotificationsPlugin().show(
//         0,
//         title,
//         body,
//         platformChannelSpecifics,
//       );
//     } else if (Platform.isIOS) {
//       // For iOS
//       final notification = IOSNotificationDetails();
//       final platformChannelSpecifics = NotificationDetails(iOS: notification);
//       FlutterLocalNotificationsPlugin().show(
//         0,
//         title,
//         body,
//         platformChannelSpecifics,
//       );
//     }

//     // Display in-app notification
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(body ?? ''),
//         action: SnackBarAction(
//           label: 'OK',
//           onPressed: () {
//             // Handle action if needed
//           },
//         ),
//       ),
//     );
//   }
// }
