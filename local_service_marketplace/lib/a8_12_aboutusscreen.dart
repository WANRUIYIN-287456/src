import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  late double screenHeight, screenWidth, cardWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: screenHeight * 0.2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/splash.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Welcome to Local Service Marketplace (LSM)", style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(
                        "Your go-to mobile application for accessing a wide range of local services tailored for Malaysian consumers. In today's digital age, where mobile applications drive marketing strategies, LSM stands out as a specialized platform focusing on local service provision.",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Our aim is to bridge the gap between service providers and consumers, offering a seamless experience that prioritizes user convenience and satisfaction. With LSM, users can effortlessly browse through various service categories, find certified technicians, and book appointments with just a few taps.",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "We prioritize user security and control, implementing robust authentication measures and a password recovery system to safeguard personal information. Our platform also features comprehensive service listings, search and filter functions for quick identification of suitable providers, and recommendations based on user location.",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Moreover, LSM promotes transparency and trust through a rating and review system, ensuring users can make informed decisions based on others' experiences. We facilitate secure booking, appointment scheduling, and online payments, with dedicated support to resolve any disputes between consumers and service providers.",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Join us in revolutionizing the local service landscape, saving time and effort while ensuring satisfactory outcomes for all parties involved. Experience the ease and efficiency of LSM, where convenience meets quality service.",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please note that this app is a final year project developed by a student at Northern University of Malaysia, pursuing a Bachelor of Science with Honours in Information Technology. The student's matriculation number is 287456. This app has not been commercialized for common use yet. The details used in the app, such as user details, order details, etc., are for testing purposes and do not represent real data. Please stay tuned for updates. For any copyright issues, please contact the author via email localservicemarketplace@gmail.com.",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "We sincerely appreciate your interest and support. Thank you for being a part of our journey.",
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
