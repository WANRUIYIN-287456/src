import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_marketplace/a5_10_sellerotherservice.dart';
import 'package:local_service_marketplace/a5_9_sellerratingscreen.dart';
import 'package:local_service_marketplace/config.dart';
import 'package:local_service_marketplace/model/rating.dart';
import 'package:local_service_marketplace/model/user.dart';

class SellerProfileScreen extends StatefulWidget {
  final User user;
  final String sellerId;
  const SellerProfileScreen(
      {Key? key, required this.user, required this.sellerId}) : super(key: key);

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  String maintitle = "Service Provider Profile";
  late double screenHeight, screenWidth, cardwitdh;
  List<Rating> ratingList = <Rating>[];
  double meanRating = 0.0;

  @override
  void initState() {
    super.initState();
    print(maintitle);
    loadProfile();
    loadRatings();
    print(widget.user.id);
    print(widget.sellerId);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: screenWidth * 0.3,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${Config.server}/lsm/assets/images/profile/${widget.user.id}.png",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(
                        "${Config.server}/lsm/assets/images/profile/0.png",
                        scale: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(""),
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Divider(),
                        Text(widget.user.email.toString()),
                        Text(widget.user.phone.toString()),
                        Text(df.format(
                            DateTime.parse(widget.user.datereg.toString()))),
                        const Text("")
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.background,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text("Service Provider Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Column(
            children: [
              Expanded(
                  child: ListView(
                children: [

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (content) => SellerRatingScreen(
                            user: widget.user,
                            sellerId: widget.sellerId,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(25,20, 8, 15),
                          child: RatingBar(
                            initialRating: meanRating,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 45,
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
                        ),
                        Text("   " + meanRating.toStringAsFixed(1), style: TextStyle(fontSize: 30),), // Display mean rating
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => SellerOrtherService(
                                  user: widget.user, sellerId: widget.sellerId)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 50, 15, 0),
                      child: Row(
                        children: const [
                          Icon(Icons.home_repair_service_rounded),
                          SizedBox(width: 15),
                          Text("More from this service provider", style: TextStyle(fontSize: 16),),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ))
        ]),
      ),
    );
  }

  void loadProfile() {
    http.post(Uri.parse("${Config.server}/lsm/php/load_profile.php"), body: {
      if (widget.user.id != "na") "userid": widget.sellerId,
    }).then((response) {
      print(response.body);
      try {
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          var jsondata = jsonDecode(response.body);
          //print(jsondata['data']);
          if (jsondata['status'] == 'success') {
            var extractdata = jsondata['data'];
            setState(() {
              widget.user.name = extractdata['name'];
              widget.user.email = extractdata['email'];
              widget.user.phone = extractdata['phone'];
              widget.user.datereg = extractdata['datereg'];
            });
          } else {
            print(1);
          }
        } else {
          print(2);
        }
      } catch (e, _) {
        debugPrint(e.toString());
      }
    });
  }

  void loadRatings() {
  http.post(Uri.parse("${Config.server}/lsm/php/load_ratingssellerprofile.php"),
      body: {"sellerid": widget.sellerId}).then((response) {
    ratingList.clear();
    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "success") {
        var extractData = jsonData['data'];
          for (var v in extractData) {
            ratingList.add(Rating.fromJson(v));
          }
          setState(() {
            
          });
          calculateMeanRating();
        
      }
    }
  });
}


  void calculateMeanRating() {
    if (ratingList.isNotEmpty) {
      double sum = 0;
      for (var rating in ratingList) {
        sum += double.parse(rating.rating.toString()); // Assuming 'rating' attribute holds the rating value
      }
      meanRating = sum / ratingList.length;
    }
  }
}
