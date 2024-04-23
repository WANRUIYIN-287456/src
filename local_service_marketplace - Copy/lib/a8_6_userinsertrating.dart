import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a5_9_sellerratingscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/user.dart';

class NewRatingScreen extends StatefulWidget {
  final Order order;
  const NewRatingScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<NewRatingScreen> createState() => _NewRatingScreenState();
}

class _NewRatingScreenState extends State<NewRatingScreen> {
  late double screenHeight, screenWidth;
  bool isRated = true;
  late DateTime servicedate;
  late Order order;
  late double rating = 0.0;
  final TextEditingController reviewEditingController = TextEditingController();
  late User user = User(
    id: "na",
    name: "na",
    email: "na",
    phone: "na",
    datereg: "na",
    password: "na",
    otp: "na",
  );
  late User user2 = User(
    id: "na",
    name: "na",
    email: "na",
    phone: "na",
    datereg: "na",
    password: "na",
    otp: "na",
  );

  @override
  void initState() {
    super.initState();
    loadseller(); //user == seller
    loaduser();
    loaduserorders();
    servicedate = DateTime.parse(widget.order.orderServicedate.toString());
    loadRatings(servicedate);
  }

  void loadRatings(DateTime servicedate) {
    http.post(Uri.parse("${Config.server}/lsm/php/load_ratings.php"), body: {
      "userid": widget.order.userId,
      "orderid": widget.order.orderId,
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          bool ratingStatus = extractdata['rating_status'] == "true";
          DateTime ratingDate = DateTime.parse(extractdata['rating_date']);

          if (ratingStatus && DateTime.now().difference(servicedate).inDays <= 30) {
            setState(() {
              isRated = true;
              rating = double.parse(extractdata['rating'].toString());
              reviewEditingController.text = extractdata['review'].toString();
            });
          } else {
            setState(() {
              isRated = false;
              rating = 0.0;
              reviewEditingController.text = '';
            });
          }
        } else {
          setState(() {
            isRated = false;
            rating = 0.0;
            reviewEditingController.text = '';
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isRatingDisabled = isRated && DateTime.now().difference(servicedate).inDays > 30;

    return Scaffold(
      appBar: AppBar(title: const Text("Rate Service")),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight / 4,
            child: Card(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: screenWidth * 0.4,
                    child: CachedNetworkImage(
                      imageUrl: "${Config.server}/lsm/assets/images/profile/${widget.order.userId}.png",
                      placeholder: (context, url) => const LinearProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(
                        "${Config.server}/lsm/assets/images/profile/0.png",
                        scale: 2,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      user.id == "na"
                          ? const Center(
                        child: Text("Loading..."),
                      )
                          : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(""),
                            Text(
                              "Name: ${user.name}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Phone: ${user.phone}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Order Status: ${widget.order.orderStatus}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 40,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                    ignoreGestures: isRatingDisabled,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      child: TextFormField(
                        maxLength: 500,
                        maxLines: 5,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val!.isEmpty || val.length > 500) {
                            return "Please enter a valid review with max 500 characters.";
                          }
                          return null;
                        },
                        onFieldSubmitted: (v) {
                          if (v.trim().length > 500) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Review cannot exceed 500 characters.")),
                            );
                          }
                        },
                        controller: reviewEditingController,
                        keyboardType: TextInputType.text,
                        readOnly: isRatingDisabled,
                        decoration: const InputDecoration(
                          labelText: 'Review',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isRatingDisabled ? null : submitRatings,
                    child: const Text("Rate Service"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void loaduserorders() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
      "sellerid": widget.order.sellerId,
      "orderid": widget.order.orderId,
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          order = Order.fromJson(jsondata['data']);
          setState(() {});
        } else {
          setState(() {});
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No Order Available.")));
        }
        setState(() {});
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Order Available.")));
      }
    });
  }

  void loadseller() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
      "userid": widget.order.sellerId,
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }

  void loaduser() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
      "userid": widget.order.userId,
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user2 = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }

  void submitRatings() {
    http.post(Uri.parse("${Config.server}/lsm/php/insert_ratings.php"), body: {
      "userid": widget.order.userId,
      "orderid": widget.order.orderId,
      "sellerid": widget.order.sellerId,
      "rating": rating.toString(),
      "review": reviewEditingController.text,
      "ratingstatus": "true",
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Rate Success")));
          setState(() {});
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Rate Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }
}


// import 'dart:convert';
// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:local_service_marketplace/a5_9_sellerratingscreen.dart';
// import 'package:local_service_marketplace/config.dart';
// import 'package:local_service_marketplace/model/order.dart';
// import 'package:local_service_marketplace/model/user.dart';

// class NewRatingScreen extends StatefulWidget {
//   final Order order;
//   const NewRatingScreen({super.key, required this.order});

//   @override
//   State<NewRatingScreen> createState() => _NewRatingScreenState();
// }

// class _NewRatingScreenState extends State<NewRatingScreen> {
//   final df = DateFormat('dd-MM-yyyy hh:mm a');
//   late double screenHeight, screenWidth;
//   bool isRated = true;
//   late DateTime servicedate;
//   late Order order;
//   late double rating =0.0;
//   final TextEditingController reviewEditingController = TextEditingController();
//   late User user = User(
//       id: "na",
//       name: "na",
//       email: "na",
//       phone: "na",
//       datereg: "na",
//       password: "na",
//       otp: "na");
//         late User user2 = User(
//       id: "na",
//       name: "na",
//       email: "na",
//       phone: "na",
//       datereg: "na",
//       password: "na",
//       otp: "na");

//   @override
//   void initState() {
//     super.initState();
//     loadseller(); //user == seller
//     loaduser();
//     loaduserorders();
//     servicedate = DateTime.parse(widget.order.orderServicedate.toString());
//     loadRatings(servicedate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(title: const Text("Rate Service")),
//       body: Column(
//         children: [
//           SizedBox(
//             //flex: 3,
//             height: screenHeight / 4,
//             child: Card(
//                 child: Row(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.all(10),
//                   width: screenWidth * 0.4,
//                   child: CachedNetworkImage(
//                       imageUrl:
//                           "${Config.server}/lsm/assets/images/profile/${widget.order.userId}.png",
//                       placeholder: (context, url) =>
//                           const LinearProgressIndicator(),
//                       errorWidget: (context, url, error) => Image.network(
//                             "${Config.server}/lsm/assets/images/profile/0.png",
//                             scale: 2,
//                           )),
//                 ),
//                 Column(
//                   children: [
//                     user.id == "na"
//                         ? const Center(
//                             child: Text("Loading..."),
//                           )
//                         : Padding(
//                             padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(""),
//                                 Text("Name: ${user.name}",
//                                     style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold)),
//                                 Text("Phone: ${user.phone}",
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                     )),
//                                 Text(
//                                     "Order Status: ${widget.order.orderStatus}",
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                     )),
//                               ],
//                             ),
//                           )
//                   ],
//                 )
//               ],
//             )),
//           ),
//           Expanded(child: SingleChildScrollView(
//             child: Column(children: [
//               const SizedBox( height: 20,),
//           //FOR RATING
//             RatingBar.builder(
//               initialRating: rating,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: false,
//               itemCount: 5,
//               itemSize: 40,
//               itemBuilder: (context, _) => const Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (newRating) {
//                 setState(() {
//                   rating = newRating;
//                 });
//               },
//             ),
//             const SizedBox( height: 10,),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SizedBox(
//                 child: TextFormField(
//                   maxLength: 500,
//                   maxLines: 5,
//                   textInputAction: TextInputAction.next,
//                   validator: (val) {
//                     if (val!.isEmpty || val.length > 500) {
//                       return "Please enter a valid review with max 500 characters.";
//                     }
//                     return null;
//                   },
//                   onFieldSubmitted: (v) {
//                     if (v.trim().length > 500) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text("Review cannot exceed 500 characters.")),
//                       );
//                     }
//                   },
//                   controller: reviewEditingController,
//                   keyboardType: TextInputType.text,
//                   decoration: const InputDecoration(
//                     labelText: 'Review',
//                     //icon: Icon(Icons.reviews_outlined),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   submitRatings();
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (content) => SellerRatingScreen(user: user2, sellerId: widget.order.sellerId.toString())));
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Rate Service"))
//             ],),
//           ))
//         ],
//       ),
//     );
//   }

