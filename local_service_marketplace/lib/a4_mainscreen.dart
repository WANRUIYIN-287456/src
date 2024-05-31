// import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:local_service_marketplace/a5_0_hometabscreen.dart';
// import 'package:local_service_marketplace/a6_0_servicetabscreen.dart';
// import 'package:local_service_marketplace/a8_0_accounttabscreen.dart';
// import 'package:local_service_marketplace/a7_notificationtabscreen.dart';
// import 'package:local_service_marketplace/model/user.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MainScreen extends StatefulWidget {
//   final User user;
//   const MainScreen({Key? key, required this.user}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//  late List<Widget> tabchildren;
//   int _currentIndex = 0;
//   String maintitle = "Menu";
//  // List<Product> productList = <Product>[];
  
//   @override
//   void initState() {
//     super.initState();
//     print(widget.user.name);
//     print("MainScreen");
//     tabchildren = [
//       //key?
      
//       //BarterTabScreen(user: widget.user),
//       //ProductTabScreen(user: widget.user),
//       HomeTabScreen(user: widget.user),
//       ServiceTabScreen(user: widget.user),
//       NotificationTabScreen(user: widget.user),
//       AccountTabScreen(user: widget.user),
//     ];
//     _requestPermissions();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: tabchildren[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//           onTap: onTabTapped,
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _currentIndex,
//           items: const [
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.home,
//                 ),
//                 label: "Home"),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.home_repair_service,
//                 ),
//                 label: "Services"),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.notifications,
//                 ),
//                 label: "Notifications"),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.person,
//                 ),
//                 label: "Account"),
//           ]),
//     );
//   }

//   void onTabTapped(int value) {
//     setState(() {
//       _currentIndex = value;
//       if (_currentIndex == 0) {
//         maintitle = "Home";
//       } else if (_currentIndex == 1) {
//         maintitle = "Services";
//       } else if (_currentIndex == 2) {
//         maintitle = "Notifications";
//       } else if (_currentIndex == 3) {
//         maintitle = "Account";
//       } 
//     });
  
//   }

//  Future<void> _requestPermissions() async {
//   // Request Location Permission
//   if (!await Permission.location.isGranted) {
//     final status = await Permission.location.request();
//     if (status != PermissionStatus.granted) {
//       _showPermissionDeniedDialog("Location");
//     }
//   }

//   // Request Bluetooth Permission
//   if (!await Permission.bluetooth.isGranted) {
//     final status = await Permission.bluetooth.request();
//     if (status != PermissionStatus.granted) {
//       _showPermissionDeniedDialog("Bluetooth");
//     }
//   }

//   // Request Storage Permission
//   if (!await Permission.storage.isGranted) {
//     final status = await Permission.storage.request();
//     if (status != PermissionStatus.granted) {
//       await Permission.storage.request();
//        //_showPermissionDeniedDialog("Storage");
//     }
//   }

//   // Request Media Library Permission
//   if (!await Permission.mediaLibrary.isGranted) {
//     final status = await Permission.mediaLibrary.request();
//     if (status != PermissionStatus.granted) {
//       _showPermissionDeniedDialog("Media Library");
//     }
//   }
//     // // Request Notification Permission
//     if (!await Permission.notification.isGranted) {
//       final status = await Permission.notification.request();
//       if (status != PermissionStatus.granted) {
//         _showPermissionDeniedDialog("Notification");
//       }
//     }
//   // NOTE: Handling Internet Permission separately
//   var connectivityResult = await Connectivity().checkConnectivity();
//   if (connectivityResult == ConnectivityResult.none) {
//     _showPermissionDeniedDialog("Internet");
//   }
// }
// //Android Manifest :     <uses-permission android:name="android.permission.POST_NOTIFICATIONS" android:required="false"/>
//   void _showPermissionDeniedDialog(String permissionName) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Permission Required"),
//         content: Text(
//           "Denying the $permissionName permission will cause the application to behave unexpectedly.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//  }
//

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:local_service_marketplace/a5_0_hometabscreen.dart';
import 'package:local_service_marketplace/a6_0_servicetabscreen.dart';
import 'package:local_service_marketplace/a8_0_accounttabscreen.dart';
import 'package:local_service_marketplace/a7_notificationtabscreen.dart';
import 'package:local_service_marketplace/model/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Menu";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("MainScreen");
    tabchildren = [
      HomeTabScreen(user: widget.user),
      ServiceTabScreen(user: widget.user),
      NotificationTabScreen(user: widget.user),
      AccountTabScreen(user: widget.user),
    ];
    _requestPermissions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      switch (_currentIndex) {
        case 0:
          maintitle = "Home";
          break;
        case 1:
          maintitle = "Services";
          break;
        case 2:
          maintitle = "Notifications";
          break;
        case 3:
          maintitle = "Account";
          break;
      }
    });
  }

  Future<void> _requestPermissions() async {
    await _requestPermission(Permission.location, "Location");
    await _requestPermission(Permission.bluetooth, "Bluetooth");
    await _requestStoragePermission();
    await _requestPermission(Permission.mediaLibrary, "Media Library");
    await _requestPermission(Permission.notification, "Notification");

    // Check for internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showPermissionDeniedDialog("Internet");
    }
  }

  Future<void> _requestPermission(Permission permission, String permissionName) async {
    // Check if the permission is already granted
    if (await permission.isGranted) {
      print("$permissionName permission already granted.");
      return;
    }

    // Request the permission
    final status = await permission.request();
    print("Requested $permissionName permission: $status");

    // Check the result of the permission request
    if (status != PermissionStatus.granted) {
      _showPermissionDeniedDialog(permissionName);
    }
  }

  Future<void> _requestStoragePermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) { // Android 13 and above
      if (await Permission.manageExternalStorage.request().isGranted) {
        print("Manage External Storage permission granted.");
      } else {
        print("Requested Manage External Storage permission: ${await Permission.manageExternalStorage.status}");
        _showPermissionDeniedDialog("Manage External Storage");
      }
    } else { // Below Android 13
      if (await Permission.storage.request().isGranted) {
        print("Storage permission granted.");
      } else {
        print("Requested Storage permission: ${await Permission.storage.status}");
        _showPermissionDeniedDialog("Storage");
      }
    }
  }

  void _showPermissionDeniedDialog(String permissionName) {
    print("Permission denied for $permissionName");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Required"),
        content: Text(
          "Denying the $permissionName permission will cause the application to behave unexpectedly.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
