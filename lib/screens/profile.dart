// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/screens/ingrident.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/saved_recipes.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isExpanded = false;
  final int _maxLines = 2;
  int selectedIndex = 0;

  Widget _buildTabButton(String text, int index) {
    final bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_sharp, color: Colors.black),
            onPressed: () {},
          ),
        ],
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/r1.png"),
                ),
                Column(
                  children: [
                    Text(
                      "Recipe",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: grey3,
                      ),
                    ),
                    Text(
                      "23",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Followers",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: grey3,
                      ),
                    ),
                    Text(
                      "45M",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Following",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: grey3,
                      ),
                    ),
                    Text(
                      "243",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Michael Smith",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  "Private chef with a passion for creating delicious and healthy meals. Follow me for recipes and cooking tips!",
                  maxLines: _isExpanded ? null : _maxLines,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: grey3,
                  ),
                ),
                SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Show less' : 'More...',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _buildTabButton("Recipes", 0),
                _buildTabButton("Videos", 1),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 1.9,
                mainAxisSpacing: 12,
                children: List.generate(7, (index) {
                  return GestureDetector(
                    onTap: () {
                      print("Clicked the $index item ========");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => IngridentPage(
                                imagePath: 'assets/r2.png',
                                time: ' ${index + 10}',
                                title: 'Traditional ribs #$index',
                                rating: 4.0 + (index % 5) * 0.1,
                                creator: 'Anand',
                              ),
                        ),
                      );
                    },
                    child: SavedRecipes(
                      imagePath: 'assets/r1.png',
                      title: 'Traditional ribs #$index',
                      rating: 4.0 + (index % 5) * 0.1,
                      creator: 'Anand',
                      time: '20',
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
