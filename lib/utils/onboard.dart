// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/widgets.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder(
            future: user.reload(),
            builder: (context, reloadSnapshot) {
              if (reloadSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final refreshedUser = FirebaseAuth.instance.currentUser;
              if (refreshedUser == null) {
                FirebaseAuth.instance.signOut(); // Clear local session
                return _buildOnboardUI(context);
              }
              Future.microtask(() {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              });
              return const SizedBox.shrink();
            },
          );
        }
        return _buildOnboardUI(context); // Show onboarding for not logged in
      },
    );
  }

  Widget _buildOnboardUI(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/chef.png', height: 70, width: 70),
                    ],
                  ),
                  Column(
                    children: [
                      textBold("Get\nCooking", 60, color: whiteColor),
                      const SizedBox(height: 30),
                      textBold(
                        "Simple way to find Tasty Recipe",
                        20,
                        color: whiteColor,
                      ),
                    ],
                  ),
                  primaryButton("Start Cooking", () {
                    Navigator.pushReplacementNamed(context, '/signup');
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
