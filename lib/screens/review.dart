// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:recipe/utils/root.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        // This will trigger a rebuild every minute
      });
    });
    setState(() {
      reviewController.text = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    reviewController.dispose();
    super.dispose();
  }

  final TextEditingController reviewController = TextEditingController();
  List<dynamic> list = [
    {
      'review':
          "This recipe was amazing! I loved the flavors and the ease of preparation.",
      'imageUrl': "assets/r2.png",
      'userName': "Master chef",
      'date': "July 12, 2023",
    },
  ];

  Timer? _timer;

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
    }
    if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    }
    if (diff.inDays == 1) return "Yesterday";
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Reviews",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Reviews",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${list.length} reviews",
                  style: GoogleFonts.poppins(fontSize: 16, color: grey3),
                ),
              ],
            ),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                hintText: "Write a review...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Submit button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  final newReview = reviewController.text.trim();
                  if (newReview.isNotEmpty) {
                    setState(() {
                      list.insert(0, {
                        'review': newReview,
                        'imageUrl': "assets/r2.png",
                        'userName': "Boss",
                        'date': getTimeAgo(DateTime.now()),
                      });
                      reviewController.clear();
                    });
                  }
                },
                child: Text(
                  "Submit",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final review = list[index];
                  return buildReviewCard(
                    review['review'] ?? '',
                    review['imageUrl'],
                    review['userName'],
                    review['date'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildReviewCard(
  String review,
  String? imageUrl,
  String? userName,
  String? date,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    imageUrl ?? 'assets/r2.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName ?? 'Master chef',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        date ?? "July 12, 2023",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: grey3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              review,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
