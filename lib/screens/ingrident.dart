// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/screens/review.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/star_rating.dart';
import 'package:recipe/utils/widgets.dart';
import 'package:video_player/video_player.dart';

class IngridentPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String creator;
  final String time;
  final double rating;
  const IngridentPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.creator,
    required this.time,
    required this.rating,
  });

  @override
  State<IngridentPage> createState() => _IngridentPageState();
}

class _IngridentPageState extends State<IngridentPage> {
  int selectedIndex = 0;
  late VideoPlayerController _controller;
  bool isFollowed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mkv')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => _showCustomPopup(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: <Widget>[
            selectedIndex == 0
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(widget.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffFFE9CA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.orange),
                              SizedBox(width: 3),
                              textBold("${widget.rating}", 13),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Row(
                          children: [
                            Icon(Icons.timer_outlined, color: Colors.white),
                            SizedBox(width: 6),
                            textRegular(
                              "${widget.time} Mins",
                              13,
                              color: whiteColor,
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                "assets/icons/bookmark.png",
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black12,
                    ),
                    child:
                        _controller.value.isInitialized
                            ? Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.black45,
                                    child: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : const Center(child: CircularProgressIndicator()),
                  ),
                ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textBold(widget.title, 22),
                        textRegular("(13K Reviews)", 14, color: grey),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Author and follow row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.asset(
                                'assets/r2.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textBold('Master chef', 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: 190,
                                      child: Text(
                                        maxLines: 2,
                                        "Tamilnadu, India",
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
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isFollowed ? primaryColor : grey2,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isFollowed = !isFollowed;
                                });
                                showSuccessSnackBar(
                                  context,
                                  !isFollowed
                                      ? "Followed successfully"
                                      : "Unfollowed successfully",
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isFollowed ? "Follow" : "Followed",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isFollowed
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    // Nutririon row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            buildNutrientItem(
                              "assets/icons/wheat.png",
                              "65g Carbs",
                            ),
                            SizedBox(height: 24),
                            buildNutrientItem(
                              "assets/icons/fire.png",
                              " 345g Kcal",
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            buildNutrientItem(
                              "assets/icons/meat.png",
                              " 26g Protein",
                            ),
                            SizedBox(height: 24),
                            buildNutrientItem(
                              "assets/icons/fat.png",
                              " 12g Fat",
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: grey2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton("Ingredients", 0),
                          _buildTabButton("Instructions", 1),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                'assets/icons/serve.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 6),
                          ],
                        ),
                        Text(
                          selectedIndex == 0 ? "10 Items" : "10 Steps",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: grey3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    selectedIndex == 0
                        ? Column(
                          children: List.generate(
                            8,
                            (index) => recipeItem(
                              'assets/${index + 1}.png',
                              'Banana',
                              '${(index + 1) * 100}g',
                            ),
                          ),
                        )
                        : Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: grey2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Step 1",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      lorem20,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: grey2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Step 2",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      lorem20,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: grey2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Step 3",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      lorem30,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: grey2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Step 4",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      lorem,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: grey2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Step 5",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      lorem30,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
            if (index == 1) {
              _controller.pause();
            } else {
              _controller.pause();
            }
          });
        },

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

void _showCustomPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5), // black fade effect
    builder: (context) {
      return Stack(
        children: [
          Positioned(
            top: kToolbarHeight + 20,
            right: 16,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 5,
              child: Container(
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: _buildPopupItem(context, Icons.share, "Share"),
                      onTap: () {
                        print("Share clicked");
                      },
                    ),
                    InkWell(
                      onTap: () => rateRecipe(context),
                      child: _buildPopupItem(
                        context,
                        Icons.star,
                        "Rate Recipe",
                      ),
                    ),
                    InkWell(
                      child: _buildPopupItem(context, Icons.reviews, "Review"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Reviews()),
                        );
                      },
                    ),
                    _buildPopupItem(context, Icons.bookmark_remove, "Unsave"),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void rateRecipe(BuildContext context) {
  showDialog(
    animationStyle: AnimationStyle(duration: Duration(milliseconds: 300)),
    context: context,
    barrierColor: Colors.black.withOpacity(0.5), // black fade effect
    builder: (context) {
      return Center(
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 5,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Rate Recipe",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StarRating(
                        initialRating: 1,
                        onRatingChanged: (rating) {
                          print("Rating changed to: $rating");
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        showSuccessSnackBar(
                          context,
                          "Rating submitted successfully!",
                        );
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Send",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildPopupItem(BuildContext context, IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.black),
        SizedBox(width: 12),
        Text(text),
      ],
    ),
  );
}
