// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:recipe/screens/main_page.dart';
import 'package:recipe/screens/new_recipe.dart';
import 'package:recipe/screens/notifications.dart';
import 'package:recipe/screens/profile.dart';
import 'package:recipe/screens/saved.dart';
import 'package:recipe/utils/root.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int currentIndex = 0;

class _HomePageState extends State<HomePage> {
  static const List<Widget> _pages = [
    MainPage(),
    SavedRecipePage(),
    Notifications(),
    Profile(),
  ];

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
              buildTabIcon("assets/icons/home.png", 0),
              buildTabIcon("assets/icons/bookmark.png", 1),
              SizedBox(width: 30),
              buildTabIcon("assets/icons/notification.png", 2),
              buildTabIcon("assets/icons/person.png", 3),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: IndexedStack(
          key: ValueKey<int>(currentIndex),
          index: currentIndex,
          children: _pages,
        ),
      ),
    );
  }

  Widget buildTabIcon(String asset, int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
      icon: Image.asset(
        asset,
        color: currentIndex == index ? primaryColor : grey,
      ),
    );
  }
}
