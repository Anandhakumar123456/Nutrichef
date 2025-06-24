// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe/screens/auth/signup.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/widgets.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: screenHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: screenHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/chef.png', height: 70, width: 70),
                      SizedBox(height: 8),
                      textBold("100K+ Premium Recipes", 20, color: whiteColor),
                    ],
                  ),
                  Column(
                    children: [
                      textBold("Get\nCooking", 60, color: whiteColor),
                      SizedBox(height: 30),
                      textBold(
                        "Simple way to find Tasty Recipe",
                        20,
                        color: whiteColor,
                      ),
                    ],
                  ),
                  primaryButton("Start Cookiing", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  }, true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
