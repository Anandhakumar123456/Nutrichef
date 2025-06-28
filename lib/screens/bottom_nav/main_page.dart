// ignore_for_file: avoid_print

import 'package:recipe/utils/export.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> tabs = [
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("All", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Indian", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Italian", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("German", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Turkis", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Chinese", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Korean", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // textBold("🌤️ Good Morning ", 18),
                      // textBold("☀️ Good Afternoon ", 18),
                      // textBold("✨️ Good Evening ", 18),
                      textBold("Hello \$name", 28),
                      textRegular(
                        "What are you cooking today?",
                        18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Signed is with Google Successfully!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    child: Icon(Icons.search, size: 34, color: grey),
                  ),
                ],
              ),
              // Search and filter
              SizedBox(height: 20),
              SingleChildScrollView(
                // Edit
                padding: EdgeInsetsDirectional.only(start: 15),
                scrollDirection: Axis.horizontal,
                child: DefaultTabController(
                  length: 7,
                  child: Row(
                    children: [
                      ButtonsTabBar(
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(color: grey),
                        radius: 12,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        backgroundColor: primaryColor,
                        buttonMargin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        labelStyle: TextStyle(color: whiteColor),
                        tabs: tabs,
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                // Edit
                padding: EdgeInsetsDirectional.only(start: 17),
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 38,
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      FoodCard(
                        imagePath: "assets/r1.png",
                        title: "Tomato rice with egg",
                        time: "12",
                        rating: 4.1,
                      ),
                      SizedBox(width: 18),
                      FoodCard(
                        imagePath: "assets/r2.png",
                        title: "Veg rice",
                        time: "12",
                        rating: 4.1,
                      ),
                      SizedBox(width: 18),
                      FoodCard(
                        imagePath: "assets/r1.png",
                        title: "Veg rice",
                        time: "12",
                        rating: 4.1,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 5),
                  child: textBold("New Recipes", 22),
                ),
              ),
              // New Recipe
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      RecipeCard(
                        imagePath: 'assets/r1.png',
                        title: "Banana juice ",
                        time: "40",
                        rating: 4.8,
                      ),
                      SizedBox(height: 10),
                      RecipeCard(
                        imagePath: 'assets/r1.png',
                        title: "Banana juice ",
                        time: "40",
                        rating: 4.8,
                      ),
                      SizedBox(height: 10),
                      RecipeCard(
                        imagePath: 'assets/r1.png',
                        title: "Banana juice ",
                        time: "40",
                        rating: 4.8,
                      ),
                      SizedBox(height: 10),
                      RecipeCard(
                        imagePath: 'assets/r1.png',
                        title: "Banana juice ",
                        time: "40",
                        rating: 4.8,
                      ),
                      // SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