//   void loaduserorders() {
//     http.post(Uri.parse("${Config.server}/lsm/php/load_userorder.php"), body: {
//       "sellerid": widget.order.sellerId,
//       "orderid": widget.order.orderId,
//     }).then((response) {
//       print(response.statusCode);
//       log(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == "success") {
//           order = Order.fromJson(jsondata['data']);
//           setState(() {});
//         } else {
//           setState(() {});
//           Navigator.of(context).pop();
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("No Order Available.")));
//         }
//         setState(() {});
//       } else {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("No Order Available.")));
//       }
//     });
//   }

//   void loadseller() {
//     http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
//       "userid": widget.order.sellerId,
//     }).then((response) {
//       log(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == 'success') {
//           user = User.fromJson(jsondata['data']);
//         }
//       }
//       setState(() {});
//     });
//   }

//   void loaduser() {
//     http.post(Uri.parse("${Config.server}/lsm/php/load_user.php"), body: {
//       "userid": widget.order.userId,
//     }).then((response) {
//       log(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == 'success') {
//           user2 = User.fromJson(jsondata['data']);
//         }
//       }
//       setState(() {});
//     });
//   }

//   void loadRatings(DateTime servicedate) {
//     http.post(Uri.parse("${Config.server}/lsm/php/load_ratings.php"), body: {
//       "userid": widget.order.userId,
//       "orderid": widget.order.orderId,
//     }).then((response) {
//       log(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == 'success') {
//           var extractdata = jsondata['data'];
//           setState(() {
//             isRated = extractdata['rating_status'].toString() == "true" &&
//                 DateTime.now().difference(servicedate).inDays <= 30;
//           });
//         }
//       }
//     });
//   }

//   void submitRatings() {
//     http.post(Uri.parse("${Config.server}/lsm/php/insert_ratings.php"), body: {
//       "userid": widget.order.userId,
//       "orderid": widget.order.orderId,
//       "sellerid": widget.order.sellerId,
//       "rating": rating.toString(),
//       "review": reviewEditingController.text,
//       "ratingstatus": "true",
//     }).then((response) {
//       print(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == 'success') {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Rate Success")));
//           setState(() {});
//         } else {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Rate Failed")));
//         }
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Failed")));
//         Navigator.pop(context);
//       }
//     });
//   }
// }
