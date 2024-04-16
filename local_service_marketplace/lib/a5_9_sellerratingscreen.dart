import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/order.dart';
import 'package:local_service_marketplace/model/rating.dart';
import 'package:local_service_marketplace/model/user.dart';

class SellerRatingScreen extends StatefulWidget {
  final User user;
  final String sellerId;
  const SellerRatingScreen(
      {super.key, required this.user, required this.sellerId});

  @override
  State<SellerRatingScreen> createState() => _SellerRatingScreenState();
}

class _SellerRatingScreenState extends State<SellerRatingScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  String maintitle = "All Reviews";
  List<Rating> ratingList = <Rating>[];
  double meanRating = 0.0;
  double rating = 0.0;

  late User user = User(
    id: "na",
    name: "na",
    email: "na",
    phone: "na",
    datereg: "na",
    password: "na",
    otp: "na",
  );
  late Order order = Order();

  @override
  void initState() {
    super.initState();
    loadRatings();
    print(ratingList.length);
    print(maintitle);
    print("user" + widget.user.id.toString());
    print("seller" + widget.sellerId);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: ratingList.isEmpty
          ? Center(
              child: Column(
              children: [
                Container(
                  height: 350,
                  alignment: Alignment.center,
                  child: const Text("No Data"),
                )
              ],
            ))
          : Column(children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 20, 20, 0),
                      child: Row(
                        children: [
                          RatingBar(
                        initialRating: meanRating,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 40,
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color: Colors.amber),
                          half: Icon(Icons.star_half, color: Colors.amber),
                          empty: Icon(Icons.star_border, color: Colors.amber),
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            meanRating = rating;
                          });
                        },
                        ignoreGestures: true,
                      ),
                      SizedBox(width: 20,),
                      Text(meanRating.toStringAsFixed(1), style: TextStyle(fontSize: 30)), // Display mean rating
                        ],
                      )
                    ),
                  ),
                  
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: ratingList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CachedNetworkImage(
                                  width: screenWidth * 0.15,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${Config.server}/lsm/assets/images/profile/${ratingList[index].userId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  ratingList[index].userName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                
                              ],
                            ),
                            const SizedBox(height: 5),
                             Container(
                              alignment: Alignment.topLeft,
                               child: Text(
                                    DateFormat('dd-MM-yyyy').format(DateTime.parse(ratingList[index].ratingDate.toString())),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                             ),
                                const SizedBox(height: 5),
                                 Container(
                              alignment: Alignment.topLeft,
                               child: Text(
                              "Variation:" + ratingList[index].serviceName.toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                             ),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 10,10),
                                    child: RatingBar(
                                      initialRating: double.parse(
                                              ratingList[index].rating.toString()),
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      ratingWidget: RatingWidget(
                                        full: Icon(Icons.star, color: Colors.amber),
                                        half: Icon(Icons.star_half,
                                            color: Colors.amber),
                                        empty: Icon(Icons.star_border,
                                            color: Colors.amber),
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          rating = double.parse(
                                              ratingList[index].rating.toString());
                                        });
                                      },
                                      ignoreGestures: true,
                                    ),
                                  ),
                                ),
                                Text(double.parse(
                                        ratingList[index].rating.toString())
                                    .toStringAsFixed(1)), // Display mean rating
                              ],
                            ),
                             Container(
                              alignment: Alignment.topLeft,
                               child: Text(ratingList[index].review.toString() + "\n\n", style: TextStyle(fontSize: 18)),
                             ),
                           
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
    );
  }

  void loadRatings() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_ratingssellerprofile.php"),
        body: {"sellerid": widget.sellerId}).then((response) {
      print(response.body);
      //log(response.body);
      ratingList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          for (var v in extractdata) {
            ratingList.add(Rating.fromJson(v));
          }
          if (ratingList.isNotEmpty) {
            print(ratingList[0].sellerId);
          }
        }
        calculateMeanRating();
        setState(() {});
      }
    });
  }

  void calculateMeanRating() {
    if (ratingList.isNotEmpty) {
      double sum = 0;
      for (var rating in ratingList) {
        sum += double.parse(rating.rating
            .toString()); // Assuming 'rating' attribute holds the rating value
      }
      meanRating = sum / ratingList.length;
    }
  }

 
}
