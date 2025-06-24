// ignore_for_file: avoid_print

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:recipe/screens/new_recipe.dart';
import 'package:recipe/screens/notifications.dart';
import 'package:recipe/screens/profile.dart';
import 'package:recipe/screens/saved.dart';
import 'package:recipe/screens/search.dart';
import 'package:recipe/utils/root.dart';
import 'package:recipe/utils/foodcard.dart';
import 'package:recipe/utils/recipecard.dart';
import 'package:recipe/utils/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode _focusNode = FocusNode();
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.unfocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          //Create recipe
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRecipePage()),
          );
        },
        backgroundColor: primaryColor,
        child: Image.asset("assets/icons/chef-hat.png"),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Image.asset("assets/icons/home.png", color: Colors.grey),
                onPressed: () {
                  // showModalBottomSheet(
                  //   context: context,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(20),
                  //     ),
                  //   ),
                  //   builder:
                  //       (context) => BottomSheetScrollableContainer(
                  //         children: [
                  //           Text("Hello World", style: TextStyle(fontSize: 18)),
                  //           SizedBox(height: 10),
                  //           Text(
                  //             "This is a sample bottom sheet",
                  //             style: TextStyle(fontSize: 16),
                  //           ),
                  //         ],
                  //       ),
                  // );
                },
              ),
              IconButton(
                icon: Image.asset(
                  "assets/icons/bookmark.png",
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SavedRecipePage()),
                  );
                },
              ),
              SizedBox(width: 30),
              IconButton(
                icon: Image.asset(
                  "assets/icons/notification.png",
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                },
              ),
              IconButton(
                icon: Image.asset(
                  "assets/icons/person.png",
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 60),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textBold("Hello \$name", 28),
                      textRegular("What are you cooking today?", 14),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Signed is with Google Successfully!");
                    },
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.1),
                        //     spreadRadius: 1,
                        //     blurRadius: 8,
                        //     offset: Offset(0, 3),
                        //   ),
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/google.png"),
                      ),
                    ),
                  ),
                ],
              ),
              // Search and filter
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child:
                        // TextField(
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //     prefixIcon: Image.asset(
                        //       "assets/icons/search.png",
                        //       color: Colors.grey,
                        //     ),
                        //     hintText: "Search recipe",
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        // ),
                        TextField(
                          readOnly: true, // prevents keyboard from opening
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            prefixIcon: Image.asset(
                              "assets/icons/search.png",
                              color: Colors.grey,
                            ),
                            hintText: "Search recipe",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/filter.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      RecipeCard(
                        imagePath: 'assets/r1.png',
                        title: "Banana juice ",
                        time: "40",
                        rating: 4.8,
                      ),
                      RecipeCard(
                        imagePath: 'assets/r1.png',
                        title: "Banana juice ",
                        time: "40",
                        rating: 4.8,
                      ),
                      SizedBox(width: 8),
                      RecipeCard(
                        imagePath: 'assets/r1.png',
                        title: "Banana juice ",
                        time: "40",
                        rating: 4.8,
                      ),

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
